//
//  ViewController.swift
//  TODO
//
//  Created by Jake on 2020/1/7.
//  Copyright © 2020 Jake. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [ "买水杯","吃药","睡觉"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK: - table view datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return itemArray.count
    }
    
    //MARK: Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at:indexPath,animated:true)
    }
    
    //MARK: -Add New Items
    
    @IBAction func addButtonPressed(_ sender:UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "添加项目", style: .default){
            (action) in
            // 用户单击添加项目以后执行的代码
            self.itemArray.append(textField.text!)
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
    
}

