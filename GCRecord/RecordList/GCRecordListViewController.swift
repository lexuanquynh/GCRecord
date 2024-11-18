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
    
}
