//
//  SolicitationViewController.swift
//  BikeApp
//
//  Created by João Davila on 17/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class SolicitationViewController: UIViewController {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bikerDescription: UILabel!
    
    var profileBikerPhoto: UIImage?
    var bikerRating: Double!
    var bikerName: String?
    var descriptionBiker: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.loadData()
    }

    func loadData(){
        profilePhoto.image = profileBikerPhoto
        rating.text = String(bikerRating)
        name.text = bikerName
        bikerDescription.text = descriptionBiker
    }


}
