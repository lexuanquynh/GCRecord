//
//  GCRecordListViewModel.swift
//  GCRecord
//
//  Created by Prank on 22/11/24.
//

import Foundation


protocol GCRecordListViewModelInput {
    func saveHideRecordAlert(_ hideRecordAlert: Bool)
    func startRecord(onComplete: @escaping () -> Void)
    func stopRecord()
}


protocol GCRecordListViewModelOutput {
    var hideRecordAlert: Bool { get }
}

typealias GCRecordListViewModelType = GCRecordListViewModelInput & GCRecordListViewModelOutput

final class GCRecordListViewModel: GCRecordListViewModelType {
    
    private let recordUseCase: GCRecordUseCase
    
    init(recordUseCase: GCRecordUseCase) {
        self.recordUseCase = recordUseCase
    }
    
    func saveHideRecordAlert(_ hideRecordAlert: Bool) {
        recordUseCase.saveHideRecordAlert(hideRecordAlert)
    }
    
    var hideRecordAlert: Bool {
        return recordUseCase.isHideRecordAlert()
    }
    
    func startRecord(onComplete: @escaping () -> Void) {
        recordUseCase.startRecord(onComplete: onComplete)
            
    }
    
    func stopRecord() {
        recordUseCase.stopRecord()
    }
    
}
