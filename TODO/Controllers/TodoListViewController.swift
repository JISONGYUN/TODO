//
//  ViewController.swift
//  TODO
//
//  Created by Jake on 2020/1/7.
//  Copyright © 2020 Jake. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
     var itemArray = [Item]()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       loadItems()
       print(dataFilePath!)
       
        
      
    
    }
    
    
    
    //MARK: - table view datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done == true ? .checkmark : .none
        
       // if itemArray[indexPath.row].done == false{
       //     cell.accessoryType = .none
       //      } else {
       //      cell.accessoryType = .checkmark
       //  }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return itemArray.count
    }
    
    //MARK: Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.beginUpdates()
        saveItems()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -Add New Items
    
    @IBAction func addButtonPressed(_ sender:UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "添加项目", style: .default){
            (action) in
            // 用户单击添加项目以后执行的代码
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
           
            self.tableView.reloadData()
            
        }
        
        alert.addTextField{(alertTextField)in
            
            alertTextField.placeholder = "创建一个新项目..."
            //textfield 指向alertTextField，因为alertTextfield只存在于闭包内
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        
    }
    
    func saveItems()  {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("编码错误：\(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("解码item 错误!")
            }
        }
    }
    
}

