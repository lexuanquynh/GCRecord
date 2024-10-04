//
//  RecordAudioViewController.swift
//  GCRecord
//
//  Created by Le Xuan Quynh on 3/10/24.
//

import UIKit

class RecordAudioViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    
    //MARK:- Variables
    var recorder = AKAudioRecorder.shared
    var displayLink = CADisplayLink()
    var duration : CGFloat = 0.0
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        setCircle()
        dismissKeyboard()
    }
    
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = 30
        
        tableView.register(UINib(nibName: "RecordAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordAudioTableViewCell")
    }
    
    @IBAction func playstopButton(_ sender: UIButton) {
        if recorder.isRecording {
            animate(isRecording: true)
            recorder.stopRecording()
            tableView.reloadData()
        } else {
            animate(isRecording: false)
            recorder.record()
            setTimer()
        }
    }
}

extension RecordAudioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recorder.getRecordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordAudioTableViewCell") as! RecordAudioTableViewCell
        let recording = recorder.getRecordings[indexPath.row]      // FileName
        let name = "New Recording " + String(indexPath.row + 1)    // New Recording 1,2,3...
        cell.bindData(name: name, recording: recording)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let name = recorder.getRecordings[indexPath.row]
        recorder.play(name: name)
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordAudioTableViewCell") as! RecordAudioTableViewCell
//        cell.slider.isHidden = false
        cell.playSlider()
    }
    
    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordAudioTableViewCell") as! RecordAudioTableViewCell
//        cell.slider.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension RecordAudioViewController {
    func animate(isRecording : Bool) {
        if isRecording {
            self.playButton.layer.cornerRadius = 4
            UIView.animate(withDuration: 0.1) {
                self.playButton.transform = CGAffineTransform(scaleX: 2, y: 2)
                self.playButton.layer.cornerRadius = 15
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.playButton.transform = .identity
                self.playButton.layer.cornerRadius = 4
            }
        }
    }
    
    func setCircle() {
        self.playButton.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.playButton.layer.cornerRadius = 15
    }
    
    func setTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDuration), userInfo: nil, repeats: true)
    }
    
    @objc func updateDuration() {
        if recorder.isRecording && !recorder.isPlaying{
            duration += 1
            self.timeLabel.alpha = 1
            self.timeLabel.text = duration.timeStringFormatter
        }else{
            timer.invalidate()
            duration = 0
            self.timeLabel.alpha = 0
            self.timeLabel.text = "0:00"
        }
    }
}


//MARK:- Adding Attributes to UIView
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

//MARK:- Hide keyboard when tapped
extension UIViewController {
    // Function for tap gesture
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // Calling dismiss selector actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
