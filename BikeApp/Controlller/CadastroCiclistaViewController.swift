//
//  CadastroCiclistaViewController.swift
//  BikeApp
//
//  Created by Matheus Fogiatto da Silva on 18/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class CadastroCiclistaViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    

    
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
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
}

extension CadastroCiclistaViewController: UITextFieldDelegate {
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
        
        return true
    }
}
