//
//  RoutingResultTableVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 10/4/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import OnTheRoad

class RoutingResultTableVC: SampleTableViewController {

  var routingResult: OTRRoutingResult?

  let cellIdent = "basicCellIdent"

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let result = routingResult else {
      return 0
    }

    return result.legs[0].maneuvers.count
  }

  func display(_ route : OTRRoutingResult){
    routingResult = route
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdent, for: indexPath) as! RouteDirectionCell

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
