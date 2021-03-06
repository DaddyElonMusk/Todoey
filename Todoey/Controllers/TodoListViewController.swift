//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Qin on 7/7/18.
//  Copyright © 2018 SpaceX. All rights reserved.
//

import UIKit
import RealmSwift

//Dont need IBOutlet nor delegate because tableview controller is used
class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    //only get called if category has a value
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //context is the temperary loading aera
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.title = selectedCategory?.categoryName
    }
    
    
    
    //MARK - Tableview Datasource Methods
    //1) for making tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    //2) for making tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*doesnt work with checkmark becuase everytime the cell disappear, when scroll
          back a new cell is drawn */
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    //check which cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //remove order matters. Remove from context first
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

//
//        //sets Dont to opposite value
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
//
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
           
        }
        
        tableView.reloadData()
        
        //only highlight when pressed
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todoey", style: .default) { (action) in
            //what will happen once user clicks the Add item button on our UIAlert
            
            //if let to check if self.selectedCategory is nil or not
            if let currentCategory = self.selectedCategory {
                
                do {
                    
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                } catch {
                    print("Error Saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
//    //Have to call this method to commit changes in the presistant database
//    func saveItems () {
//
//        do {
//
//            try context.save()
//
//        } catch {
//            print("Error Saving Context: \(error)")
//        }
//
//        self.tableView.reloadData()
//
//    }
    
    ///
    func loadItems () {

        //create a predicate to filter out unwanted items
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.categoryName!)
//
//        if let addtionalPredicate = predicate {
//
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//
//            itemArray = try context.fetch(request)
//
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    

    
}





//MARK: - split up functionalities to make code more readable
//search function
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //user entered: searchBar.text
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with : request)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
        //.sorted(byKeyPath : "title", ascending : true)

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText != "" {
            
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
//
//            //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request)
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)

        
        } else {
            
            loadItems()
        }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)

        loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    
    
 
}


