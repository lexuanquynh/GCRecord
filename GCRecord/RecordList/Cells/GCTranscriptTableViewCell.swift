//
//  GCTranscriptTableViewCell.swift
//  GCRecord
//
//  Created by Prank on 22/11/24.
//

import UIKit

class GCTranscriptTableViewCell: UITableViewCell {
    @IBOutlet weak var sContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    private var currentColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        sContentView.backgroundColor = selected ? UIColor(hex: "E0E0E0") : self.currentColor
    }
    
    
    func binData(_ text: String, index: Int) {
        self.sContentView.backgroundColor = index % 2 == 0 ? .white : UIColor(hex: "E9F3FF")
        self.titleLabel.text = text
        self.currentColor = sContentView.backgroundColor
    }
}
