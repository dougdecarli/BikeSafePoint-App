//
//  CadastroHostViewController.swift
//  BikeApp
//
//  Created by Matheus Fogiatto da Silva on 16/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import CoreLocation

class CadastroHostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
   
    var hosterObj = Hoster(name: "", email: "", profilePhoto: #imageLiteral(resourceName: "wellington"), description: "", rating: 0, rentNumber: 0, horario: "", bikerEvaluations: [], latitude: 0.0, longitude: 0.0, address: "", price: 0, localPhotos: #imageLiteral(resourceName: "detailsLivingRoom"))
    
    var city = "cidade"

    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if validateTextFields(){
            hosterObj.name = nameTextField.text!
            hosterObj.name += " \(lastNameTextField.text!)"
            hosterObj.email = emailTextField.text!
            hosterObj.address = adressTextField.text!
            self.city = cityTextField.text!
            hosterObj.address +=  " \(numberTextField.text!)"
            hosterObj.address +=  " \(self.city)"
            hosterObj.profilePhoto = profileImage.image!
            
            var imageData = UIImagePNGRepresentation(hosterObj.profilePhoto)
            
            signUp(address: hosterObj.address, email: hosterObj.email, password: passwordTextField.text!, image: imageData!)
            
        }else{
            showSimpleAlert(title: "Ops...", message: "Preencha todos os campos!")
        }
        
        print("Name: \(hosterObj.name) \n Email: \(hosterObj.email) \n Address: \(hosterObj.address)")
    }
    
    
    //Valida os campos
    func validateTextFields() -> Bool{
        if (nameTextField.text?.isEmpty)!{
            return false
        }
        
        if (lastNameTextField.text?.isEmpty)!{
            return false
        }
        
        if (emailTextField.text?.isEmpty)!{
            return false
        }
        
        if (phoneTextField.text?.isEmpty)!{
            return false
        }
        
        if (adressTextField.text?.isEmpty)!{
            return false
        }
        
        if (cityTextField.text?.isEmpty)!{
            return false
        }
        
        if (numberTextField.text?.isEmpty)!{
            return false
        }
        
        if (passwordTextField.text?.isEmpty)! || (confirmPasswordTextField.text?.isEmpty)!{
            return false
        }else{
            if passwordTextField.text != confirmPasswordTextField.text{
                return false
            }
        }
        
        return true
    }
    
    
    //Mostra um alert com uma mensage e um botao OK
    func showSimpleAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action1)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //Mostra um alert com alguma acao ao clicar no botao
    func showActionAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Entrar", style: .default) { (action) in
            self.performSegue(withIdentifier: "goToHostFlow", sender: nil)
        }
        
        alert.addAction(action1)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //Prepara a segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHostFlow" {
            let destVC = segue.destination as! UITabBarController
            let vc = destVC.viewControllers![0] as! MainHosterViewController
            vc.hosterObj = self.hosterObj
        }
        let storyboard = UIStoryboard(name: "HostFlow", bundle: nil)
        let ivc = storyboard.instantiateViewController(withIdentifier: "hostMainFlow")
        self.tabBarController?.present(ivc, animated: true, completion: nil)
    }
    


    
    @IBAction func imagePicker(_ sender: UIButton) {
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    } 
    // Image Picker Protocols
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //
    //FIREBASE
    //
    
    //Cadastra o host
    //Cadastra no auth, pega uid e envia a imagem para o storage, pega o link da imagem e salva no database
    func registerHoster(email: String, password: String, image: Data){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let userUid = result?.user.uid{
                self.uploadImage(userUid: userUid, image: image)
            }else{
                print("Erro ao cadastrar: \(error?.localizedDescription)")
                self.showSimpleAlert(title: "Ops...", message: "Falha ao realizar cadastro :(")
            }
        }
    }
    
    //Salva a imagem no storage
    func uploadImage(userUid: String, image: Data){
        //Storage
        let storageDefault = Storage.storage()
        let storageRef = storageDefault.reference()
        let profilePhotoRef = storageRef.child("ProfilePhotos")
        
        let userRef = profilePhotoRef.child(userUid)
        
        let uploadTask = userRef.putData(image, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else{
                self.showSimpleAlert(title: "Ops...", message: "Erro ao enviar imagem :(")
                return
            }
            
            let imageUrl = metadata.path
            
            self.saveInDatabase(userUid: userUid, imageUrl: imageUrl!)
        }
    }
    
    
    //Salva as info do usuario no database
    func saveInDatabase(userUid: String, imageUrl: String){
        let databaseReference = Database.database().reference()
        let hosterRef = databaseReference.child("hoster").child(userUid)
        
        hosterRef.child("name").setValue(hosterObj.name)
        hosterRef.child("email").setValue(hosterObj.email)
        hosterRef.child("description").setValue(hosterObj.description)
        hosterRef.child("horario").setValue(hosterObj.horario)
        hosterRef.child("price").setValue(hosterObj.price)
        hosterRef.child("profilePhoto").setValue(imageUrl)
        hosterRef.child("rating").setValue(hosterObj.rating)
        hosterRef.child("rentNumber").setValue(hosterObj.rentNumber)
        hosterRef.child("latitude").setValue(hosterObj.latitude)
        hosterRef.child("longitude").setValue(hosterObj.longitude)
        
        showSimpleAlert(title: "Cadastrado", message: "Bem vindo \(hosterObj.name)")
    }
    
    
    //Pega as coordenadas de um endereco
    private func signUp(address: String, email: String, password: String, image: Data){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location else{
                    print("Erro ao pegar coordenada pelo endereco!")
                    return
            }
            self.hosterObj.latitude = location.coordinate.latitude
            self.hosterObj.longitude = location.coordinate.longitude
        }
        
        self.registerHoster(email: email, password: password, image: image)
    }

}


extension CadastroHostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""{
            return true
        }
        if textField == phoneTextField {
            if(phoneTextField.text?.count)! > 13{
                return false
            }
            if phoneTextField.text?.count == 0{
                phoneTextField.text = (phoneTextField.text)! + "("
            }
            if phoneTextField.text?.count == 3{
                phoneTextField.text = (phoneTextField.text)! + ")"
            }
            if phoneTextField.text?.count == 9{
                phoneTextField.text = (phoneTextField.text)! + "-"
            }
        }
        if  textField == postalCodeTextField{
            if(postalCodeTextField.text?.count)! > 8{
                return false
            }
            if postalCodeTextField.text?.count == 5{
                postalCodeTextField.text = (postalCodeTextField.text)! + "-"
            }
        }
        
        return true
    }
}

