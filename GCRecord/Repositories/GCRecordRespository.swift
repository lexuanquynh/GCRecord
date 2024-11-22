//
//  GCRecordRespository.swift
//  GCRecord
//
//  Created by Prank on 22/11/24.
//

import Foundation

protocol GCRecordRespository {
    func saveHideRecordAlert(_ hideRecordAlert: Bool)
    func isHideRecordAlert() -> Bool
}

class GCDefaultRecordRespository: GCRecordRespository {
    func saveHideRecordAlert(_ hideRecordAlert: Bool) {
        UserDefaults.standard.set(hideRecordAlert, forKey: .hideRecordAlert)
    }
    
    func isHideRecordAlert() -> Bool {
        return UserDefaults.standard.bool(forKey: .hideRecordAlert)
    }
}

// MARK: - UserDefaults Keys
fileprivate extension String {
    static let hideRecordAlert = "hideRecordAlert"
}
