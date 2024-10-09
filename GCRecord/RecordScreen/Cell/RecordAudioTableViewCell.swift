//
//  RecordAudioTableViewCell.swift
//  GCRecord
//
//  Created by Le Xuan Quynh on 3/10/24.
//

import UIKit

class RecordAudioTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var recordingName: UILabel!
    @IBOutlet weak var fileName: UITextField!
    @IBOutlet weak var soundSlider: UISlider!
    
    var displayLink: CADisplayLink?
    var recorder = AKAudioRecorder.shared

    // Closure to handle end editing
    var endEditing: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        soundSlider.setThumbImage(#imageLiteral(resourceName: "slider"), for: .normal)
        soundSlider.minimumValue = 0
        soundSlider.maximumValue = 1
        soundSlider.value = 0

        // Set the delegate for the text field
        fileName.delegate = self
        fileName.returnKeyType = .done
        soundSlider.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor(named: "tableView-highlight")
        } else {
            contentView.backgroundColor = .systemBackground
        }
    }

    
    func bindData(name: String, recording: String) {
        fileNameText =  "FileName :- \(recording)"
        self.recordingName.text = name
        self.fileName.text = fileNameText
    }
    
    private var fileNameText = ""

    @objc func updateSliderProgress() {
        guard recorder.duration > 0 else {
            soundSlider.value = 0
            displayLink?.invalidate()
            return
        }

        var progress = recorder.getCurrentTime() / Double(recorder.duration)

        if recorder.isPlaying == false || progress.isNaN || progress.isInfinite {
            displayLink?.invalidate()
            progress = 0.0
        }
        
        soundSlider.setValue(Float(progress), animated: true)
        debugPrint("progress: \(soundSlider.value)")
        // need layoutIfNeeded to update the slider
        self.layoutIfNeeded()

//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            slider.setValue(Float(progress), animated: true)
////            slider.value = Float(progress)
//            debugPrint("progress: \(slider.value)")
////            self.slider.layoutIfNeeded()
////            self.contentView.layoutIfNeeded()
//        }
    }

    func playSlider() {
        soundSlider.isHidden = false
        
        if recorder.isPlaying {
            // Nếu displayLink đã tồn tại, không tạo mới
            if displayLink == nil {
                displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
                displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
            }
        } else {
            displayLink?.invalidate()
            displayLink = nil
            soundSlider.isHidden = true
        }
    }

    // UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Hide the keyboard when done is pressed
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            endEditing?(text)
        } else {
            // show not empty alert
            let alert = UIAlertController(title: "Error", message: "File name can't be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            // set the file name to the previous value
            textField.text = "FileName :- \(fileNameText)"
        }
    }
}
