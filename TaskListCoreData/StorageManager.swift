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
    
    private init(){}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
     func fetchData(complition:@escaping([Task]) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
           let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
            complition(taskList)
        } catch let error {
            print(error)
        }
      
    }
    
     func save(taskName: String, completion: @escaping(Task) -> Void){
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task else { return }
        task.title = taskName
        completion(task)
        
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
     
     }
    }
}
