//
//  ViewController.swift
//  Todoey
//
//  Created by Anup Saud on 2024-06-23.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var barColor = BarColor()
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))


        barColor.barAppearance(for: navigationController)
        loadItem()
    
//        if let items = defaults.array(forKey: "TodoListArray") as?[Item]{
//            itemArray = items
//        }
        
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    //MARK: - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //update
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       //Delete
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItem()
        
//       if itemArray[indexPath.row].done == false{
//           itemArray[indexPath.row].done = true
//       }else{
//           itemArray[indexPath.row].done = false
//       }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItem()
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//            let encoder = PropertyListEncoder()
//            
//            do{
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            }catch{
//                print(error)
//                
//            }
//            
//            self.tableView.reloadData()
            //self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    func saveItem(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest()){

        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }

}
//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request)
    }
    
}
