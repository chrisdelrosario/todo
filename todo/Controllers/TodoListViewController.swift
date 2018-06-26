//
//  TodoListViewController.swift
//  todo
//
//  Created by Chris Del Rosario on 6/21/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
  
    //IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    
    // instance variables
    let realm = try! Realm()
    var itemResults: Results<Item>?
    var categorySelected : Category?{
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemID", for: indexPath)
        
        if let currentItem = itemResults?[indexPath.row] {
            cell.textLabel?.text = currentItem.descriptionText
            cell.accessoryType = currentItem.isCompleted ? .checkmark : .none

        } else {
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.text = "Tap + to add an item"
        }
        
        return cell
    }
 
    //MARK: TableView DidSelectRowAt Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedItem = itemResults?[indexPath.row] {
            do {
                try realm.write {
                    selectedItem.isCompleted = !selectedItem.isCompleted
                }
            } catch {
                print ("Error writing done status \(error)")
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    //MARK: Adding new items to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var entryTextField = UITextField()

        let addItemAlert = UIAlertController(title: "Add New Item", message: "" , preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.categorySelected {
                do {
                    try self.realm.write {
                        let toDoItemEntry = Item()
                        toDoItemEntry.descriptionText = entryTextField.text!
                        toDoItemEntry.createdDate = Date()
                     //   print(toDoItemEntry.createdDate)
                        currentCategory.items.append(toDoItemEntry)
                    }
                } catch {
                    print("Error saving to realm: \(error)")
                }
            }
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }

        addItemAlert.addTextField { (textField) in
            entryTextField.placeholder = "Enter here"
            entryTextField = textField
        }

        addItemAlert.addAction(confirmAction)
        addItemAlert.addAction(cancelAction)

        self.present(addItemAlert,animated: true, completion: nil)
    }

    //Mark: Save the table to data file
    
    func loadData() {
        itemResults = categorySelected?.items.sorted(byKeyPath: "createdDate", ascending: false)
        tableView.reloadData()
    }
}

//MARK: - Extension for Search bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            itemResults = itemResults?.filter("descriptionText CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: false)
            tableView.reloadData()
        }
    }
}

