//
//  GenreTableViewController.swift
//  Movie Night
//
//  Created by Kate Duncan-Welke on 1/4/19.
//  Copyright © 2019 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class GenreTableViewController: UITableViewController {
    
    // MARK: Variables
    
    var genreList = [Genre]()
    var selectedCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Viewer.viewer1)
        
        print(Viewer.viewer2)
        
        DataManager<Genre>.fetch() { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.genreList = response
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: "Networking failed", message: "Network error: \(error.localizedDescription)")
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = genreList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedCount < 5 {
            selectedCount += 1
            return indexPath
        } else {
            // prevent selection of more than five items
            print("list maxed out at 5")
            tableView.cellForRow(at: indexPath)?.isSelected = false
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedCount > 0 {
            selectedCount -= 1
        }
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
        if segue.identifier == "selectActors" {
            let selectedItems = tableView.indexPathsForSelectedRows
            guard let selections = selectedItems else { return }
            
            switch Viewer.currentlySelected {
                case .viewer1:
                    for item in selections {
                        Viewer.viewer1.preferredGenres.append(genreList[item.row])
                    }
                case .viewer2:
                    for item in selections {
                        Viewer.viewer2.preferredGenres.append(genreList[item.row])
                    }
                default:
                    break // should not be able to be none, add error handling if is
                }
        }
        
        if segue.identifier == "returnToBeginning" {
            switch Viewer.currentlySelected {
                case .viewer1:
                    Viewer.viewer1.preferredGenres.removeAll()
                case .viewer2:
                    Viewer.viewer2.preferredGenres.removeAll()
                default:
                    break // should not be able to be none, add error handling if is
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "returnToBeginning", sender: Any?.self)
    }
    
    
    @IBAction func goToActorSelection(_ sender: Any) {
        if selectedCount > 0 {
            performSegue(withIdentifier: "selectActors", sender: Any?.self)
        } else {
            showAlert(title: "Missing information", message: "Please select at least one item")
        }
    }
    
}
