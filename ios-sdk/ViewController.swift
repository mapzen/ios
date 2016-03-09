//
//  ViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 3/8/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import Pelias

class ViewController: UIViewController, APIConfigData {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    PeliasSearchManager.sharedInstance.apiKey = "search-tZu4e8k"
    
    let searchText = "Testing 1 2 3 4"
    let searchConfig = PeliasSearchConfig(searchText: searchText, completionHandler: { (searchResponse) -> Void in
      print(searchResponse)
    })
    PeliasSearchManager.sharedInstance.performSearch(searchConfig)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

