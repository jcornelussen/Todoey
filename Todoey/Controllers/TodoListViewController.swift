//
//  TodoListViewController.swift
//  Todoey
//
//  Created by John Cornelussen on 29/11/2018.
//  Copyright © 2018 John Cornelussen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  
  //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  var itemArray = [Item]()
  
  // Below is needed when using User Defaults.
  //let defaults = UserDefaults.standard
 
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    loadItems()
    
    // Conditional / if let construction in case .plist does not yet exist.
    // Lines below are when using the Default .plist.
//    if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//      itemArray = items
//    }
    
  }
  
  //MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    // Set or reset the cell checkmark
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    
    // print(itemArray[indexPath.row])
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once the user clicks the Add Item button on our UIAlert
      
      let newItem = Item()
      newItem.title = textField.text!
      self.itemArray.append(newItem)
   
      // Use below line when using User Defaults instead of Core Data.
      // self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      self.saveItems()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    // Add above action to the UI Alert Controller.
    alert.addAction(action)
    
    // Show the UI Alert Controller on screen.
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK - Model Manupulation Methods
  
  func saveItems() {
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Error encoding item array, \(error)")
    }
    
    // reload the table to display the new item in the tableview.
    tableView.reloadData()
  }
  
  
  func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      
      do {
        itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("Error decoding item array, \(error)")
      }
    }

  }
  
}

