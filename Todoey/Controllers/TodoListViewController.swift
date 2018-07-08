//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Qin on 7/7/18.
//  Copyright © 2018 SpaceX. All rights reserved.
//

import UIKit

//Dont need IBOutlet nor delegate because tableview controller is used
class TodoListViewController: UITableViewController{

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
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
        cell.accessoryType = item.Done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    //check which cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets Dont to opposite value
        itemArray[indexPath.row].Done = !itemArray[indexPath.row].Done
        
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
                let newItem = Item()
                newItem.title = textField.text!
                
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
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems () {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                
                print(error)
            }
        }
    }
    

}


