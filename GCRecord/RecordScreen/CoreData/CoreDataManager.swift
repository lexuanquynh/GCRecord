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

    func saveRecordingToCoreData(
        fileName: String,
        audioData: Data,
        recordingName: String,
        duration: Float
    ) {
        let recording = Recording(context: context)
        recording.fileName = fileName
        recording.audioData = audioData
        recording.recordingName = recordingName
        recording.duration = duration
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

    // fetch recording by name
    func fetchRecordingByName(name: String) -> Recording? {
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recordingName == %@", name)
        do {
            let recordings = try context.fetch(fetchRequest)
            return recordings.first
        } catch {
            print("Error fetching recording by name: \(error)")
        }
        return nil
    }



    // update recording
    func updateRecording(recording: Recording, newRecordingName: String) {
        recording.recordingName = newRecordingName
        coreDataStack.saveContext()
    }

    // delete recording
    func deleteRecording(recording: Recording) {
        context.delete(recording)
        coreDataStack.saveContext()
    }

}

