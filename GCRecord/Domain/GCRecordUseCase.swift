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
    func startRecord(onComplete: @escaping () -> Void)
    func stopRecord()
}

final class GCDefaultRecordUseCase: GCRecordUseCase {
    private lazy var recordRepository: GCRecordRespository = {
        return GCDefaultRecordRespository()
    }()
    
    private var timeRemainingObservable: Observable<Int>
    // Max time record 15 minutes
    private let kMaxRecordTime: Int = 15 * 60
    private var timer: Timer?
    private var remainingTimeValue: Int = 0
    private var onCompleteCallback: (() -> Void)?
    
    init() {
        self.remainingTimeValue = kMaxRecordTime
        self.timeRemainingObservable = Observable(remainingTimeValue)
    }
    
    // MARK: - GCRecordUseCase
    
    func saveHideRecordAlert(_ hideRecordAlert: Bool) {
        recordRepository.saveHideRecordAlert(hideRecordAlert)
    }
    
    func isHideRecordAlert() -> Bool {
        return recordRepository.isHideRecordAlert()
    }
    
    func startRecord(onComplete: @escaping () -> Void) {
        timer?.invalidate()
        remainingTimeValue = kMaxRecordTime
        timeRemainingObservable.value = remainingTimeValue
        
        // Start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.remainingTimeValue -= 1
            self?.timeRemainingObservable.value = self?.remainingTimeValue ?? 0
            
            if self?.remainingTimeValue ?? 0 <= 0 {
                timer.invalidate()
                onComplete()
            }
        }
    }
    
    @objc private func timerStopRecord() {
        stopTimerIfNeeded()
        onCompleteCallback?()
    }
    
    func stopRecord() {
        debugPrint("Stop Record")
        stopTimerIfNeeded()
    }
    
    func remainingTime() -> Observable<Int> {
        return timeRemainingObservable
    }
    
    // MARK: - Helper
    private func stopTimerIfNeeded() {
        timer?.invalidate()
        timer = nil
    }
}
