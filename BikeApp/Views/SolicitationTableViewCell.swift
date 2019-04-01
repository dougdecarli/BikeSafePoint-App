//
//  SolicitationTableViewCell.swift
//  BikeApp
//
//  Created by João Davila on 16/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class SolicitationTableViewCell: UITableViewCell {

    var solicitation: Solicitation!{
        didSet{
            self.nameCyclist.text = solicitation.biker.name
            self.photoCyclist.image = solicitation.biker.profilePhoto
        }
    }
    
    @IBOutlet weak var nameCyclist: UILabel!
    @IBOutlet weak var photoCyclist: UIImageView!
}
