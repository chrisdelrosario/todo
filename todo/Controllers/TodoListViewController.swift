//
//  TodoListViewController.swift
//  todo
//
//  Created by Chris Del Rosario on 6/21/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

 
    
    //IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    
    // instance variables
    var itemArray = [ToDoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    var categoryClicked : CategoryItem? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemID", for: indexPath)
        let currentItem = itemArray[indexPath.row]
        cell.textLabel?.text = currentItem.descriptionText
        cell.accessoryType = currentItem.completedFlag ? .checkmark : .none
        return cell
    }
 
    //MARK: TableView DidSelectRowAt Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].completedFlag = !itemArray[indexPath.row].completedFlag
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
    //MARK: Adding new items to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var entryTextField = UITextField()
        
        let addItemAlert = UIAlertController(title: "Add New Item", message: "" , preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (action) in

                let toDoItemEntry = ToDoItem(context: self.context)
                toDoItemEntry.descriptionText = entryTextField.text
                toDoItemEntry.completedFlag = false
                toDoItemEntry.parentCategory = self.categoryClicked
                self.itemArray.append(toDoItemEntry)
                self.saveData()
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
    
    func saveData() {
        
        
        do {
           try context.save()
        } catch {
            print ("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.descriptionText MATCHES %@", categoryClicked!.descriptionText!)
        
        if let searchPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print ("Error Fetching Data: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Extension for Search bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let searchPredicate  = NSPredicate(format: "descriptionText CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "descriptionText", ascending: true)]
        loadData(with: request, predicate: searchPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            let searchPredicate  = NSPredicate(format: "descriptionText CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "descriptionText", ascending: true)]
            loadData(with: request, predicate: searchPredicate)
        }
    }
    
}
