//
//  TodoListViewController.swift
//  Todoey
//
//  Created by John Cornelussen on 29/11/2018.
//  Copyright © 2018 John Cornelussen. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
 @IBOutlet weak var searchBar: UISearchBar!
  
  var itemArray = [Item]()
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  
  
  // See section 18, lecture 237 & 238.
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    searchBar.delegate = self
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
    
    // If you want to Update the title:
    //   itemArray[indexPath.row].setValue("Completed", forKey: "title")
    
    // If you want to DELETE the selected row, use the following statements in THIS order:
    // context.delete(itemArray[indexPath.row])  // STEP 1
    // itemArray.remove(at: indexPath.row)       // STEP 2
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    // COMMIT the changes from the temporary (Context) area to the persistant container (SQLite DB)
    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once the user clicks the Add Item button on our UIAlert
      
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      self.itemArray.append(newItem)
      
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
  
  //MARK: - Model Manupulation Methods
  
  func saveItems() {
    
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    // reload the table to display the new item in the tableview.
    tableView.reloadData()
  }
  
  // internal & external parameter + default value for FetchRequest (fetch everything)
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    }
    
    
    do {
      itemArray = try context.fetch(request)
//      let count = try context.count(for: request)
//      print("Number of Items fetched: \(count)")
    } catch {
      print("Error fetching data from context \(error)")
    }
    
    tableView.reloadData()
  }
  

}


//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    // see NSPredicate cheat sheet on Realm or downloaded PDF.
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request, predicate: predicate)
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

