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

  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
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

    // Configure the cell...

    guard let result = routingResult else {
      return cell
    }

    let resultLeg = result.legs[0]
    let manuever = resultLeg.maneuvers[indexPath.row]
    let instruction = manuever.instruction

    //      cell.textLabel?.text = instruction
    cell.titleLabel.text = instruction
    let length = String(format: "%.2f", manuever.length)
    //      cell.detailTextLabel?.text = String("\(length) mi")
    cell.detailLabel.text = String("\(length) mi")
    return cell
  }


  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */

  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */

  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

   }
   */

  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}
