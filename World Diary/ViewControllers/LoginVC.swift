//
//  LoginVCViewController.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-09.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController {
    
    var signUpMode = true
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    /*
     Rules for SIGN UP and LOGIN when the user clicks on the button SIGN UP/LOGIN
     */
    @IBAction func topTapped(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both email and password")
        } else {
            if signUpMode && (passwordTextField.text != repeatPasswordTextField.text || repeatPasswordTextField.text == "") {
                
                displayAlert(title: "Error", message: "You must repeat the password")
            } else {
                if let email = emailTextField.text {
                    if let password = passwordTextField.text {
                        if signUpMode{
                            //SIGN UP
                            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                                if error != nil {
                                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                                } else {
                                    print("Sign Up Successful")
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    self.repeatPasswordTextField.text = ""
                                    self.performSegue(withIdentifier: "Logged", sender: nil)
                                }
                            })
                        } else {
                            //LOG IN
                            Auth.auth().signIn(withEmail: email, password: password, completion:{ (user, error) in
                                if error != nil {
                                    self.displayAlert(title: "error", message: error!.localizedDescription)
                                } else {
                                    print("Log In Successful")
                                    //If LOGIN is successfull the user's details are saved locally in
                                    //UserDefaults
                                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "uid")
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    self.performSegue(withIdentifier: "Logged", sender: nil)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    /*
     The lower button rules the appearance of this view through changing the value of the
     boolean variable "signUpMode"
     */
    @IBAction func downTapped(_ sender: Any) {
        
        if signUpMode {
            topButton.setTitle("Log In", for: .normal)
            downButton.setTitle("Switch to Sign Up", for: .normal)
            repeatPasswordTextField.isHidden = true
            signUpMode = false
            
        } else {
            topButton.setTitle("Sign Up", for: .normal)
            downButton.setTitle("Switch to Log In", for: .normal)
            repeatPasswordTextField.isHidden = false
            signUpMode = true
        }
    }
    
    /*
     function for the displayAlert: this is like a template
     */
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /*
     Functions "touchesBegan" and "textFieldShouldReturn" regulate keyboard behaviour
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

