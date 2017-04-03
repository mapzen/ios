//
//  UIColorExtensions.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//
import UIKit
import CoreGraphics

extension UIColor {
  func hexValue() -> String {
    var r: CGFloat = 1
    var g: CGFloat = 1
    var b: CGFloat = 1
    var a: CGFloat = 1
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let red = Float(r * 255)
    let green = Float(g * 255)
    let blue = Float(b * 255)
    let alpha = Float(a * 255)
    return String.init(format: "#%02lX%02lX%02lX%02lX", lroundf(alpha), lroundf(red), lroundf(green), lroundf(blue))
  }
}
