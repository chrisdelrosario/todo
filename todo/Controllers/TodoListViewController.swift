//
//  TodoListViewController.swift
//  todo
//
//  Created by Chris Del Rosario on 6/21/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // instance variables
    let defaults = UserDefaults.standard
    var itemArray = [ToDoItemData]()
    
    @IBOutlet var todoTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let loadedArray = defaults.array(forKey: "TodoListArray") as? [ToDoItemData] {
           itemArray = loadedArray
        }
        
    }

    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "toDoItem", for: indexPath)
        
            let currentItem = itemArray[indexPath.row]
            cell.textLabel?.text = currentItem.description
            cell.accessoryType = currentItem.isCompleted ? .checkmark : .none

        return cell
    }
 
    //MARK: TableView DidSelectRowAt Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].isCompleted = !itemArray[indexPath.row].isCompleted
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: Adding new items to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let addItemAlert = UIAlertController(title: "Add New Item", message: "" , preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let alertTextField = addItemAlert.textFields?[0].text {
                let toDoItemEntry = ToDoItemData()
                toDoItemEntry.description = alertTextField
                self.itemArray.append(toDoItemEntry)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.todoTableView.reloadData()
            }
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }
        
        addItemAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
        }
        
        addItemAlert.addAction(confirmAction)
        addItemAlert.addAction(cancelAction)
        
        self.present(addItemAlert,animated: true, completion: nil)
    }
}

