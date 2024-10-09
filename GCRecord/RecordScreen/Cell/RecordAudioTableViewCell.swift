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
    @IBOutlet weak var slider: UISlider!

    var displayLink = CADisplayLink()
    var recorder = AKAudioRecorder.shared

    // Closure to handle end editing
    var endEditing: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        slider.setThumbImage(#imageLiteral(resourceName: "slider"), for: .normal)

        // Set the delegate for the text field
        fileName.delegate = self
        fileName.returnKeyType = .done
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
        self.fileName.text =  fileNameText
    }
    
    private var fileNameText = ""

    @objc func updateSliderProgress() {
        var progress = recorder.getCurrentTime() / Double(recorder.duration)

        if recorder.isPlaying == false || progress == .infinity {
            displayLink.invalidate()
            progress = 0.0
        }
        debugPrint("progress: \(progress)")
        slider.value = Float(progress)
    }

    func playSlider() {
        if recorder.isPlaying {
            displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
            self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
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
