//
//  RentTableViewCell.swift
//  BikeApp
//
//  Created by João Davila on 16/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class RentTableViewCell: UITableViewCell {

    var rent: RentModel!{
        didSet{
            self.nameCyclist.text = rent.biker.name
            self.photoCyclist.image = rent.biker.profilePhoto
        }
    }
    
    @IBOutlet weak var nameCyclist: UILabel!
    @IBOutlet weak var photoCyclist: UIImageView!
    
}
