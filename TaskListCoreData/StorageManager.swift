//
//  StorageManager.swift
//  TaskListCoreData
//
//  Created by MacBook on 12.05.2021.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    let viewContext: NSManagedObjectContext
    
    private init(){
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    func fetchData(complition:@escaping([Task]) -> Void) {
       let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
       
       do {
          let taskList = try viewContext.fetch(fetchRequest)
           complition(taskList)
       } catch let error {
           print(error)
       }
     
   }
    
     func save(taskName: String, completion: @escaping(Task) -> Void){
        let task = Task(context: viewContext)
        task.title = taskName
        completion(task)
        
        saveContext()
    }
    
    func editing(task: Task, newName: String) {
        task.title = newName
        saveContext()
}
    
    func deleteContact(task: Task) {
        viewContext.delete(task)
        saveContext()
}
    
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
