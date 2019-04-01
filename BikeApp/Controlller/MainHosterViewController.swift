//
//  MainHosterViewController.swift
//  BikeApp
//
//  Created by João Davila on 16/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class MainHosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var solicitationModel : [Solicitation] = [Solicitation]()
    var rentModel:[RentModel] = [RentModel]()
    
    var selectedIndex = 0
    
    @IBOutlet weak var labelBikeNumber: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHorario: UILabel!
    
    var hosterObj = Hoster(name: "", email: "", profilePhoto: #imageLiteral(resourceName: "detailsProfile"), description: "", rating: 0, rentNumber: 0, horario: "", bikerEvaluations: [], latitude: 0.0, longitude: 0.0, address: "", price: 0, localPhotos: #imageLiteral(resourceName: "detailsLivingRoom"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        
        self.solicitationModel.append(Solicitation(biker: Biker(name: "Ronaldinho", email: "ronaldinho@gmail.com", description: "I like to play soccer and ride my bike", profilePhoto: #imageLiteral(resourceName: "robson_silva"), phone: "55 51 991239344", rating: 5.0, hasSafePoint: false)))
        self.solicitationModel.append(Solicitation(biker: Biker(name: "Rivaldino", email: "rivaldino@gmail.com", description: "I like to play soccer and ride my bike smoke weed", profilePhoto: #imageLiteral(resourceName: "jon_snow"), phone: "55 51 95439344", rating: 4.0, hasSafePoint: false)))
        
        self.rentModel.append(RentModel(biker: Biker(name: "Pelé", email: "pele@pele.com", description: "Smoke weed because i`m gonna die", profilePhoto: #imageLiteral(resourceName: "milena_santos"), phone: "55 51 848454959", rating: 4.7, hasSafePoint: true)))
        self.rentModel.append(RentModel(biker: Biker(name: "Neymar", email: "neymar@pele.com", description: "Smoke weed because i`m win the world cup", profilePhoto:#imageLiteral(resourceName: "wellington"), phone: "55 51 848454959", rating: 4.7, hasSafePoint: true)))
        
    }
    
    
    //Carrega as informacoes na tela
    func loadInfo(){
        labelName.text = hosterObj.name
        labelBikeNumber.text = "0 - \(hosterObj.rentNumber)"
        imagePhoto.image = hosterObj.profilePhoto
        labelHorario.text = hosterObj.horario
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    @IBAction func unwindFromSolicitationDetails(segue: UIStoryboardSegue){}
    
    
    // MARK - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Rent"
        }
        return "Solicitation"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return solicitationModel.count
        }
        return rentModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let solicitationCell = tableView.dequeueReusableCell(withIdentifier: "solicitationCell", for: indexPath) as? SolicitationTableViewCell{
                solicitationCell.solicitation = solicitationModel[indexPath.row]
                return solicitationCell
            }
        }
        
        let rentCell = tableView.dequeueReusableCell(withIdentifier: "rentCell", for: indexPath) as? RentTableViewCell
        rentCell?.rent = rentModel[indexPath.row]
        return rentCell!
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 93
        return tableView.rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.selectedIndex = indexPath.row
            performSegue(withIdentifier: "solicitationDetailsSegue", sender: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "solicitationDetailsSegue"{
            if let destinationVC = segue.destination as? SolicitationViewController{
                destinationVC.bikerName = solicitationModel[selectedIndex].biker.name
                destinationVC.bikerRating = solicitationModel[selectedIndex].biker.rating
                destinationVC.profileBikerPhoto = solicitationModel[selectedIndex].biker.profilePhoto
                destinationVC.descriptionBiker = solicitationModel[selectedIndex].biker.description
            }
        }
    }

}
