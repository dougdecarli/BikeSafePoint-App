//
//  ViewController.swift
//  BikeApp
//
//  Created by Matheus Prates da Costa on 14/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func buttonLoginClick(_ sender: UIButton) {
        //Temporario: indo para o fluxo do ciclista
        
        let storyboard = UIStoryboard(name: "CyclistFlow", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "CyclistStoryboard")
        
        self.present(controller, animated: true, completion: nil)
        
        if validateFields() {
            //OK
            signIn(email: textFieldEmail.text!, password: textFieldPassword.text!)
        }else{
            //Erro
            print("Preencha os campos")
        }
        
    }
    
    
    //Realiza o login
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let userUid = result?.user.uid{
                
            }else{
                print("Erro ao logar: \(error?.localizedDescription)")
            }
        }
    }
    
    
    //Retorna os dados do usuario
    func retrieveData(userUid: String){
        let databaseReference = Database.database().reference()
        let hosterRef = databaseReference.child("hoster").child(userUid)
        
        
    }
    
    
    //Valida os campos
    func validateFields()-> Bool{
        if (textFieldEmail.text?.isEmpty)!{
            return false
        }
        
        if (textFieldPassword.text?.isEmpty)!{
            return false
        }
        
        return true
    }

}





