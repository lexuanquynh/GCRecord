//
//  Recording+CoreDataProperties.swift
//  GCRecord
//
//  Created by Le Xuan Quynh on 9/10/24.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var audioData: Data?
    @NSManaged public var fileName: String?
    @NSManaged public var recordingName: String?
    @NSManaged public var duration: Float

}

extension Recording : Identifiable {

}
