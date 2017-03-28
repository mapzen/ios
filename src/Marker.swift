//
//  Marker.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap

public enum MarkerType : Int {
  case currentLocation, searchPin, routeLine
}

@objc(MZMarker)
public class Marker: NSObject {

  private static let kPointStyle = "points"
  private static let kLineStyle = "lines"
  private static let kPolygonStyle = "polygons"
  private static let kDefaultBackgroundColor = UIColor.white
  private static let kDefaultInteractive = true
  private static let kDefaultSize = CGSize.zero

  public let tgMarker: TGMarker
  private var styleType = kPointStyle
  private var markerType: MarkerType?
  // all marker types have an associated styling path
  private static let typeToStylingPath = [MarkerType.currentLocation : "layers.mz_current_location_gem.draw.ux-location-gem-overlay",
                                   MarkerType.searchPin : "layers.mz_search_result.draw.ux-icons-overlay",
                                   MarkerType.routeLine : "layers.mz_route_line.draw.ux-route-line-overlay"]
  //currently only search results have an inactive state
  private static let typeToInactiveStylingPath = [MarkerType.searchPin : "layers.mz_search_result.inactive.draw.ux-icons-overlay"]

  open var point: TGGeoPoint? {
    set {
      guard let p = newValue else { return }
      tgMarker.point = p
      styleType = Marker.kPointStyle
      updateStyleString()
    }
    get {
      return tgMarker.point
    }
  }

  open var polyline: TGGeoPolyline? {
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

  open var polygon: TGGeoPolygon? {
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
  open var icon: UIImage? {
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

  open var visible: Bool {
    set {
      tgMarker.visible = newValue
    }
    get {
      return tgMarker.visible
    }
  }

  open var drawOrder: Int {
    set {
      tgMarker.drawOrder = newValue
    }
    get {
      return tgMarker.drawOrder
    }
  }

  open var size: CGSize {
    didSet {
      updateStyleString()
    }
  }

  open var backgroundColor: UIColor {
    didSet {
      updateStyleString()
    }
  }

  open var interactive: Bool {
    didSet {
      updateStyleString()
    }
  }

  open var active: Bool? {
    didSet {
      updateStylePath()
    }
  }

  public static func initWithMarkerType(_ markerType: MarkerType) -> Marker {
    let marker = Marker(markerType: markerType)
    return marker
  }

  public override convenience init() {
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

  public init(size s: CGSize) {
    tgMarker = TGMarker.init()
    size = s
    backgroundColor = Marker.kDefaultBackgroundColor
    interactive = Marker.kDefaultInteractive
  }

  init(tgMarker tgM: TGMarker) {
    tgMarker = tgM
    size = Marker.kDefaultSize
    backgroundColor = Marker.kDefaultBackgroundColor
    interactive = Marker.kDefaultInteractive
  }

  convenience init(markerType mt: MarkerType) {
    self.init(size: Marker.kDefaultSize)
    markerType = mt
    tgMarker.stylingPath = Marker.typeToStylingPath[mt]! //there is always a styling string for a given MarkerType so force unwrap
  }

  open func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
    return tgMarker.setPointEased(coordinates, seconds: seconds, easeType: ease)
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
    guard let a = active else { return }

    var path: String?
    if a {
      path = Marker.typeToStylingPath[type]
    } else {
      path = Marker.typeToInactiveStylingPath[type]
    }

    if let currPath = path {
      tgMarker.stylingPath = currPath
    }
  }
}
