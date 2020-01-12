//
//  ViewController.swift
//  TODO
//
//  Created by Jake on 2020/1/7.
//  Copyright © 2020 Jake. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
     var itemArray = [Item]()
    
    var selectedCategory: Category?{
        didSet {
            loadItems()
        }
    }
    
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
     
        //数据库位置
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
        
      
      
    
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
        
       // let title = itemArray[indexPath.row].title
        //itemArray[indexPath.row].setValue(title! + " - (已完成）", forKey: "title")
        
        saveItems()
        
        tableView.beginUpdates()
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
          
          
            let newItem = Item(context: self.context)
           
            newItem.title = textField.text!
            newItem.done = false //默认done属性为false，因为数据模型中它是必填项目
            newItem.parentCategory = self.selectedCategory//将selectedCategory的属性给item的parentCategory属性
            self.itemArray.append(newItem)
            self.saveItems()
           
            
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
        
    do{
        try context.save()
    } catch{
        print("保存context错误：\(error)")
      }
        
        tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)//筛选载入项目
        
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        } else {
             request.predicate = categoryPredicate
        }
        
           
        
       do{
            itemArray = try context.fetch(request)
         } catch {
            print("从context获取数据出错：\(error)")
        }
        
         tableView.reloadData()
    }
    


  


}


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: " title CONTAINS[c] %@ ", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
          loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String)  {
        
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

