//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    let context: NSManagedObjectContext
    
    static let shared = CoreDataManager()
    
    init() {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        context = container.viewContext
    }
    
    func fetchTasks(searchText: String?) -> Result<[Task], Error> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let text = searchText, !text.isEmpty {
            let predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR author CONTAINS[cd] %@ OR date CONTAINS[cd] %@",
                text,
                text,
                text
            )
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try context.fetch(fetchRequest) as? [Task]
            return .success(result ?? [])
            
        } catch let error as NSError {
            return .failure(error)
        }
    }
    
    func createElement(title: String, description: String) {
        let element = Task(context: context)
        element.title = title
        element.desc = description
        element.completed = false
        element.date = Date()
        
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
