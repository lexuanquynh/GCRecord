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
    
    func configureCell(_ text: String, index: Int, isSelected: Bool) {
        self.sContentView.backgroundColor = isSelected ? UIColor(hex: "E0E0E0") : (index % 2 == 0 ? .white : UIColor(hex: "E9F3FF"))
        self.titleLabel.text = text
        self.currentColor = sContentView.backgroundColor
    }
}
