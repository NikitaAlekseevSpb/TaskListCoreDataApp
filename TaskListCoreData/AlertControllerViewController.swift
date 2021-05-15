//
//  AlertControllerViewController.swift
//  TaskListCoreData
//
//  Created by MacBook on 15.05.2021.
//

import UIKit
// класс для настройки аллерта
class AlertController: UIAlertController {
    // метод для кнопки алерта
    // вощзвращ знач если оно есть в текстовом поле
    func action(task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.title
        }
    }
}

    


  
