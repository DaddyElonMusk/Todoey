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

    
    let itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    //MARK - Tableview Datasource Methods
    //1) for making tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //2) for making tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    //check which cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        //check & uncheck
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        //only highlight when pressed
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }


}

