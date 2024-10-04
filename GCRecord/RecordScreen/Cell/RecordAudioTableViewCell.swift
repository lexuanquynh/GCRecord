//
//  RecordAudioTableViewCell.swift
//  GCRecord
//
//  Created by Le Xuan Quynh on 3/10/24.
//

import UIKit

class RecordAudioTableViewCell: UITableViewCell {
    @IBOutlet weak var recordingName: UILabel!
    @IBOutlet weak var fileName: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    var displayLink = CADisplayLink()
    var recorder = AKAudioRecorder.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.setThumbImage(#imageLiteral(resourceName: "slider"), for: .normal)
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
        self.recordingName.text = name
        self.fileName.text =  "FileName :- \(recording)"
//        self.slider.isHidden = true
    }
    
    @objc func updateSliderProgress() {
        
        var progress = recorder.getCurrentTime() / Double(recorder.duration) /// progress 0 -> 1
        
        if recorder.isPlaying == false || progress == .infinity {
            displayLink.invalidate()
            progress = 0.0
        }
        debugPrint("progress: \(progress)")
        slider.value = Float(progress)  /// Slider value is equal to progress
    }
    
    func playSlider() {
        if recorder.isPlaying {
            displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
            self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
        }
    }
}
