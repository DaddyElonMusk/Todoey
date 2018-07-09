//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Qin on 7/7/18.
//  Copyright © 2018 SpaceX. All rights reserved.
//

import UIKit
import CoreData

//Dont need IBOutlet nor delegate because tableview controller is used
class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //context is the temperary loading aera
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadItems()
    }
    
    
    
    //MARK - Tableview Datasource Methods
    //1) for making tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //2) for making tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*doesnt work with checkmark becuase everytime the cell disappear, when scroll
          back a new cell is drawn */
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    //check which cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //remove order matters. Remove from context first
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        
        //sets Dont to opposite value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
       
        //only highlight when pressed
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todoey", style: .default) { (action) in
            //what will happen once user clicks the Add item button on our UIAlert
            
            
            if textField.text != "" {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            } else {
                return
            }
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    //Have to call this method to commit changes in the presistant database
    func saveItems () {
        
        do {

            
            try context.save()
            
            
        } catch {
            print("Error Saving Context: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    ///
    func loadItems (with request : NSFetchRequest<Item> = Item.fetchRequest()) {

        do {
            
            itemArray = try context.fetch(request)

        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    

    
}

//MARK: - split up functionalities to make code more readable
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //user entered: searchBar.text
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with : request)

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText != "" {
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        
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


