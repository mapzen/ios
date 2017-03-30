//
//  Marker.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

/// Enum for common marker types supported by all the house styles.
@objc public enum MarkerType : Int {
  case currentLocation, searchPin, routeLine
}

/// Generic marker protocol definition.
@objc(MZGenericMarker)
public protocol GenericMarker {
  /// The underlying Tangram marker object. Use this only for advanced cases where features of the Marker class aren't supported.
  var tgMarker: TGMarker { get }
  /// The coordinates that the marker should be placed at on the map. Note that point, polyline, and polygon are mutually exclusive. Setting one will overwrite the other values
  var point: TGGeoPoint { get set }
  /// The polyline that should be displayed on the map. Note that point, polyline, and polygon are mutually exclusive. Setting one will overwrite the other values
  var polyline: TGGeoPolyline? { get set }
  /// The polygon that should be displayed on the map. Note that point, polyline, and polygon are mutually exclusive. Setting one will overwrite the other values
  var polygon: TGGeoPolygon? { get set }
  /// The image that should be displayed on the marker. This cannot be used with polylines or polygons, only points.
  var icon: UIImage? { get set }
  /// Toggles the marker visibility.
  var visible: Bool { get set }
  /// The marker draw order relative to other markers. Note that higher values are drawn above lower ones.
  var drawOrder: Int { get set }
  /// Sets the size of a point marker. Does nothing when a polyline or polygon is set.
  var size: CGSize { get set }
  /// Sets the marker background color. Default value is white.
  var backgroundColor: UIColor { get set }
  /// If the marker is interactive, it is able to be selected and delegates can receive callbacks for these events. Default value is true.
  var interactive: Bool { get set }
  /// Should only be used when a marker is initialized with a MarkerType. Updates the visual properties to indicate active status (ie. updates search pin to be gray when inactive).
  var active: Bool { get set }
  /**
   Animates the marker from its current coordinates to the ones given.
   
   - parameter coordinates: Coordinates to animate the marker to
   - parameter seconds: Duration in seconds of the animation.
   - parameter easeType: Easing to use for animation.
  */
  func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool
  /// Returns a marker whose visual properties have been defined by a house style. Do not try to update the background color, size or other visual aspects of this marker.
  static func initWithMarkerType(_ markerType: MarkerType) -> GenericMarker
  /// Default initializer.
  init()
  /**
   Initializes a marker with a given size.
   
   - parameter size: The size the marker should be.
   */
  init(size s: CGSize)
}

/**
 Base implementation for the GenericMarker protocol
 */
public class Marker : NSObject, GenericMarker {

  private static let kPointStyle = "points"
  private static let kLineStyle = "lines"
  private static let kPolygonStyle = "polygons"
  private static let kDefaultBackgroundColor = UIColor.white
  private static let kDefaultInteractive = true
  private static let kDefaultSize = CGSize.zero
  private static let kDefaultActive = true

  var styleType = Marker.kPointStyle
  var markerType: MarkerType?

  // all marker types have an associated styling path
  private let typeToStylingPath = [MarkerType.currentLocation : "layers.mz_current_location_gem.draw.ux-location-gem-overlay",
                                   MarkerType.searchPin : "layers.mz_search_result.draw.ux-icons-overlay",
                                   MarkerType.routeLine : "layers.mz_route_line.draw.ux-route-line-overlay"]
  //currently only search results have an inactive state
  private let typeToInactiveStylingPath = [MarkerType.searchPin : "layers.mz_search_result.inactive.draw.ux-icons-overlay"]

  private let internalTgMarker: TGMarker
  private var userUpdatedSize = false

  /// The underlying Tangram marker object. Use this only for advanced cases where features of the Marker class aren't supported.
  public var tgMarker: TGMarker {
    get {
      return internalTgMarker
    }
  }

  /// The coordinates that the marker should be placed at on the map. Note that point, polyline, and polygon are mutually exclusive. Setting one will overwrite the other values
  public var point: TGGeoPoint {
    set {
      tgMarker.point = newValue
      styleType = Marker.kPointStyle
      updateStyleString()
    }
    get {
      return tgMarker.point
    }
  }

  /// The polyline that should be displayed on the map. Note that point, polyline, and polygon are mutually exclusive. Setting one will overwrite the other values
  public var polyline: TGGeoPolyline? {
    set {
      guard let l  = newValue else { return }
      tgMarker.polyline = l
      styleType = Marker.kLineStyle
      updateStyleString()
    }
    get {
      return tgMarker.polyline
    }
  }

  /// The polygon that should be displayed on the map. Note that point, polyline, and polygon are mutually exclusive. Setting one will overwrite the other values
  public var polygon: TGGeoPolygon? {
    set {
      guard let p = newValue else { return }
      tgMarker.polygon = p
      styleType = Marker.kPolygonStyle
      updateStyleString()
    }
    get {
      return tgMarker.polygon
    }
  }

  /// The image that should be displayed on the marker. Updates the size of the marker to be the intrinsic size of the image. This cannot be used with polylines or polygons, only points.
  public var icon: UIImage? {
    set {
      guard let i = newValue else { return }
      tgMarker.icon = i
      size = i.size
      styleType = Marker.kPointStyle
      updateStyleString()
    }
    get {
      return tgMarker.icon
    }
  }

  /// Toggles the marker visibility.
  public var visible: Bool {
    set {
      tgMarker.visible = newValue
    }
    get {
      return tgMarker.visible
    }
  }

  /// The marker draw order relative to other markers. Note that higher values are drawn above lower ones.
  public var drawOrder: Int {
    set {
      tgMarker.drawOrder = newValue
    }
    get {
      return tgMarker.drawOrder
    }
  }

  /// Sets the size of a point marker. Does nothing when a polyline or polygon is set.
  public var size: CGSize {
    didSet {
      userUpdatedSize = true
      updateStyleString()
    }
  }

  /// Sets the marker background color. Default value is white.
  public var backgroundColor: UIColor {
    didSet {
      updateStyleString()
    }
  }

  /// If the marker is interactive, it is able to be selected and delegates can receive callbacks for these events. Default value is true.
  public var interactive: Bool {
    didSet {
      updateStyleString()
    }
  }

  /// Should only be used when a marker is initialized with a MarkerType. Updates the visual properties to indicate active status (ie. updates search pin to be gray when inactive).
  public var active: Bool {
    didSet {
      updateStylePath()
    }
  }

  /**
   Animates the marker from its current coordinates to the ones given.

   - parameter coordinates: Coordinates to animate the marker to
   - parameter seconds: Duration in seconds of the animation.
   - parameter easeType: Easing to use for animation.
   */
  public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    return tgMarker.setPointEased(coordinates, seconds: seconds, easeType: ease)
  }

  /// Returns a marker whose visual properties have been defined by a house style. Do not try to update the background color, size or other visual aspects of this marker.
  public static func initWithMarkerType(_ markerType: MarkerType) -> GenericMarker {
    let marker = Marker(markerType: markerType)
    return marker
  }

  /// Default initializer.
  public required override init() {
    internalTgMarker = TGMarker.init()
    size = Marker.kDefaultSize
    backgroundColor = Marker.kDefaultBackgroundColor
    interactive = Marker.kDefaultInteractive
    active = Marker.kDefaultActive
  }

  //TODO: add back when https://github.com/tangrams/tangram-es/issues/1394 is fixed
  //  public convenience init(icon i: UIImage?) {
  //    if let sz = i?.size {
  //      self.init(size: sz)
  //    } else {
  //      self.init(size: Marker.kDefaultSize)
  //    }
  //    icon = i
  //  }

  /**
   Initializes a marker with a given size.

   - parameter size: The size the marker should be.
   */
  public required init(size s: CGSize) {
    internalTgMarker = TGMarker.init()
    size = s
    backgroundColor = Marker.kDefaultBackgroundColor
    interactive = Marker.kDefaultInteractive
    active = Marker.kDefaultActive
    super.init()
    defer {
      size = s
    }
  }

  init(tgMarker tgM: TGMarker) {
    internalTgMarker = tgM
    size = Marker.kDefaultSize
    backgroundColor = Marker.kDefaultBackgroundColor
    interactive = Marker.kDefaultInteractive
    active = Marker.kDefaultActive
  }

  convenience init(markerType mt: MarkerType) {
    self.init(size: Marker.kDefaultSize)
    markerType = mt
    tgMarker.stylingPath = typeToStylingPath[mt]! //there is always a styling string for a given MarkerType so force unwrap
  }

  // MARK : private
  private func updateStyleString() {
    if !tgMarker.stylingPath.isEmpty {
      return
    }

    var str: String
    switch styleType {
    case Marker.kPointStyle:
      str = generateStyleStringWithSize()
      break;
    case Marker.kLineStyle,
         Marker.kPolygonStyle:
      str = generateBasicStyleString()
      break;
    default:
      str = generateStyleStringWithSize()
    }
    tgMarker.stylingString = str
  }

  private func generateBasicStyleString() -> String {
    return "{ style: '\(styleType)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive) }"
  }

  private func generateStyleStringWithSize() -> String {
    if !userUpdatedSize { return generateBasicStyleString() }
    return "{ style: '\(styleType)', color: '\(backgroundColor.hexValue())', size: [\(size.width)px, \(size.height)px], collide: false, interactive: \(interactive) }"
  }

  private func updateStylePath() {
    guard let type = markerType else { return }

    var path: String?
    if active {
      path = typeToStylingPath[type]
    } else {
      path = typeToInactiveStylingPath[type]
    }

    if let currPath = path {
      tgMarker.stylingPath = currPath
    }
  }
}
