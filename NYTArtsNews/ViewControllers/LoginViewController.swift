//
//  NYTLoginViewController.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var loginViewModel = LoginViewModel()
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            if(email == "") {
                showAlert(title: "Error", message: K.ErrorMsg.errorEmailMsg)
            }else if(password == ""){
                showAlert(title: "Error", message: K.ErrorMsg.errorPasswordMsg)
                
            } else {
                //                    loginViewModel.authenticateUser(completionBlock: { () in
                //                        DispatchQueue.main.async { [weak self] in
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
                //                        }
                //                    })
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

