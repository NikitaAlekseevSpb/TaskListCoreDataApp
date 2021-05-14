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
        showAlert(with: "New Task", and: "What do you want to do?")
        
    }
    
    private func save(taskName: String) { 
        StorageManager.shared.save(taskName: taskName) { newTask in
            self.taskList.append(newTask)
            let cellIndex = IndexPath(row: self.taskList.count - 1, section: 0)
            self.tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }
    
    
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(taskName: task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
                alert.addAction(cancelAction)
                alert.addTextField { textField in
                    textField.placeholder = "New Task"
                }
                
                present(alert, animated: true)
                
    }
    
    private func showAlertForCell(with title: String, and message: String, inex: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            self.taskList[inex].title = task
            
            StorageManager.shared.editing(taskName: task, at: inex)
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
                alert.addAction(cancelAction)
                alert.addTextField { textField in
                    textField.placeholder = "New Task"
                }
                
                present(alert, animated: true)
                
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
            
            showAlertForCell(with: "Update Task", and: "What do you want to do?", inex: indexPath.row)
            
        }
        
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                 if editingStyle == .delete {
                     taskList.remove(at: indexPath.row)
                    
                    let task = taskList[indexPath.row]
                         
                     StorageManager.shared.deleteContact(task: task)
                     tableView.deleteRows(at: [indexPath], with: .automatic)
                 }
            }
}

// MARK: - Alert Controller
extension TaskListViewController {
    
    // функция аллерта которая позволяет использовать 1 алерт для созд новой задачи и редактировния
    

    
}
