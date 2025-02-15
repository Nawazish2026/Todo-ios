//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 60.0
        
       // loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",
                                              //   for: indexPath) as! SwipeTableViewCell
       // cell.delegate = self
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.backgroundColor = UIColor.randomFlat()
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else{
            cell.textLabel?.text = "No ToDos Yet"
            
            
        }
        
        
        
        return cell
        
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    
//                  realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error in saving done status, \(error)")
            }
        }
        tableView.reloadData()
        // print(itemArray[indexPath.row])
        
        //context.delete(itemArray[indexPath.row])
        //todoItems.remove(at: indexPath.row)
        
        
//        todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.todoItems?[indexPath.row] {
            do{
                   try self.realm.write {
                   self.realm.delete(categoryForDeletion)
                    }
                    }catch {
                      print("Error deleting category: \(error)")
                    }
//                    tableView.reloadData()
             }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            //what will happen when once the user clicks the add item button UIAlert
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving new item, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK - Model Manipulation Method
    
//    func saveItems() {
//        
//        do{
//            try context.save()
//            
//        } catch {
//            print("Errror saving context \(error)")
//        }
//        
//        tableView.reloadData()
//    }
    
        func loadItems() {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
            self.tableView.reloadData()
        }
    
                                                       }
    
    
    //MARK: - search bar methods
   
