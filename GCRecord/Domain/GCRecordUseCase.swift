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
    func remainingTime() -> Int
}

final class GCDefaultRecordUseCase: GCRecordUseCase {
    private lazy var recordRepository: GCRecordRespository = {
        return GCDefaultRecordRespository()
    }()
    
    private let kMaxRecordTime: Int = 10 // Max time record 10s
    private var timer: Timer?
    private var remainingTimeValue: Int = 0
    private var onCompleteCallback: (() -> Void)?
    
    init() {}
    
    // MARK: - GCRecordUseCase
    
    func saveHideRecordAlert(_ hideRecordAlert: Bool) {
        recordRepository.saveHideRecordAlert(hideRecordAlert)
    }
    
    func isHideRecordAlert() -> Bool {
        return recordRepository.isHideRecordAlert()
    }
    
    func startRecord(onComplete: @escaping () -> Void) {
        debugPrint("Start Record")
        stopTimerIfNeeded()
        
        remainingTimeValue = kMaxRecordTime
        onCompleteCallback = onComplete
        
        // Khởi chạy Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRemainingTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateRemainingTime() {
        remainingTimeValue -= 1
        debugPrint("Remaining time: \(remainingTimeValue)s")
        
        if remainingTimeValue <= 0 {
            timerStopRecord()
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
    
    func remainingTime() -> Int {
        return remainingTimeValue
    }
    
    // MARK: - Helper
    private func stopTimerIfNeeded() {
        timer?.invalidate()
        timer = nil
    }
}
