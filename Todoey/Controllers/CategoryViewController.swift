//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Cornelussen on 27/01/2019.
//  Copyright © 2019 John Cornelussen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

  var categories = [Category]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
      // Default parameter = fetch ALL in database
      loadCategories()
    }


  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    // Set category name.
    cell.textLabel?.text = categories[indexPath.row].name
    
    return cell
  }
  
  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories[indexPath.row]
    }
    
  }
  
  
  
  //MARK: - Data Manipulation Methods
  func saveCategories() {
    
    do {
      try context.save()
    } catch {
      print("Error saving category \(error)")
    }
    
    // reload the table to display the new item in the tableview.
    tableView.reloadData()
  }
  
  // internal & external parameter + default value for FetchRequest (fetch everything)
  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categories = try context.fetch(request)
//      let count = try context.count(for: request)
//      print("Number of Categories fetched: \(count)")
    } catch {
      print("Error fetching data from category \(error)")
    }
    
    tableView.reloadData()
  }
  
  
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category(context: self.context)
      
      newCategory.name = textField.text!
      self.categories.append(newCategory)
      
      self.saveCategories()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    
    // Add above action to the UI Alert Controller
    alert.addAction(action)
    
    // Show the UI Alert Controller on screen.
    present(alert, animated: true, completion: nil)
  }

  
  

  
}
