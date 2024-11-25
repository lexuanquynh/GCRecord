//
//  GCSOAPGenerationViewController.swift
//  GCRecord
//
//  Created by Prank on 15/11/24.
//

import UIKit

class GCSOAPGenerationViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: GCButton!
    @IBOutlet weak var hopitalButton: RightIconButton!
    
    @IBOutlet weak var recordListContainerView: UIView!
    @IBOutlet weak var soapListContainerView: UIView!
    
    private lazy var recordListVC: GCRecordListViewController = {
        let recordListVC = GCRecordListViewController()
        
        return recordListVC
    }()
    
    private var selectedPopupIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViews()
    }
    
    private func initViews() {
        hopitalButton.setTitle("Button my button", for: .normal)
        hopitalButton.setImage(UIImage(named: "down_ico"), for: .normal)
        hopitalButton.frame = CGRect(x: 50, y: 50, width: 200, height: 50)
        hopitalButton.backgroundColor = .white
        
        // add GCRecordListViewController to recordListContainerView
        self.addChild(recordListVC)
        recordListContainerView.addSubview(recordListVC.view)
        recordListVC.didMove(toParent: self)
        
        // add GCCurrentAISOAPViewController to soapListContainerView
        let soapListVC = GCCurrentAISOAPViewController()
        self.addChild(soapListVC)
        soapListContainerView.addSubview(soapListVC.view)
        soapListVC.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // set frame for recordListVC
        recordListVC.view.frame = recordListContainerView.bounds
    }
    
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func onSelectContentButtonTouched(_ sender: UIButton) {
        self.showPopup(at: sender)
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
    
}
