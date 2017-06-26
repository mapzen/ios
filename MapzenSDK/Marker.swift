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
  var tgMarker: TGMarker? { get set }
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
   - parameter ease: Easing to use for animation.
   */
  func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool

}

@objc(MZGenericPointIconMarker)
public protocol GenericPointIconMarker: GenericGeometricMarker, GenericPointMarker {
  /// The image that should be displayed on the marker.
  var icon: UIImage? { get set }
  /// Sets the size of the marker.
  var size: CGSize { get set }
  /**
   Initializes a marker with a given size.

   - parameter s: The size the marker should be.
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
/// The drawing order of the polyline relative to other polylines and polygons. Higher values will be drawn above lower values. Default is 1000.
  var order: Int { get set }
}

/// Generic polygon marker protocol definition.
@objc(MZGenericPolygonMarker)
public protocol GenericPolygonMarker: GenericGeometricMarker {
  /// The polygon that should be displayed on the map.
  var polygon: TGGeoPolygon? { get set }
/// The drawing order of the polygon relative to other polylines and polygons. Higher values will be drawn above lower values. Default is 1000.
  var order: Int { get set }
}

/// Generic system point marker protocol definition.
@objc(MZGenericSystemPointMarker)
public protocol GenericSystemPointMarker: GenericPointMarker {
  /// Returns a marker whose visual properties have been defined by a house style.
  static func initWithMarkerType(_ markerType: PointMarkerType) -> GenericSystemPointMarker
}

/// Generic selectable system point marker protocol definition.
@objc(MZGenericSelectableSystemPointMarker)
public protocol GenericSelectableSystemPointMarker: GenericPointMarker {
  /// Updates the visual properties to indicate active status (ie. updates search pin to be gray when inactive).
  var active: Bool { get set }
  /// Returns a marker whose visual properties have been defined by a house style.
  static func initWithMarkerType(_ markerType: SelectablePointMarkerType) -> GenericSelectableSystemPointMarker
}

/// Generic system geometric marker protocol definition.
@objc(MZGenericSystemPolylineMarker)
public protocol GenericSystemPolylineMarker: GenericMarker {
  /// The polyline that should be displayed on the map.
  var polyline: TGGeoPolyline? { get set }
}

/// Base class for generic markers. Do not instantiate this class directly, use one of the more meaningful subclasses.
public class Marker : NSObject, GenericMarker {

  public var tgMarker: TGMarker? {
    didSet {
      tgMarker?.visible = visible
      tgMarker?.drawOrder = drawOrder
    }
  }

  /// Toggles the marker visibility.
  public var visible: Bool {
    didSet {
      tgMarker?.visible = visible
    }
  }

  /// The marker draw order relative to other markers. Note that higher values are drawn above lower ones.
  public var drawOrder: Int {
    didSet {
      tgMarker?.drawOrder = drawOrder
    }
  }

  override init () {
    visible = true
    drawOrder = 0
    super.init()
  }

  init(tgMarker tgM: TGMarker?) {
    visible = true
    drawOrder = 0
    tgMarker = tgM
  }

}

/// Base class for geometric markers. Do not instantiate this class directly, use one of the more meaningful subclasses.
public class GeometricMarker : Marker, GenericGeometricMarker {

  private static let kDefaultBackgroundColor = UIColor.white
  private static let kDefaultInteractive = true

  override public var tgMarker: TGMarker? {
    set {
      super.tgMarker = newValue
      updateStyleString()
    }
    get {
      return super.tgMarker
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

  public required override init() {
    backgroundColor = GeometricMarker.kDefaultBackgroundColor
    interactive = GeometricMarker.kDefaultInteractive
    super.init()
  }

  override init(tgMarker tgM: TGMarker?) {
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
public class PointMarker : GeometricMarker, GenericPointIconMarker {

  private static let kPointStyle = "points"
  private static let kDefaultSize = CGSize.zero

  private var userUpdatedSize = false

  override public var tgMarker: TGMarker? {
    set {
      if let i = icon { newValue?.icon = i}
      newValue?.point = point
      super.tgMarker = newValue
    }
    get {
      return super.tgMarker
    }
  }

  /// The coordinates that the marker should be placed at on the map.
  public var point: TGGeoPoint {
    didSet {
      tgMarker?.point = point
    }
  }

  /// The image that should be displayed on the marker. Updates the size of the marker to be the intrinsic size of the image.
  public var icon: UIImage? {
    didSet {
      guard let i = icon else { return }
      tgMarker?.icon = i
      size = i.size
      updateStyleString()
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
   - parameter ease: Easing to use for animation.
   */
  public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    tgMarker?.pointEased(coordinates, seconds: seconds, easeType: ease)
    //TODO: Add error management back in here once we're doing it everywhere correctly.
    return true

  }

  /// Default initializer.
  public required init() {
    size = PointMarker.kDefaultSize
    point = TGGeoPointMake(0.0, 0.0) // Null Island!
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

   - parameter s: The size the marker should be.
   */
  public required init(size s: CGSize) {
    size = s
    point = TGGeoPointMake(0.0, 0.0) // Null Island!
    super.init()
    defer {
      size = s
    }
  }

  override init(tgMarker tgM: TGMarker?) {
    size = PointMarker.kDefaultSize
    point = TGGeoPointMake(0.0, 0.0) // Null Island!
    super.init(tgMarker: tgM)
  }

  // MARK : private
  override func updateStyleString() {
    guard let marker = tgMarker else { return }
    marker.stylingString = generateStyleStringWithSize()
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

  override public var tgMarker: TGMarker? {
    set {
      if let line = polyline { newValue?.polyline = line }
      super.tgMarker = newValue

    }
    get {
      return super.tgMarker
    }
  }

  /// The polyline that should be displayed on the map.
  public var polyline: TGGeoPolyline? {
    didSet {
      guard let l  = polyline else { return }
      tgMarker?.polyline = l
    }
  }

  /// The width of the stroke to draw the polyline.
  public var strokeWidth: Int {
    didSet {
      updateStyleString()
    }
  }

  /// The drawing order of the polyline relative to other polylines and polygons. Higher values will be drawn above lower values. Default is 1000.
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
    guard let marker = tgMarker else { return }
    marker.stylingString = "{ style: '\(PolylineMarker.kLineStyle)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive), width: \(strokeWidth)px, order: \(order) }"
  }
}

/// Base class for polygon markers.
@objc(MZPolygonMarker)
public class PolygonMarker : GeometricMarker, GenericPolygonMarker {

  private static let kPolygonStyle = "polygons"
  private static let kDefaultOrder = 1000

  override public var tgMarker: TGMarker? {
    set {
      if let p = polygon { newValue?.polygon = p }
      super.tgMarker = newValue
    }
    get {
      return super.tgMarker
    }
  }

  /// The polygon that should be displayed on the map.
  public var polygon: TGGeoPolygon? {
    didSet {
      guard let p = polygon else { return }
      tgMarker?.polygon = p
    }
  }

  /// The drawing order of the polygon relative to other polygons and polylines. Higher values will be drawn above lower values. Default is 1000.
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
    tgMarker?.stylingString = "{ style: '\(PolygonMarker.kPolygonStyle)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive), order: \(order) }"
  }
}

/// Enum for common point marker types supported by all the house styles.
@objc public enum PointMarkerType : Int {
  case currentLocation, routeLocation, droppedPin
}

/// Enum for common selectable point marker types supported by all the house styles.
@objc public enum SelectablePointMarkerType : Int {
  case searchPin, routeStart, routeDestination
}

/// Base class for system point markers.
@objc(MZSystemPointMarker)
public class SystemPointMarker : Marker, GenericSystemPointMarker {

  var markerType: PointMarkerType?

  // all marker types have an associated styling path
  private let typeToStylingPath = [PointMarkerType.currentLocation : "layers.mz_current_location_gem.draw.ux-location-gem-overlay",
                                   PointMarkerType.routeLocation : "layers.mz_route_location.draw.ux-location-gem-overlay",
                                   PointMarkerType.droppedPin : "layers.mz_dropped_pin.draw.ux-icons-overlay",]

  override public var tgMarker: TGMarker? {
    set {
      newValue?.point = point
      if let mt = markerType { newValue?.stylingPath = typeToStylingPath[mt]! } //there is always a styling string for a given MarkerType so force unwrap
      super.tgMarker = newValue
    }
    get {
      return super.tgMarker
    }
  }

  /// The coordinates that the marker should be placed at on the map.
  public var point: TGGeoPoint {
    didSet {
      tgMarker?.point = point
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
   - parameter ease: Easing to use for animation.
   - returns: True if successful, false if error or marker has not been added to the map
   */
  public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    guard let marker = tgMarker else { return false }
    marker.pointEased(coordinates, seconds: seconds, easeType: ease)
    //TODO: Add error management back in here once we're doing it everywhere correctly.
    return true
  }

  init(markerType mt: PointMarkerType) {
    markerType = mt
    point = TGGeoPointMake(0.0, 0.0) // Null Island!
    super.init(tgMarker: nil)
  }

}

/// Base class for system point markers.
@objc(MZSelectableSystemPointMarker)
public class SelectableSystemPointMarker : Marker, GenericSelectableSystemPointMarker {

  var markerType: SelectablePointMarkerType?

  private let typeToStylingPath = [SelectablePointMarkerType.searchPin : "layers.mz_search_result.draw.ux-icons-overlay",
                                   SelectablePointMarkerType.routeStart : "layers.mz_route_start.draw.ux-icons-overlay",
                                   SelectablePointMarkerType.routeDestination : "layers.mz_route_destination.draw.ux-icons-overlay"]

  //currently only search results have an inactive state
  private let typeToInactiveStylingPath = [SelectablePointMarkerType.searchPin : "layers.mz_search_result.inactive.draw.ux-icons-overlay"]

  private static let kDefaultActive = true

  /// Updates the visual properties to indicate active status (ie. updates search pin to be gray when inactive).
  public var active: Bool {
    didSet {
      updateStylePath()
    }
  }

  override public var tgMarker: TGMarker? {
    set {
      newValue?.point = point
      if let mt = markerType { newValue?.stylingPath = typeToStylingPath[mt]! } //there is always a styling string for a given MarkerType so force unwrap
      super.tgMarker = newValue
    }
    get {
      return super.tgMarker
    }
  }

  /// The coordinates that the marker should be placed at on the map.
  public var point: TGGeoPoint {
    didSet {
      tgMarker?.point = point
    }
  }

  /// Returns a marker whose visual properties have been defined by a house style.
  public static func initWithMarkerType(_ markerType: SelectablePointMarkerType) -> GenericSelectableSystemPointMarker {
    return SelectableSystemPointMarker(markerType: markerType)
  }

  /**
   Animates the marker from its current coordinates to the ones given.

   - parameter coordinates: Coordinates to animate the marker to
   - parameter seconds: Duration in seconds of the animation.
   - parameter ease: Easing to use for animation.
   - returns: True if successful or false if an error occured or the marker hasn't been added to a map
   */
  public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    guard let marker = tgMarker else { return false }
    marker.pointEased(coordinates, seconds: seconds, easeType: ease)
    //TODO: Add error management back in here once we're doing it everywhere correctly.
    return true
  }

  init(markerType mt: SelectablePointMarkerType) {
    active = SelectableSystemPointMarker.kDefaultActive
    markerType = mt
    point = TGGeoPointMake(0.0, 0.0) // Null Island!
    super.init(tgMarker: nil)
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
      tgMarker?.stylingPath = currPath
    }
  }

}

/// Base class for system polyline markers.
@objc(MZSystemPolylineMarker)
public class SystemPolylineMarker : Marker, GenericSystemPolylineMarker {

  private static let kSystemPolylineStylingPath = "layers.mz_route_line.draw.ux-route-line-overlay"

  override public var tgMarker: TGMarker? {
    set {
      if let l = polyline { newValue?.polyline = l }
      newValue?.stylingPath = SystemPolylineMarker.kSystemPolylineStylingPath
      super.tgMarker = newValue
    }
    get {
      return super.tgMarker
    }
  }

  /// The polyline that should be displayed on the map.
  public var polyline: TGGeoPolyline? {
    didSet {
      guard let l  = polyline else { return }
      tgMarker?.polyline = l
    }
  }
}

