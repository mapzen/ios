//
//  Marker.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

/// Generic marker protocol definition.
@objc(MZGenericMarker)
public protocol GenericMarker {
  /// The underlying Tangram marker object. Use this only for advanced cases where features of the Marker class aren't supported.
  var tgMarker: TGMarker { get }
  /// Toggles the marker visibility.
  var visible: Bool { get set }
  /// The marker draw order relative to other markers. Note that higher values are drawn above lower ones.
  var drawOrder: Int { get set }
}

/// Generic geometric marker protocol definition.
@objc(MZGenericGeometricMarker)
public protocol GenericGeometricMarker: GenericMarker {
  /// If the marker is interactive, it is able to be selected and delegates can receive callbacks for these events. Default value is true.
  var interactive: Bool { get set }
  /// Sets the marker background color. Default value is white.
  var backgroundColor: UIColor { get set }
  /// Default initializer.
  init()
}

/// Generic point marker protocol definition.
@objc(MZGenericPointMarker)
public protocol GenericPointMarker: GenericMarker {
  /// The coordinates that the marker should be placed at on the map.
  var point: TGGeoPoint { get set }

  /**
   Animates the marker from its current coordinates to the ones given.

   - parameter coordinates: Coordinates to animate the marker to
   - parameter seconds: Duration in seconds of the animation.
   - parameter easeType: Easing to use for animation.
   */
  func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool

}

@objc(MZGenericPointIconMarker)
public protocol GenericPointIconmarker: GenericGeometricMarker, GenericPointMarker {
  /// The image that should be displayed on the marker.
  var icon: UIImage? { get set }
  /// Sets the size of the marker.
  var size: CGSize { get set }
  /**
   Initializes a marker with a given size.

   - parameter size: The size the marker should be.
   */
  init(size s: CGSize)
}

/// Generic polyline marker protocol definition.
@objc(MZGenericPolylineMarker)
public protocol GenericPolylineMarker: GenericGeometricMarker {
  /// The polyline that should be displayed on the map.
  var polyline: TGGeoPolyline? { get set }
  /// The width of the stroke to draw the polyline.
  var strokeWidth: Int { get set }
}

/// Generic polygon marker protocol definition.
@objc(MZGenericPolygonMarker)
public protocol GenericPolygonMarker: GenericGeometricMarker {
  /// The polygon that should be displayed on the map.
  var polygon: TGGeoPolygon? { get set }
}

/// Generic system point marker protocol definition.
@objc(MZGenericSystemPointMarker)
public protocol GenericSystemPointMarker: GenericPointMarker {
  /// Updates the visual properties to indicate active status (ie. updates search pin to be gray when inactive).
  var active: Bool { get set }
  /// Returns a marker whose visual properties have been defined by a house style.
  static func initWithMarkerType(_ markerType: PointMarkerType) -> GenericSystemPointMarker
}

/// Generic system geometric marker protocol definition.
@objc(MZGenericSystemPolylineMarker)
public protocol GenericSystemPolylineMarker: GenericMarker {
  /// The polyline that should be displayed on the map.
  var polyline: TGGeoPolyline? { get set }
}

/// Base class for generic markers. Do not instantiate this class directly, use one of the more meaningful subclasses.
public class Marker : NSObject, GenericMarker {

  private let internalTgMarker: TGMarker

  /// The underlying Tangram marker object. Use this only for advanced cases where features of the Marker class aren't supported.
  public var tgMarker: TGMarker {
    get {
      return internalTgMarker
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

  public override init() {
    internalTgMarker = TGMarker.init()
  }

  init(tgMarker tgM: TGMarker) {
    internalTgMarker = tgM
  }

}

/// Base class for geometric markers. Do not instantiate this class directly, use one of the more meaningful subclasses.
public class GeometricMarker : Marker, GenericGeometricMarker {

  private static let kDefaultBackgroundColor = UIColor.white
  private static let kDefaultInteractive = true

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

  public required override init() {
    backgroundColor = GeometricMarker.kDefaultBackgroundColor
    interactive = GeometricMarker.kDefaultInteractive
    super.init()
  }

  override init(tgMarker tgM: TGMarker) {
    backgroundColor = GeometricMarker.kDefaultBackgroundColor
    interactive = GeometricMarker.kDefaultInteractive
    super.init(tgMarker: tgM)
  }

  func updateStyleString() {
    // override in subclass
  }

}

/**
 Base class for point markers.
 */
@objc(MZPointMarker)
public class PointMarker : GeometricMarker, GenericPointMarker {

  private static let kPointStyle = "points"
  private static let kDefaultSize = CGSize.zero

  private var userUpdatedSize = false

  /// The coordinates that the marker should be placed at on the map.
  public var point: TGGeoPoint {
    set {
      tgMarker.point = newValue
    }
    get {
      return tgMarker.point
    }
  }

  /// The image that should be displayed on the marker. Updates the size of the marker to be the intrinsic size of the image.
  public var icon: UIImage? {
    set {
      guard let i = newValue else { return }
      tgMarker.icon = i
      size = i.size
      updateStyleString()
    }
    get {
      return tgMarker.icon
    }
  }

  /// Sets the size of a point marker. Does nothing when a polyline or polygon is set.
  public var size: CGSize {
    didSet {
      userUpdatedSize = true
      updateStyleString()
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

  /// Default initializer.
  public required init() {
    size = PointMarker.kDefaultSize
    super.init()
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
    size = s
    super.init()
    defer {
      size = s
    }
  }

  override init(tgMarker tgM: TGMarker) {
    size = PointMarker.kDefaultSize
    super.init(tgMarker: tgM)
  }

  // MARK : private
  override func updateStyleString() {
    tgMarker.stylingString = generateStyleStringWithSize()
  }

  private func generateBasicStyleString() -> String {
    return "{ style: '\(PointMarker.kPointStyle)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive) }"
  }

  private func generateStyleStringWithSize() -> String {
    if !userUpdatedSize { return generateBasicStyleString() }
    return "{ style: '\(PointMarker.kPointStyle)', color: '\(backgroundColor.hexValue())', size: [\(size.width)px, \(size.height)px], collide: false, interactive: \(interactive) }"
  }

}

/// Base class for polyline markers.
@objc(MZPolylineMarker)
public class PolylineMarker : GeometricMarker, GenericPolylineMarker {

  private static let kLineStyle = "lines"
  private static let kDefaultPolylineWidth = 10
  private static let kDefaultOrder = 1000

  /// The polyline that should be displayed on the map.
  public var polyline: TGGeoPolyline? {
    set {
      guard let l  = newValue else { return }
      tgMarker.polyline = l
    }
    get {
      return tgMarker.polyline
    }
  }

  /// The width of the stroke to draw the polyline.
  public var strokeWidth: Int {
    didSet {
      updateStyleString()
    }
  }

  /// The drawing order of the polyline. Higher values will be drawn above lower values. Default is 1000.
  public var order: Int {
    didSet {
      updateStyleString()
    }
  }

  // Default initializer.
  public required init() {
    strokeWidth = PolylineMarker.kDefaultPolylineWidth
    order = PolylineMarker.kDefaultOrder
    super.init()
    updateStyleString()
  }

  override func updateStyleString() {
    tgMarker.stylingString = "{ style: '\(PolylineMarker.kLineStyle)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive), width: \(strokeWidth)px, order: \(order) }"
  }
}

/// Base class for polygon markers.
@objc(MZPolygonMarker)
public class PolygonMarker : GeometricMarker, GenericPolygonMarker {

  private static let kPolygonStyle = "polygons"
  private static let kDefaultOrder = 1000

  /// The polygon that should be displayed on the map.
  public var polygon: TGGeoPolygon? {
    set {
      guard let p = newValue else { return }
      tgMarker.polygon = p
    }
    get {
      return tgMarker.polygon
    }
  }

  /// The drawing order of the polyline. Higher values will be drawn above lower values. Default is 1000.
  public var order: Int {
    didSet {
      updateStyleString()
    }
  }

  // Default initializer.
  public required init() {
    order = PolygonMarker.kDefaultOrder
    super.init()
    updateStyleString()
  }

  override func updateStyleString() {
    tgMarker.stylingString = "{ style: '\(PolygonMarker.kPolygonStyle)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive), order: \(order) }"
  }
}

/// Enum for common point marker types supported by all the house styles.
@objc public enum PointMarkerType : Int {
  case currentLocation, searchPin
}

/// Base class for system point markers.
@objc(MZSystemPointMarker)
public class SystemPointMarker : Marker, GenericSystemPointMarker {

  var markerType: PointMarkerType?

  // all marker types have an associated styling path
  private let typeToStylingPath = [PointMarkerType.currentLocation : "layers.mz_current_location_gem.draw.ux-location-gem-overlay",
                                   PointMarkerType.searchPin : "layers.mz_search_result.draw.ux-icons-overlay"]
  //currently only search results have an inactive state
  private let typeToInactiveStylingPath = [PointMarkerType.searchPin : "layers.mz_search_result.inactive.draw.ux-icons-overlay"]

  private static let kDefaultActive = true

  /// Updates the visual properties to indicate active status (ie. updates search pin to be gray when inactive).
  public var active: Bool {
    didSet {
      updateStylePath()
    }
  }

  /// The coordinates that the marker should be placed at on the map.
  public var point: TGGeoPoint {
    set {
      tgMarker.point = newValue
    }
    get {
      return tgMarker.point
    }
  }

  /// Returns a marker whose visual properties have been defined by a house style.
  public static func initWithMarkerType(_ markerType: PointMarkerType) -> GenericSystemPointMarker {
    return SystemPointMarker(markerType: markerType)
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

  init(markerType mt: PointMarkerType) {
    active = SystemPointMarker.kDefaultActive
    super.init()
    markerType = mt
    tgMarker.stylingPath = typeToStylingPath[mt]! //there is always a styling string for a given MarkerType so force unwrap
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

/// Base class for system polyline markers.
@objc(MZSystemPolylineMarker)
public class SystemPolylineMarker : Marker, GenericSystemPolylineMarker {

  private static let kSystemPolylineStylingPath = "layers.mz_route_line.draw.ux-route-line-overlay"

  /// The polyline that should be displayed on the map.
  public var polyline: TGGeoPolyline? {
    set {
      guard let l  = newValue else { return }
      tgMarker.polyline = l
    }
    get {
      return tgMarker.polyline
    }
  }

  public override init() {
    super.init()
    tgMarker.stylingPath = SystemPolylineMarker.kSystemPolylineStylingPath
  }
}

