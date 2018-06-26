//
//  CategoryViewController.swift
//  todo
//
//  Created by Chris Del Rosario on 6/23/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    // MARK: - Instance Variables
    let realm = try! Realm()
    var categoryResults: Results<Category>?
    
    // MARK: - IBOutlet
    
    @IBOutlet var categoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        // nil coalescing if categoryResults = nil, return 1 instead
        return categoryResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemID", for: indexPath)
        
        if let currentCategory = categoryResults?[indexPath.row] {
            cell.textLabel?.text = currentCategory.descriptionText
        } else {
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.text = "No categories added"
        }
        
        return cell
    }

    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.categorySelected = categoryResults?[indexPath.row]
        }
    }
   
    //MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var entryTextField = UITextField()
         let addCategoryAlert = UIAlertController(title: "Add New Category", message: "" , preferredStyle: .alert)
         let confirmAction = UIAlertAction(title: "Add", style: .default) { (action) in
             let categoryItemEntry = Category()
             categoryItemEntry.descriptionText = entryTextField.text!
             self.saveData(category: categoryItemEntry)
         }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }
             addCategoryAlert.addTextField { (textField) in
             entryTextField.placeholder = "Enter new category name here"
             entryTextField = textField
         }
         
         addCategoryAlert.addAction(confirmAction)
         addCategoryAlert.addAction(cancelAction)
         self.present(addCategoryAlert,animated: true, completion: nil)
    
    }
    
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving to realm: \(error)")
        }
        categoryTableView.reloadData()
    }
    
    func loadData() {
        categoryResults = realm.objects(Category.self)
        categoryTableView.reloadData()
    }
}
