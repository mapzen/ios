//
//  setup_version.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 9/27/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation

let arguments = CommandLine.arguments
//Position 0 is file name in Swift 3.1 - so we need position 1 of the array
if arguments.count != 2 {
  exit(1)
}
let versionNumber = arguments[1]
let currentDirectory = FileManager.default.currentDirectoryPath
print(currentDirectory)
let pathToWrite = "\(currentDirectory)/version.plist"

let data = NSMutableDictionary()
data["sdk_version"] = versionNumber //Aligns with MapzenManager.SDK_VERSION_KEY
data.write(to: URL.init(fileURLWithPath: pathToWrite), atomically: true)
