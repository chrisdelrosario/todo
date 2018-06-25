//
//  CategoryViewController.swift
//  todo
//
//  Created by Chris Del Rosario on 6/23/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // MARK: - Instance Variables
    var categoryArray = [CategoryItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    // MARK: - IBOutlet
    
    @IBOutlet var categoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemID", for: indexPath)
        let currentCategory = categoryArray[indexPath.row]
        cell.textLabel?.text = currentCategory.descriptionText
        return cell
    }

    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.categoryClicked = categoryArray[indexPath.row]
        } else {
            
        }
    }
   
    //MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
  
         var entryTextField = UITextField()
         let addCategoryAlert = UIAlertController(title: "Add New Category", message: "" , preferredStyle: .alert)
         let confirmAction = UIAlertAction(title: "Add", style: .default) { (action) in
         
             let categoryItemEntry = CategoryItem(context: self.context)
             categoryItemEntry.descriptionText = entryTextField.text
             self.categoryArray.append(categoryItemEntry)
             self.saveData()
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
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print ("Error saving context: \(error)")
        }
        categoryTableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print ("Error Fetching Data: \(error)")
        }
        categoryTableView.reloadData()
        
    }
    
    

}
