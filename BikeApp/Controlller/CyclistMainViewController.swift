//
//  CyclistMainViewController.swift
//  BikeApp
//
//  Created by Matheus Prates da Costa on 16/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit
import MapKit

class CyclistMainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    //Views dentro do modal
    @IBOutlet weak var hosterPhoto: UIImageView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBikeNumber: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelHorario: UILabel!
    
    var locationManager = CLLocationManager()
    
    var hosters = [Hoster]()
    var flagModalOpen = false
    var modalOriginalOrigin: CGFloat = 0

    @IBAction func clickTeste(_ sender: UIButton) {
        performSegue(withIdentifier: "goToDetails", sender: sender)
    }
    
    //return from HostDetailsViewController to CyclistMainViewController
    @IBAction func unwindToFirst (_ segue: UIStoryboardSegue) {
        //if let origin = segue.source as? HostDetailsViewController {
        //  print("returning to CyclistMainViewController!!")
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        textFieldSearch.delegate = self
        
        modalOriginalOrigin = modalView.frame.origin.y
        
        fixModalBug()
        
        //modalView.isHidden = true
        
        //let host1 = Hoster(name: "Paola Silva", email: "paola_silva@gmail.com", profilePhoto: #imageLiteral(resourceName: "paola_silva"), description: "Um local ótimo e seguro para deixar sua bicicleta.", rating: 4.85, rentNumber: 549, horario: "08:00AM - 13:00PM", bikerEvaluations: ["Não gostei muito, achei longe.", "Lugar tri legal pra deixar sua bike.", "Tri massa!!!!"], address: "R. Cel. Fernando Machado, 1188 - Centro Histórico, Porto Alegre - RS", price: 8, localPhotos: #imageLiteral(resourceName: "rebeca_silva"))
        
        //let host2 = Hoster(name: "Diego Correia", email: "diego_correia@gmail.com", profilePhoto:#imageLiteral(resourceName: "diego_correia"), description: "Bom lugar em uma avenida movimentada.", rating: 4.00, rentNumber: 3, horario: "08:30AM - 12:00PM", bikerEvaluations: ["Ótimo local"], address: "Av. Ipiranga, 6291, Porto Alegre - RS", price: 10.50, localPhotos: #imageLiteral(resourceName: "diego_correia"))


        //hosters.append(host1)
        //hosters.append(host2)
    }
    
    
    //Pedindo autorização para localização
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        
        //Adicionando as annotations
        for host in hosters {
            //createAnnotation(address: host.address, name: host.name)
        }
        
        getCurrentBikerLocation()
    }
    
    
    //Pegando a localização atual do ciclista
    func getCurrentBikerLocation(){
        
        /*if let currentLocation = locationManager.location{
            var region = MKCoordinateRegion()
            region.center.latitude = currentLocation.coordinate.latitude
            region.center.longitude = currentLocation.coordinate.longitude
            
            //Nivel de zoom no annotation do ciclista
            region.span.longitudeDelta = 0.015
            mapView.setRegion(region, animated: true)
        }*/
        
        let currentLocation = CLLocationCoordinate2D.init(latitude: -30.026348, longitude: -51.163268)
        
        var region = MKCoordinateRegion()
        region.center.latitude = currentLocation.latitude
        region.center.longitude = currentLocation.longitude
        
        //Nivel de zoom no annotation do ciclista
        region.span.longitudeDelta = 0.050
        mapView.setRegion(region, animated: true)
    }
    
    
    //Retorna uma coordenada de um endereço
    func createAnnotation(address: String, name: String){
        
        getCoordinateFromAddress(address: address) { (coordinate) in
            self.setNewAnnotation(coordinate: coordinate, name: name)
        }
    }
    
    
    //Cria uma annotation no mapa
    func setNewAnnotation(coordinate: CLLocationCoordinate2D, name: String){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = name
        mapView.addAnnotation(pin)
        print("Annotation criada: \(pin.coordinate)")
    }
    
    
    //Seleciona uma annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedHoster = hosters.first(where: {$0.name == view.annotation?.title}){
            //encontrou o hoster no array
            hosterPhoto.image = selectedHoster.profilePhoto
            labelRating.text = String(selectedHoster.rating)
            labelName.text = selectedHoster.name
            labelBikeNumber.text = "2-\(selectedHoster.rentNumber)"
            labelPrice.text = "R$\(selectedHoster.price)"
            //labelAddress.text = selectedHoster.address
            labelHorario.text = selectedHoster.horario
            
            //centerAnnotation(address: selectedHoster.address)
        }else{
            print("Erro ao pegar hoster no array")
        }
        
        toggleModalVisibility()
    }
    
    
    //Centraliza a annotation selecionada
    func centerAnnotation(address: String){
        
        getCoordinateFromAddress(address: address) { (coordinate) in
            var region = MKCoordinateRegion()
            region.center.latitude = coordinate.latitude
            region.center.longitude = coordinate.longitude
            region.span.longitudeDelta = 0.030
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    //Desseleciona a annotation
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        toggleModalVisibility()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textFieldSearch.isFirstResponder {
            textFieldSearch.resignFirstResponder()
        }
    }
    
    
    //Controle do modal
    func toggleModalVisibility(){
        /*if modalView.isHidden{
            modalView.isHidden = false
         }else{
            modalView.isHidden = true
        }*/
        
        if flagModalOpen{
            print("Modal Close")
            //close
            animateModalClose(duration: 0.5)
            flagModalOpen = false
        }else{
            //open
            print("Modal Open")
            animateModalOpen(duration: 0.5)
            flagModalOpen = true
        }
    }
    
    
    //Mudando a imagem da annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            let bikerPin = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "Biker")
            bikerPin.image = UIImage(named: "biker_pin")
            bikerPin.frame.size = CGSize(width: 30, height: 40)
            return bikerPin
        }else{
            let hosterPin = MKAnnotationView()
            hosterPin.image = UIImage(named: "hoster_pin")
            hosterPin.frame.size = CGSize(width: 30, height: 40)
            return hosterPin
        }
    }

    
    //Animação de abertura do modal
    func animateModalOpen(duration: Double){
        UIView.animate(withDuration: duration, animations: {
            self.modalView.frame.origin.y = (UIScreen.main.bounds.height - self.modalView.bounds.height)
            print("Origin: \(self.modalView.frame.origin.y)")
        })
    }

    
    //Animação de fechamento do modal
    func animateModalClose(duration: Double){
        UIView.animate(withDuration: duration, animations: {
            self.modalView.frame.origin.y = (UIScreen.main.bounds.height + self.modalView.bounds.height)
            print("Origin: \(self.modalView.frame.origin.y)")
        })
    }
    
    
    func fixModalBug(){
        modalView.isHidden = true
        modalView.isHidden = false
        animateModalOpen(duration: 0)
        animateModalClose(duration: 0)
    }
    
    
    //Recebe um endereco e uma funcao anonima para ser executada quando a busca terminar
    private func getCoordinateFromAddress(address: String, action: @escaping (CLLocationCoordinate2D) -> Swift.Void){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location else{
                    print("Erro ao pegar coordenada pelo endereco!")
                    return
            }
            action(location.coordinate)
        }
    }
    
    
    //Realiza a pesquisa de um endereco
    func performSearch(address: String){
        centerAnnotation(address: address)
    }

    
}


//Delegates do textfield
extension CyclistMainViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Mandar o conteudo para o metodo de gerar coordenadas
        performSearch(address: textFieldSearch.text!)
        textFieldSearch.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textFieldSearch.text = ""
        textFieldSearch.resignFirstResponder()
        return true
    }
    
}




