//
//  HostDetailsViewController.swift
//  BikeApp
//
//  Created by Lucas Azevedo Barruffe on 16/05/18.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit



class HostDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var localPhotosCollection: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var availableTimeLabel: UILabel!
    @IBOutlet weak var bikeCapacityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var reviewFromOthersLabel: UILabel!
    
    var host: Hoster!
    let reuseIdentifier = "cell";

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = localPhotosCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        //host = Hoster(name: "Paola Silva", email: "paola_silva@gmail.com", profilePhoto: #imageLiteral(resourceName: "detailsProfile"), description: "Um local ótimo e seguro para deixar sua bicicleta.", rating: 4.85, rentNumber: 549, horario: "08:00AM - 13:00PM", bikerEvaluations: ["Não gostei muito, achei longe.", "Lugar tri legal pra deixar sua bike.", "Tri massa!!!!", "Local muito bacana e próximo do meu trabalho."], address: "R. Cel. Fernando Machado, 1188 - Centro Histórico, Porto Alegre - RS", price: 8, localPhotos: #imageLiteral(resourceName: "detailsLivingRoom"))

        nameLabel.text = host.name
        profilePhoto.image = host.profilePhoto
        placeDescriptionLabel.text = host.description
        ratingLabel.text = String(host.rating)
        rentLabel.text = String(host.rentNumber)
        availableTimeLabel.text = host.horario
        reviewFromOthersLabel.text = host.bikerEvaluations.last
        addressLabel.text = host.address
        //self.localPhotosCollection.reloadSections(IndexSet(integer: 0))
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DetailsHostCollectionViewCell
        
        let image = host.localPhotos
        cell.displayContent(image: image)
        return cell
    }
   
}


