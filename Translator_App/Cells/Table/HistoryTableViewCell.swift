//
//  HistoryTableViewCell.swift
//  Translator_App
//
//  Created by Hammad Ali on 19/05/2026.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    static let identifier = "HistoryTableViewCell"
    
    @IBOutlet weak var NameLang1: UILabel!
    @IBOutlet weak var NameLang2: UILabel!
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var OutputLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(){
        
    }
    
}
