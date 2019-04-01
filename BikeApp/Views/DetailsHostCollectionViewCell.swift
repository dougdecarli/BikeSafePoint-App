//
//  CollectionViewCell.swift
//  BikeApp
//
//  Created by Lucas Azevedo Barruffe on 17/05/18.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class DetailsHostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var localPhoto: UIImageView!
    
    
    func displayContent(image: UIImage) {
        localPhoto.image = image
    }
}
