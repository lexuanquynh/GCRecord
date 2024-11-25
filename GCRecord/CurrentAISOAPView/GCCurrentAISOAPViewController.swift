//
//  GCCurrentAISOAPViewController.swift
//  GCRecord
//
//  Created by Prank on 22/11/24.
//

import UIKit

class GCCurrentAISOAPViewController: UIViewController {
    @IBOutlet weak var recordCitedButton: GCButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func initUI() {
        recordCitedButton.setGradient(type: .registButton)
    }
    
    @IBAction func onRecordCitedButtonTouched(_ sender: UIButton) {
        
    }
}
