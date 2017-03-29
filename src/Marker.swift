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

  public var tgMarker: TGMarker {
    get {
      return internalTgMarker
    }
  }

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
      updateStylePath()
    }
  }

  public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    return tgMarker.setPointEased(coordinates, seconds: seconds, easeType: ease)
  }


  public static func initWithMarkerType(_ markerType: MarkerType) -> GenericMarker {
    let marker = Marker(markerType: markerType)
    return marker
  }

  public convenience required override init() {
    self.init(size: Marker.kDefaultSize)
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
    backgroundColor = Marker.kDefaultBackgroundColor
    interactive = Marker.kDefaultInteractive
    active = Marker.kDefaultActive
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
      str = "{ style: '\(styleType)', color: '\(backgroundColor.hexValue())', size: [\(size.width)px, \(size.height)px], collide: false, interactive: \(interactive) }"
      break;
    case Marker.kLineStyle,
         Marker.kPolygonStyle:
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
