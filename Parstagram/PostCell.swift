//
//  PostCell.swift
//  Parstagram
//
//  Created by Daniel Cruz Castro on 10/12/21.
//

import UIKit
import Parse
import AlamofireImage

class PostCell: UITableViewCell {
    // Declarations
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
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
