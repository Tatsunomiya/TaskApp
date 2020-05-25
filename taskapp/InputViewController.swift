//
//  InputViewController.swift
//  taskapp
//
//  Created by D on 2020/05/19.
//  Copyright © 2020 D. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextView: UITextField!






    let realm = try! Realm()
    
    
    var task: Task!







    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)


        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTextView.text = task.category







        // Do any additional setup after loading the view.
    }



    @objc func dismissKeyboard() {
        view.endEditing(true)
    }



    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextView.text!
            self.realm.add(self.task, update: .modified)
        }


        setNotification(task: task)

        super.viewWillDisappear(animated)

    }

    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()

        if task.title == "" {
            content.title = "(タイトルなし)"
        }else {
            content.title = task.title
        }

        if task.contents == "" {
            content.body = "(内容なし)"

        }else {
            content.body = task.contents
        }


        content.sound = UNNotificationSound.default



        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)


        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in print(error ?? "ローカル通知登録OK")

        }

        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/-------------")
                print(request)
                print("----------")
            }

        }

    }

}




