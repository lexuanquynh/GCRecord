//
//  AKAudioRecorder.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import AVFoundation

class AKAudioRecorder: NSObject {

    //MARK:- Instance
    static let shared = AKAudioRecorder()

    //MARK:- Variables ( Private )
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()

    private var settings =   [  AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                              AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                     AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue ]

    fileprivate var timer: Timer!
    private var myRecordings = [String]()
    private var fileName : String?


    //MARK:- Public Variables
    /// Can be changed by user
    var isRecording : Bool = false
    var isPlaying : Bool = false
    var duration = CGFloat()
    var recordingName : String?
    var numberOfLoops : Int?

    //MARK:- Set Rate Limits
    var rate : Float? {
        didSet {
            if (rate! < 0.5) {
                rate = 0.5
                print("Rate cannot be less than 0.5")
            } else if (rate! > 2.0) {
                rate = 2.0
                print("Rate cannot exceed 2")
            }
        }
    }

    override init() {
        // fetch fetchRecordings
        let recordings = CoreDataManager.shared.fetchRecordings()
        for recording in recordings {
            myRecordings.append(recording.recordingName ?? "")
        }
    }

    func initByData(recording: Recording) {
        recordingName = recording.recordingName
        fileName = recording.fileName
        if let audioData: Data = recording.audioData {
            // calculate duration
            do {
                audioPlayer = try AVAudioPlayer(data: audioData)
                duration = CGFloat(audioPlayer.duration)
            } catch {
                print("initByData()",error.localizedDescription)
            }
        }
    }


    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Cannot setup audio session: \(error.localizedDescription)")
        }
    }

    //MARK:- Pre - Recording Setup
    private func InitialSetup() {
        fileName = NSUUID().uuidString   ///  unique string value
        let audioFilename = getDocumentsDirectory().appendingPathComponent((recordingName?.appending(".m4a") ?? fileName!.appending(".m4a")))
        myRecordings.append(recordingName ?? fileName!)
        if !checkRepeat(name: recordingName ?? fileName!) { print("Same name reused, recording will be overwritten")}

        do{ /// Setup audio player
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioPlayer.stop()
        } catch let audioError as NSError {
            debugPrint("Error setting up: %@", audioError)
        }
    }

    //MARK:- Record
    func record() {
        InitialSetup()

        if let audioRecorder = audioRecorder {
            if !isRecording {
                do {
                    try audioSession.setActive(true)
                    duration = 0
                    isRecording = true
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDuration), userInfo: nil, repeats: true) /// start  timer
                    audioRecorder.record() /// start recording
                    debugLog("Recording")
                } catch let recordingError as NSError{
                    print ("Error recording : %@", recordingError.localizedDescription)
                }
            }
        }
    }


    //MARK:- Stop Recording
    func stopRecording(completion: (() -> Void)? = nil) {
        if audioRecorder != nil {
            audioRecorder.stop() /// stop recording
            audioRecorder = nil
            do {
                try audioSession.setActive(false)
                isRecording = false
                debugLog("Recording Stopped")

                // save to core data
                if let fileName = fileName {
                    let path = getDocumentsDirectory().appendingPathComponent(fileName + ".m4a")
                    do {
                        if FileManager.default.fileExists(atPath: path.path) {
                            do {
                                let audioData = try Data(contentsOf: path)
                                // Proceed to save the audio data to Core Data
                                CoreDataManager.shared
                                    .saveRecordingToCoreData(
                                        fileName: fileName,
                                        audioData: audioData,
                                        recordingName: recordingName ?? fileName,
                                        duration: Float(duration)
                                    )
                            } catch {
                                debugPrint("Error reading audio file data: \(error.localizedDescription)")
                            }
                        } else {
                            debugPrint("File does not exist at path: \(path.path)")
                        }
                    }
                }
            } catch {
                print("stop()",error.localizedDescription)
            }
        }
    }


    //MARK:- Play recording
    func play(completion: @escaping (Bool) -> ()){
        if !isRecording && !isPlaying {
            if let fileName = fileName {
                let path = getDocumentsDirectory().appendingPathComponent(fileName+".m4a")
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: path)
                    (rate == nil) ? (audioPlayer.enableRate = false) : (audioPlayer.enableRate = true)
                    audioPlayer.rate = rate ?? 1.0   /// set rate
                    audioPlayer.delegate = self
                    audioPlayer.numberOfLoops = numberOfLoops ?? 0   /// set numberofloops
                    audioPlayer.play()   /// play
                    isPlaying = true
                    debugLog("Playing")
                    completion(true)
                }catch{
                    print(error.localizedDescription)
                }}else{
                    completion(false)
                    print("no file exists")
                }
        }else{
            completion(false)
            return
        }
    }


    //MARK:- Play by name
    func play(name: String) {
        setupAudioSession()

        // get from core data
        let recordings = CoreDataManager.shared.fetchRecordings()
        for recording in recordings {
            if recording.recordingName == name {
                if let audioData = recording.audioData {
                    do {
                        audioPlayer = try AVAudioPlayer(data: audioData)
                        audioPlayer.enableRate = false
                        audioPlayer.delegate = self
                        audioPlayer.play()
                        isPlaying = true
                        duration = CGFloat(recording.duration)
                        debugLog("Playing")
                    } catch {
                        print("play(with name:), ",error.localizedDescription)
                    }
                }
            }
        }
    }


    //MARK:- Stop Playing
    func stopPlaying(){
        audioPlayer.stop()   ///stop
        isPlaying = false
        debugLog("Stopped playing")
    }


    //MARK:- Delete Recording
    func deleteRecording(name: String) -> Bool{
        let path = getDocumentsDirectory().appendingPathComponent(name.appending(".m4a"))
        let manager = FileManager.default

        if manager.fileExists(atPath: path.path) {

            do {
                try manager.removeItem(at: path)
                removeRecordingFromArray(name: name)
                debugLog("Recording Deleted")

                // delete from core data
                let recordings = CoreDataManager.shared.fetchRecordings()
                for recording in recordings {
                    if recording.recordingName == name {
                        CoreDataManager.shared.deleteRecording(recording: recording)
                    }
                }
            } catch {
                print("delete()",error.localizedDescription)
            }
            return true
        } else {
            print("File is not exist.")
            return false
        }
    }


    //MARK:- remove recroding name instance
    private func removeRecordingFromArray(name: String){
        if myRecordings.contains(name){
            let index = myRecordings.firstIndex(of: name)
            myRecordings.remove(at: index!)
        }
    }


    //MARK:- Restart
    func restartPlayer(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.play()
        isPlaying = true
    }


    //MARK:- Get duration of recording
    func getDuration() -> String {
        return duration.timeStringFormatter
    }


    //MARK:- Live time
    func getCurrentTime() -> Double {
        return audioPlayer.currentTime
    }


    //MARK:- Check for overwritten files
    private func checkRepeat(name: String) -> Bool{
        var count = 0
        if myRecordings.contains(name){
            count = myRecordings.filter{$0 == name}.count
            if count > 1{
                while count != 1{
                    let index = myRecordings.firstIndex(of: name)
                    myRecordings.remove(at: index!)
                    count -= 1
                }
                return false
            }
        }
        return true
    }


    //MARK:- Track time
    @objc func updateDuration() {
        if isRecording && !isPlaying{
            duration += 1
        }else{
            timer.invalidate()
        }
    }

    //MARK:- Get path
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


//MARK:- AVAudioRecorder Delegate functions
extension AKAudioRecorder : AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        timer.invalidate()

        switch flag {
        case true:
            debugLog("record finish")
        case false:
            debugLog("record erorr")
        }
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        isRecording = false
        debugLog(error?.localizedDescription ?? "Error occured while encoding recorder")
    }
}


//MARK:- AVAudioPlayer Delegate functions
extension AKAudioRecorder: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        debugLog("playing finish")
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        debugLog(error?.localizedDescription ?? "Error occured while encoding player")
    }
}


//MARK:- Convert Time to String
extension CGFloat{
    var timeStringFormatter : String {
        let format : String?
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        if minutes < 60 {    format = "%01i:%02i"   }
        else {    format = "%01i:%02i"    }
        return String(format: format!, minutes, seconds)
    }
}


//MARK:- Computed property to get list of recordings
extension AKAudioRecorder{
    var getRecordings : [String] {
        return self.myRecordings
    }
}


//MARK:- Easy debugging
public func debugLog(_ message: String) {
#if DEBUG
    debugPrint("=================================================")
    debugPrint(message)
    debugPrint("=================================================")
#endif
}
