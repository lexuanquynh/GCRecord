//
//  GCRecordListViewController.swift
//  GCRecord
//
//  Created by Prank on 18/11/24.
//

import UIKit

class GCRecordListViewController: UIViewController {
    @IBOutlet weak var dateSelectButton: RightIconButton!
    @IBOutlet weak var recordButton: GCButton!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var transcriptTableView: UITableView!
    
    private var selectedPopupIndex: IndexPath?
    
    private var viewModel: GCRecordListViewModelType!
    
    private var isStartedRecord: Bool = false
    
    private var selectedIndexPaths: Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initViewModel()
        
    }
    
    
    private func initUI() {
        
        dateSelectButton.setTitle("Button my button", for: .normal)
        dateSelectButton.setImage(UIImage(named: "down_ico"), for: .normal)
        dateSelectButton.frame = CGRect(x: 50, y: 50, width: 200, height: 50)
        dateSelectButton.backgroundColor = .white
        dateSelectButton.didSelectButton = { [weak self] in
            guard let self else { return }
            self.showPopup(at: self.dateSelectButton)
        }
        
        recordButton.setGradient(type: .registButton)
        recordButton.setTitleColor(.black, for: .normal)
        
        timeRemainingLabel.isHidden = true
        
        // for tableView
        transcriptTableView.register(UINib(nibName: "GCTranscriptTableViewCell", bundle: nil), forCellReuseIdentifier: "GCTranscriptTableViewCell")
        transcriptTableView.delegate = self
        transcriptTableView.dataSource = self
    }
    
    private func initViewModel() {
        let recordUseCase = GCDefaultRecordUseCase()
        viewModel = GCRecordListViewModel(recordUseCase: recordUseCase)
        
        viewModel.timeRemaining.observe(on: self) { [weak self] remainingTime in
            guard let self = self else { return }
            // set title with format 残り mm:ss
           let minutes = remainingTime / 60
              let seconds = remainingTime % 60
            // if minutes < 10 then add 0 before minutes
            let minuteString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
            // if seconds < 10 then add 0 before seconds
            let secondString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            self.timeRemainingLabel.text = "　残り \(minuteString):\(secondString)"
        }
    }
    
    private func startRecordState(_ isStarted: Bool, timeout: Bool = false) {
        self.isStartedRecord = isStarted
        
        if isStarted {
            timeRemainingLabel.isHidden = false
            recordButton.setTitle("録音中", for: .normal)
            recordButton.setGradient(type: .lightPink)
            viewModel.startRecord(onComplete: { [weak self] in
                self?.showAlertRecordFinish()
                self?.startRecordState(false, timeout: true)
            })
        } else {
            if !timeout {
                timeRemainingLabel.isHidden = true
            }
            recordButton.setTitle("録音開始", for: .normal)
            recordButton.setGradient(type: .registButton)
            viewModel.stopRecord()
        }
    }
    
    private func showAlertRecordFinish() {
        let alertVC = UIAlertController(title: "録音", message: "録音時間が15分を超えたため、録音を停止しました。", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    private func showPopup(at button: UIButton) {
        let popupData = [
            "22/10/19 10:30 仮管理薬剤師",
            "22/10/29 10:30 仮管理薬剤師",
            "22/10/09 10:30 仮管理薬剤師",
            "22/10/19 10:30 仮管理薬剤師",
            "22/10/09 10:30 仮管理薬剤師"
        ]
        
        let popupVC = GCPopupViewController(data: popupData, selectedIndex: selectedPopupIndex)
        
        
        // Set the popup width equal to the button width
        popupVC.setPopupSize(width: button.frame.width, height: 250)
        
        // Callback for item selection
        popupVC.didSelectItem = { [weak self] selectedItem in
            print("Selected item: \(selectedItem)")
            self?.selectedPopupIndex = popupVC.selectedIndex // Update selected index
        }
        
        // Configure popover presentation
        popupVC.modalPresentationStyle = .popover
        if let popoverController = popupVC.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = .up
        }
        
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func onRecordTouched(_ sender: UIButton) {
        self.isStartedRecord = !self.isStartedRecord
        self.startRecordState(self.isStartedRecord)
        
        if self.viewModel.hideRecordAlert {
            return
        }
        
        if !self.isStartedRecord {
            return
        }
        // just show alert when start record
        let alertVC = GCAlertCustomViewController()
        alertVC.setCancelButtonTitle("キャンセル")
        alertVC.setOkButtonTitle("OK")
        alertVC.titleText = "録音"
        alertVC.messageText = "服薬指導の録音を開始しますか"
        alertVC.checkBoxText = "以降、このポップアップを表示せず録音を開始する。"
        alertVC.onOkTapped = { [weak self] isChecked in
            guard let self else { return }
            print("OK tapped. Checkbox selected: \(isChecked)")
            self.viewModel.saveHideRecordAlert(isChecked)
        }
        
        alertVC.onCancelTapped = {
            print("Cancel tapped.")
        }
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    @IBAction func onInfoButtonTouched(_ sender: UIButton) {
        // show alert info record
        let alertVC = UIAlertController(title: "録音", message: "録音を開始すると、録音が開始されます。", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension GCRecordListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GCTranscriptTableViewCell", for: indexPath) as! GCTranscriptTableViewCell
            let isSelected = selectedIndexPaths.contains(indexPath)
            cell.configureCell("選択（タップ）した文章は、強調表示されます。選択したものを上部のSOAP等で薬歴に引用することができます。​", index: indexPath.row, isSelected: isSelected)
            return cell
    }
    
    // automatic height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            // Deselect and remove from selectedIndexPaths
            selectedIndexPaths.remove(indexPath)
        } else {
           // Select and add to selectedIndexPath
            selectedIndexPaths.insert(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
