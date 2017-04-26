//
//  TestAnnotationTarget.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/9/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap
@testable import MapzenSDK

class AnnotationTestTarget : UIResponder, MapMarkerSelectDelegate {

  var annotationClicked = false
  var annotationClickedNoParam = false
  var markerSelected = false

  func annotationClicked(annotation : PeliasMapkitAnnotation) {
    annotationClicked = true
  }

  func annotationClickedNoParams() {
    annotationClickedNoParam = true
  }

  func mapController(_ controller: MZMapViewController, didSelectMarker marker: GenericMarker, atScreenPosition position: CGPoint) {
    markerSelected = true
  }
}
