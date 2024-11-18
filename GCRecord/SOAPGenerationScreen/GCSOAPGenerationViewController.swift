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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
    }
    
    private func initViews() {
        hopitalButton.setTitle("Button my button", for: .normal)
        hopitalButton.setImage(UIImage(named: "down_ico"), for: .normal)
        hopitalButton.frame = CGRect(x: 50, y: 50, width: 200, height: 50)
        hopitalButton.backgroundColor = .white
        
        // set image insert left is hopitalButton width - 20
//        hopitalButton.configureImageToRight(withPadding: 20)

        // add GCRecordListViewController to recordListContainerView
        self.addChild(recordListVC)
        recordListContainerView.addSubview(recordListVC.view)
        recordListVC.didMove(toParent: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // set frame for recordListVC
        recordListVC.view.frame = recordListContainerView.bounds
    }

}

extension UIButton {
    func configureImageToRight(withPadding padding: CGFloat = 20) {
        guard let currentImage = self.imageView?.image else { return }
        
        let width = self.bounds.size.width
        let imageWidth = currentImage.size.width
        let space = width - 50 - imageWidth

        // Set up the button configuration
        var config = UIButton.Configuration.plain()
        config.image = currentImage
        config.imagePlacement = .trailing // Place image to the right
        config.imagePadding = space - 20 // Set space between title and image
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 60) // Adjust trailing inset
        self.configuration = config
    }
}
