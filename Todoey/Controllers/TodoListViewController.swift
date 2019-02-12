//
//  TodoListViewController.swift
//  Todoey
//
//  Created by John Cornelussen on 29/11/2018.
//  Copyright © 2018 John Cornelussen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
 @IBOutlet weak var searchBar: UISearchBar!
  
  var todoItems: Results<Item>?
  let realm = try! Realm()
  
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
//    searchBar.delegate = self
    
    tableView.separatorStyle = .none
  }
  
  
 
  
  
  //MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let item = todoItems?[indexPath.row] {
      // Set or reset the cell checkmark
      cell.textLabel?.text = item.title
      
      let gradient = CGFloat(indexPath.row) / CGFloat(todoItems!.count)
      let categoryColor = selectedCategory?.displayColor
      cell.backgroundColor = UIColor(hexString: categoryColor!)?.darken(byPercentage: gradient)
      cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categoryColor!)!, returnFlat: true)
      
      
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added."
    }
    
    return cell
  }
  
  //MARK: - Tableview Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          
          // Delete item example.
          // realm.delete(item)
          
          
          // Update simply the item properties; Realm container will ensure it is stored.
          item.done = !item.done
        }
      } catch {
        print("Error saving done status, \(error)")
      }
    }
  
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once the user clicks the Add Item button on our UIAlert
      
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new items, \(error)")
        }
      }
 
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
  
  //MARK: - Model Manupulation Methods
  
  // internal & external parameter + default value for FetchRequest (fetch everything)
  func loadItems() {
    todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

    tableView.reloadData()
  }
  
  //MARK: Delete Data From Swipe.
  override func updateModel(at indexPath: IndexPath) {
    if let selectedItem = todoItems?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(selectedItem)
        }
      } catch {
        print("Error deleting Item, \(error)")
      }
    }
  }
  
  

}


//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {


  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    // see NSPredicate cheat sheet on Realm or downloaded PDF.
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()

      // Dismiss keyboard and flashing cursor. But first make sure you are on the MAIN thread queue....
      // Although there is a lot of discussion on the Q&A if this is really necessary....
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }

}

