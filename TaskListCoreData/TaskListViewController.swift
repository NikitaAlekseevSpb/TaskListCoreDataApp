//
//  TaskListViewController.swift
//  TaskListCoreData
//
//  Created by MacBook on 12.05.2021.
//

import UIKit

class TaskListViewController: UITableViewController {

    private let cellID = "cell"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        StorageManager.shared.fetchData { taskLists in
            self.taskList = taskLists
        }
}

    // MARK: - Privare Methods
    
    private func setupNavigationBar(){
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask(){
        showAlert()
        
    }
    
    private func save(taskName: String) { 
        StorageManager.shared.save(taskName: taskName) { newTask in
            self.taskList.append(newTask)
            let cellIndex = IndexPath(row: self.taskList.count - 1, section: 0)
            self.tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }

}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
        
    }
   
}
    
    
    // MARK: - UITableViewDelegate

    extension TaskListViewController {
       
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let task = taskList[indexPath.row]
            showAlert(task: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            
            
        }
        
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                    
            let task = taskList[indexPath.row]
            
            if editingStyle == .delete {
                taskList.remove(at: indexPath.row)
                         
                     StorageManager.shared.deleteContact(task: task)
                     tableView.deleteRows(at: [indexPath], with: .automatic)
                 }
            }
}

// MARK: - Alert Controller
extension TaskListViewController {
    
    // функция аллерта которая позволяет использовать 1 алерт для созд новой задачи и редактировния
    // для настройки алерта созд кастомный класс 
private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
    
    let title = task != nil ? "Update Task" : "New Task"
    
    let alert = AlertController(
        title: title,
        message: "What do you want to do?",
        preferredStyle: .alert
    )
    
    alert.action(task: task) { taskName in
        if let task = task, let completion = completion {
            StorageManager.shared.editing(task: task, newName: taskName)
            completion()
        } else {
            self.save(taskName: taskName)
        }
    }
    present(alert, animated: true)
    }
}
