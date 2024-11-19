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
    
    private var selectedPopupIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
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
    }
    
    private func showPopup(at button: UIButton) {
        let popupData = [
            "22/10/09 10:30 仮管理薬剤師",
            "22/10/09 10:30 仮管理薬剤師",
            "22/10/09 10:30 仮管理薬剤師"
        ]
        
        let popupVC = GCPopupViewController(data: popupData, selectedIndex: selectedPopupIndex)
        
        
        // Set the popup width equal to the button width
        popupVC.setPopupSize(width: button.frame.width, height: 300)
        
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
        // show alert with title: 録音
        // message:
        // 服薬指導の録音を開始しますか tick icon and 以降、このポップアップを表示せず録音を開始する。
        // 2 buttons: キャンセル and OK
//        let alert = UIAlertController(title: "録音", message: "服薬指導の録音を開始しますか", preferredStyle: .alert)
//        alert.addTitleText(title: "録音", image: UIImage(named: "tick_ico")!)
//
//
//
//        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
//
//        present(alert, animated: true, completion: nil)
        
        let alertVC = GCAlertCustomViewController()
        alertVC.setCancelButtonTitle("キャンセル")
        alertVC.setOkButtonTitle("OK")
        alertVC.titleText = "録音"
        alertVC.messageText = "服薬指導の録音を開始しますか"
        alertVC.checkBoxText = "以降、このポップアップを表示せず録音を開始する。"
//        alertVC.messageText = """
//        This is a very long message to test if the text will wrap correctly when the content is too large to fit in a single line.
//        Make sure it looks good on different devices, and it adjusts the height dynamically!
//        """
        alertVC.onOkTapped = { isChecked in
            print("OK tapped. Checkbox selected: \(isChecked)")
        }
        alertVC.onCancelTapped = {
            print("Cancel tapped.")
        }
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)

    }
    
    
}
