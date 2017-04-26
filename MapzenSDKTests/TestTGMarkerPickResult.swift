//
//  TGMarkerPickResultExtensions.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/14/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import TangramMap

class TestTGMarkerPickResult : TGMarkerPickResult {

  private let internalMarker: TGMarker

  override public var marker : TGMarker {
    get {
      return internalMarker
    }
  }

  init(marker: TGMarker) {
    internalMarker = marker
  }

}
