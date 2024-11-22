//
//  GCRecordUseCase.swift
//  GCRecord
//
//  Created by Prank on 22/11/24.
//

import Foundation

protocol GCRecordUseCase {
    func saveHideRecordAlert(_ hideRecordAlert: Bool)
    func isHideRecordAlert() -> Bool
}

final class GCDefaultRecordUseCase: GCRecordUseCase {
    private lazy var recordRepository: GCRecordRespository = {
        return GCDefaultRecordRespository()
    }()
    
    func saveHideRecordAlert(_ hideRecordAlert: Bool) {
        recordRepository.saveHideRecordAlert(hideRecordAlert)
    }
    
    func isHideRecordAlert() -> Bool {
        return recordRepository.isHideRecordAlert()
    }
}
