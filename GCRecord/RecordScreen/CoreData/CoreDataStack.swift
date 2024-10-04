//
//  CoreDataStack.swift
//  GCRecord
//
//  Created by Le Xuan Quynh on 4/10/24.
//

import Foundation
import CoreData

// MARK: - CoreDataStack
class CoreDataStack {
    // MARK: - Properties
    static let shared = CoreDataStack()
    private let modelName = "GCRecordDataModel"
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                debugPrint(error)
            }
        }
        return container
    }()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Public functions
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                debugPrint("Save context successfully")
            } catch {
                debugPrint("Save context error: \(error)")
            }
        }
    }
    
    func deleteAllData() {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Prescription")
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try context.execute(batchDeleteRequest)
//            debugPrint("Delete all data successfully")
//        } catch {
//            debugPrint("Delete all data error: \(error)")
//        }
    }
}
