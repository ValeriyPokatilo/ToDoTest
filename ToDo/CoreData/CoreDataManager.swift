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
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let text = searchText, !text.isEmpty {
            let predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR desc CONTAINS[cd] %@",
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
    
    func saveElement(
        task: Task? = nil,
        title: String? = nil,
        description: String? = nil,
        completed: Bool? = nil,
        completion: EmptyBlock? = nil
    ) {
        let element: Task
        
        if let task {
            element = task
        } else {
            element = Task(context: context)
            element.date = Date()
        }
        
        if let title {
            element.title = title
        }
        
        if let description {
            element.desc = description
        }
   
        if let completed {
            element.completed = completed
        }
        
        do {
            try context.save()
            completion?()
        } catch let error {
            fatalError(error.localizedDescription)
            // TODO: - return result
        }
        
        do {
            try context.save()
            completion?()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    func toggleElement(task: Task) {
        task.completed.toggle()
        saveContext()
    }
    
    func delete(task: Task, completion: @escaping EmptyBlock) {
            context.delete(task)
            
            do {
                try context.save()
                completion()
            } catch {
                fatalError(error.localizedDescription)
            }
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
