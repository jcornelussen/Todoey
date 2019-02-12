//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Cornelussen on 27/01/2019.
//  Copyright © 2019 John Cornelussen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

  let realm = try! Realm()
  var categories: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()

      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
      // Default parameter = fetch ALL in database
      loadCategories()
      
      tableView.separatorStyle = .none
    }


  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    // Set category name.
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."

    
//    if let color = categories?[indexPath.row].displayColor {
//      cell.backgroundColor = UIColor(hexString: color)
//    } else {
//      cell.backgroundColor = UIColor.clear
//    }
    
    cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].displayColor ?? UIColor.clear.hexValue())
    
    return cell
  }
  
  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
    
  }
  
  
  
  //MARK: - Data Manipulation Methods
  func save(category: Category) {
    
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving category \(error)")
    }
    
    // reload the table to display the new item in the tableview.
    tableView.reloadData()
  }
  
  // internal & external parameter + default value for FetchRequest (fetch everything)
  
  func loadCategories() {
    categories = realm.objects(Category.self)
    
    tableView.reloadData()
  }
  
  //MARK: Delete Data From Swipe.
  override func updateModel(at indexPath: IndexPath) {
    if let selectedCategory = categories?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(selectedCategory)
        }
      } catch {
        print("Error deleting Category, \(error)")
      }
    }
  }
  
  
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category()
      
      newCategory.name = textField.text!
      
      self.save(category: newCategory)
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


