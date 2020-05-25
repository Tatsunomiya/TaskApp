//
//  ViewController.swift
//  taskapp
//
//  Created by D on 2020/05/19.
//  Copyright © 2020 D. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
     //サーチバー作成

    
    
    let realm = try! Realm()
    

    
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    

    var filteredData: [String]!

    


    
    
//    func searchItems(searchText: String) {
//        //要素を検索する
//        if searchText != "" {
//
//            var TaskCategory = realm.objects(Task.self)
//
//
//
//
//            // NSPredicateを使って検索条件を指定します
//            let predicate = NSPredicate(format: "ccategory", searchText)
//            TaskCategory = realm.objects(Task.self).filter(predicate)
//
//
//            //渡された文字列が空の場合は全てを表示
//        //tableViewを再読み込みする
//        tableView.reloadData()
//    }
//
//    }
//

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        mySearchBar = UISearchBar()
//        mySearchBar.delegate = self
//        mySearchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
//        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 50)
//        mySearchBar.showsCancelButton = true
//        mySearchBar.placeholder = "会社への不満を入力して下さい"
//        self.view.addSubview(mySearchBar)
//

        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        searchBar.showsCancelButton = true

        

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForWorAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let task = self.taskArray[indexPath.row]
            
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
            center.getPendingNotificationRequests {(requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/------------")
                    print(request)
                    print("------------/")
                }
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            
        } else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            
            inputViewController.task = task
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    


    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // When there is no text, filteredData is the same as the original data
    // When user has entered text into the search box
    // Use the filter method to iterate over all items in the data array
    // For each item, return true if the item should be included and false if the
    // item should NOT be included
        

        
//                    let predicate = NSPredicate("category",contains: "searchText")
        
        
        
       let predicate = NSPredicate(format: "category contains %@", searchText)
        

        


        
        


        
        taskArray = realm.objects(Task.self).filter(predicate)
        
        searchBar.showsCancelButton = true

           tableView.reloadData()



}
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()


        print("キャンセルボタンがタップ")
    }

}



