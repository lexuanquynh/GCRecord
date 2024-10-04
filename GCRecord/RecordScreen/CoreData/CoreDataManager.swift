//
//  CoreDataManager.swift
//  GCRecord
//
//  Created by Le Xuan Quynh on 4/10/24.
//

import Foundation
import CoreData

// MARK: - CoreDataManager
class CoreDataManager {
    // MARK: - Properties
    static let shared = CoreDataManager()
    private let coreDataStack = CoreDataStack.shared
    private let context = CoreDataStack.shared.persistentContainer.viewContext

    // MARK: - Init
    private init() {}

    func saveRecordingToCoreData(fileName: String, audioData: Data, recordingName: String) {
        let recording = Recording(context: context)
        recording.fileName = fileName
        recording.audioData = audioData
        recording.recordingName = recordingName
        coreDataStack.saveContext()
    }

    func fetchRecordings() -> [Recording] {
        var recordings = [Recording]()
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        do {
            recordings = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching recordings: \(error)")
        }
        return recordings
    }
}

