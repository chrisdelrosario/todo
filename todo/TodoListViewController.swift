//
//  TodoListViewController.swift
//  todo
//
//  Created by Chris Del Rosario on 6/21/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    @IBOutlet var todoTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "toDoItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
 
    //MARK: TableView DidSelectRowAt Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: Adding new items to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let addItemAlert = UIAlertController(title: "Add New Item", message: "" , preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let alertTextField = addItemAlert.textFields?[0].text {
                self.itemArray.append(alertTextField)
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

