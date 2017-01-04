//
//  RoutingResultTableVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 10/4/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit
import OnTheRoad

class RoutingResultTableVC: UITableViewController {

  var routingResult: OTRRoutingResult?

  let cellIdent = "basicCellIdent"

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let result = routingResult else {
      return 0
    }

    return result.legs[0].maneuvers.count
  }

  func display(route : OTRRoutingResult){
    routingResult = route
    tableView.reloadData()
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdent, forIndexPath: indexPath) as! RouteDirectionCell

    guard let result = routingResult else {
      return cell
    }

    let resultLeg = result.legs[0]
    let manuever = resultLeg.maneuvers[indexPath.row]
    let instruction = manuever.instruction

    cell.titleLabel.text = instruction
    let length = String(format: "%.2f", manuever.length)
    cell.detailLabel.text = String("\(length) mi")
    return cell
  }
}
