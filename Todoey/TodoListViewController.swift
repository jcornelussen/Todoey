//
//  TodoListViewController.swift
//  Todoey
//
//  Created by John Cornelussen on 29/11/2018.
//  Copyright © 2018 John Cornelussen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  
  var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Conditional / if let construction in case .plist does not yet exist.
    if let items = defaults.array(forKey: "TodoListArray") as? [String] {
      itemArray = items
    }
  }
  
  //MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    cell.textLabel?.text = itemArray[indexPath.row]
    
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    
    // print(itemArray[indexPath.row])
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = . none
    }
    else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once the user clicks the Add Item button on our UIAlert
      
      self.itemArray.append(textField.text!)
      
      self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      // reload the table to display the new item in the tableview.
      self.tableView.reloadData()
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
  
}

