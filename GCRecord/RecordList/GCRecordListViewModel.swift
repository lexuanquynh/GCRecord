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
    var timeRemaining: Observable<Int> { get }
}

typealias GCRecordListViewModelType = GCRecordListViewModelInput & GCRecordListViewModelOutput

final class GCRecordListViewModel: GCRecordListViewModelType {
    private var timeRemainingObservable: Observable<Int>
    
    private let recordUseCase: GCRecordUseCase
    
    init(recordUseCase: GCRecordUseCase) {
        self.recordUseCase = recordUseCase
        self.timeRemainingObservable = Observable(0)
    }
    
    func saveHideRecordAlert(_ hideRecordAlert: Bool) {
        recordUseCase.saveHideRecordAlert(hideRecordAlert)
    }
    
    var hideRecordAlert: Bool {
        return recordUseCase.isHideRecordAlert()
    }
    
    func startRecord(onComplete: @escaping () -> Void) {
        recordUseCase.startRecord {
            onComplete()
        }
    }
    
    func stopRecord() {
        recordUseCase.stopRecord()
    }
    
    var timeRemaining: Observable<Int> {
        if let defaultUseCase = recordUseCase as? GCDefaultRecordUseCase {
            return defaultUseCase.remainingTime() // Return from `GCDefaultRecordUseCase`
        }
        return Observable(0) // If `recordUseCase` is not `GCDefaultRecord
    }
}
