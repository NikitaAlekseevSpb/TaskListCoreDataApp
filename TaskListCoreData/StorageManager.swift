//
//  StorageManager.swift
//  TaskListCoreData
//
//  Created by MacBook on 12.05.2021.
//

import Foundation
import CoreData
// т.д Task это и есть база данных поэтому при обращении к экз этого типа идет обращение к базе
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
    //  созд свойство что бы не писать каждый раз persistentContainer.viewContext
    let viewContext: NSManagedObjectContext
    
    private init(){
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
// можно использовать вход пар с резалт что бы плучить инфу об ошибке
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
        // созд экз модели (это упращ варик NSEntityDescription.entity(forEntityName: "Task", in: context) else { return })
        let task = Task(context: viewContext)
        // уст знач в экз модели
        task.title = taskName
        completion(task)
        
        saveContext()
    }
    
    func editing(task: Task, newName: String) {
        // обращение к определенной ячейке базы которая передана как вход парам
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
