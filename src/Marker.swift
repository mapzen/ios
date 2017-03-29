//
//  Marker.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

@objc public enum MarkerType : Int {
  case currentLocation, searchPin, routeLine
}

@objc(MZGenericMarker)
public protocol GenericMarker {
  var tgMarker: TGMarker { get }
  var point: TGGeoPoint { get set }
  var polyline: TGGeoPolyline? { get set }
  var polygon: TGGeoPolygon? { get set }
  var icon: UIImage? { get set }
  var visible: Bool { get set }
  var drawOrder: Int { get set }
  var size: CGSize { get set }
  var backgroundColor: UIColor { get set }
  var interactive: Bool { get set }
  var active: Bool { get set }

  func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool

  static func initWithMarkerType(_ markerType: MarkerType) -> GenericMarker
  init()
  init(size s: CGSize)
}

private let kPointStyle = "points"
private let kLineStyle = "lines"
private let kPolygonStyle = "polygons"
private let kDefaultBackgroundColor = UIColor.white
private let kDefaultInteractive = true
private let kDefaultSize = CGSize.zero
private let kDefaultActive = true

var styleType = kPointStyle
var markerType: MarkerType?

// all marker types have an associated styling path
private let typeToStylingPath = [MarkerType.currentLocation : "layers.mz_current_location_gem.draw.ux-location-gem-overlay",
                                MarkerType.searchPin : "layers.mz_search_result.draw.ux-icons-overlay",
                                MarkerType.routeLine : "layers.mz_route_line.draw.ux-route-line-overlay"]
//currently only search results have an inactive state
private let typeToInactiveStylingPath = [MarkerType.searchPin : "layers.mz_search_result.inactive.draw.ux-icons-overlay"]

public class Marker : GenericMarker {

  private let internalTgMarker: TGMarker

  public var tgMarker: TGMarker {
    get {
      return internalTgMarker
    }
  }

  public var point: TGGeoPoint {
    set {
      tgMarker.point = newValue
      styleType = kPointStyle
      updateStyleString()
    }
    get {
      return tgMarker.point
    }
  }

  public var polyline: TGGeoPolyline? {
    set {
      guard let l  = newValue else { return }
      tgMarker.polyline = l
      styleType = kLineStyle
      updateStyleString()
    }
    get {
      return tgMarker.polyline
    }
  }

  public var polygon: TGGeoPolygon? {
    set {
      guard let p = newValue else { return }
      tgMarker.polygon = p
      styleType = kPolygonStyle
      updateStyleString()
    }
    get {
      return tgMarker.polygon
    }
  }
  public var icon: UIImage? {
    set {
      guard let i = newValue else { return }
      tgMarker.icon = i
      size = i.size
      styleType = kPointStyle
      updateStyleString()
    }
    get {
      return tgMarker.icon
    }
  }

  public var visible: Bool {
    set {
      tgMarker.visible = newValue
    }
    get {
      return tgMarker.visible
    }
  }

  public var drawOrder: Int {
    set {
      tgMarker.drawOrder = newValue
    }
    get {
      return tgMarker.drawOrder
    }
  }

  public var size: CGSize {
    didSet {
      updateStyleString()
    }
  }

  public var backgroundColor: UIColor {
    didSet {
      updateStyleString()
    }
  }

  public var interactive: Bool {
    didSet {
      updateStyleString()
    }
  }

  public var active: Bool {
    didSet {
      updateStyleString()
    }
  }

  public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    return tgMarker.setPointEased(coordinates, seconds: seconds, easeType: ease)
  }


  public static func initWithMarkerType(_ markerType: MarkerType) -> GenericMarker {
    let marker = Marker(markerType: markerType)
    return marker
  }

  public convenience required init() {
    self.init(size: kDefaultSize)
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

  public required init(size s: CGSize) {
    internalTgMarker = TGMarker.init()
    size = s
    backgroundColor = kDefaultBackgroundColor
    interactive = kDefaultInteractive
    active = kDefaultActive
  }

  init(tgMarker tgM: TGMarker) {
    internalTgMarker = tgM
    size = kDefaultSize
    backgroundColor = kDefaultBackgroundColor
    interactive = kDefaultInteractive
    active = kDefaultActive
  }

  convenience init(markerType mt: MarkerType) {
    self.init(size: kDefaultSize)
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
    case kPointStyle:
      str = "{ style: '\(styleType)', color: '\(backgroundColor.hexValue())', size: [\(size.width)px, \(size.height)px], collide: false, interactive: \(interactive) }"
      break;
    case kLineStyle,
         kPolygonStyle:
      str = "{ style: '\(styleType)', color: '\(backgroundColor.hexValue())', collide: false, interactive: \(interactive) }"
      break;
    default:
      str = "{ style: '\(styleType)', color: '\(backgroundColor.hexValue())', size: [\(size.width)px, \(size.height)px], collide: false, interactive: \(interactive) }"
    }
    tgMarker.stylingString = str
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

//func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
//  if let associated = objc_getAssociatedObject(base, key) as? ValueType {
//    return associated
//  }
//  let associated = initialiser()
//  objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
//  return associated
//}
//
//func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
//  objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
//}
//
//class SizeObj {
//
//  let size: CGSize
//
//  init(_ s: CGSize) {
//    size = s
//  }
//}
//
//class BoolObj {
//
//  let bool: Bool
//
//  init(_ b: Bool) {
//    bool = b
//  }
//}
