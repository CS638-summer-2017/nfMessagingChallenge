//
//  MessagesTableViewController.swift
//  MessagingChallenge
//
//  Created by Katie Hollman on 8/17/17.
//  Copyright © 2017 Nik Flahavan. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    var fireUser: FireUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        fireUser = FireUser()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //lets make sure we're actually supposed to be here...
        if isLoggedIn() {
            //Ok we are.  Now lets do what we need to do...
            print("logged in, now lets do some other stuff.")
            hasBeenLoggedIn(fireUser: fireUser) {
                print("lets Load the view")
                self.loadView()
            }
            
        } else {
            print("Not logged in, better go to login screen.")
            //not supposed to be here, perform segue programatically
            performSegue(withIdentifier: "showCreateAccount", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("in overriden table view function, telling table view how many rows in each section to draw.  messages.count: \(fireUser?.messages.count ?? 0)")
        return fireUser?.messages.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = fireUser?.messagesAt(indexPath: indexPath).messageBody

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateAccount" {
            let controller = segue.destination as! LoginTableViewController
            
            controller.fireUser = fireUser
            
        }
    }
    

}
