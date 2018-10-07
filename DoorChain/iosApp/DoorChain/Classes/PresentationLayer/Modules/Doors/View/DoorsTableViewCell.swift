//
//  DoorsTableViewCell.swift
//  DoorChain
//
//  Created by Vladimir Sharaev on 06/10/2018.
//  Copyright © 2018 PixelPlex. All rights reserved.
//

import UIKit

protocol DoorsTableViewCellDelegate: class {
    func deleteDoor(door: Door)
    func editDoor(door: Door)
}

class DoorsTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var door: Door! {
        didSet {
            nameLabe.text = door.name
        }
    }
    
    var isOwner: Bool = false {
        didSet {
//            deleteButton.isHidden = !isOwner
//            editButton.isHidden = !isOwner
        }
    }

    weak var delegate: DoorsTableViewCellDelegate?
    
    @IBAction func actionEdit(_ sender: Any) {
        delegate?.editDoor(door: door)
    }
    
    @IBAction func actioDelete(_ sender: Any) {
        delegate?.deleteDoor(door: door)
    }
    
}
