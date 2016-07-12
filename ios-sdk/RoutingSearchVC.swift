//
//  RoutingSearchVC.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 10/4/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//

import UIKit

class RoutingSearchVC: AutocompleteTableVC {

  var delegate : RoutingSearchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    if let delegate = delegate {
      delegate.selected((self.results?[indexPath.row])!)
      self.navigationController?.popViewControllerAnimated(true)
    }
  }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
