//
//  CommentCell.swift
//  Parstagram
//
//  Created by Daniel Cruz Castro on 10/20/21.
//

import UIKit

class CommentCell: UITableViewCell {
    // Declarations
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
// Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
