//
//  LoginVC.swift
//  SnapchatClone
//
//  Created by Max Miranda on 9/18/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController, VCDelegate  {
    
    
    var logoImageView: UIImageView!
    var loginRegisterSegControl: UISegmentedControl!
    
    var nameTextField: UITextField!
    var phoneNumberTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var loginRegisterButton: UIButton!
    
    var ourUserID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 254, b: 0)
        setupLogo()
        setupSegControl()
        setupLoginRegisterButton()
        setupTextFields()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        loginRegisterButton.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @objc func handleLoginOrRegister() {
        loginRegisterButton.isUserInteractionEnabled = false
        if loginRegisterSegControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        var email = "wubba@lubbadubdub.com"
        var password = "ImMrMeeseeks"
        
        password = passwordTextField.text!
        email = emailTextField.text!
        guard password != "" else {
            displayAlert(title: "Error", message: "Password blank")
            return
        }
        
        guard email != "" else {
            displayAlert(title: "Error", message: "Email address blank")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.loginRegisterButton.isUserInteractionEnabled = true
                print(error)
                self.displayAlert(title: "There was an error", message: "Trying to sign you in")
                return
            } else {
                self.ourUserID = user?.uid
                self.performSegue(withIdentifier: "toMainFeed", sender: self)
            }
        })
        
        
    }
    
    func handleRegister() {
        var name = "Rick Morty"
        var number = "6969696969"
        var email = "wubba@lubbadubdub.com"
        var password = "ImMrMeeseeks"
        
        name = nameTextField.text!
        number = phoneNumberTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        
        guard name != "" else {
            displayAlert(title: "Error", message: "You need to enter a name")
            return
        }
        guard number != "" else {
            displayAlert(title: "Error", message: "You need to enter a number")
            return
        }
        guard email != "" else {
            displayAlert(title: "Error", message: "You need to enter an email address")
            return
        }
        guard password != "" else {
            displayAlert(title: "Error", message: "You need to enter a password")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.loginRegisterButton.isUserInteractionEnabled = true
                print(error)
                self.displayAlert(title: "There was an error", message: "Trying to make you")
                return
            } else {
                
                guard let uid = user?.uid else {
                    return
                }
                let ref = Database.database().reference()
                let userRef = ref.child("users").child(uid)
                let values = ["name": name, "number": number, "email": email]
                
                userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error)
                        return
                    } else {
                        self.ourUserID = user?.uid
                        self.performSegue(withIdentifier: "toMainFeed", sender: self)
                    }
                })
            }
        })
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        loginRegisterButton.isUserInteractionEnabled = true

    }
    
    @objc func handleLoginRegisterChange() {
        let index = loginRegisterSegControl.selectedSegmentIndex
        let title = loginRegisterSegControl.titleForSegment(at: index)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        if title == "Login" {
            nameTextField.isHidden = true
            phoneNumberTextField.isHidden = true
        } else {
            nameTextField.isHidden = false
            phoneNumberTextField.isHidden = false
        }
    }
    
    /* PART 3B START (Hint: Define a function, that's used elsewhere in PART 3 CODE) */
    func toggleColor() {
        if self.view.backgroundColor == UIColor.yellow{
            self.view.backgroundColor = UIColor.purple
        }
        else{
            self.view.backgroundColor = UIColor.yellow
        }
    }
    /* PART 3B FINISH */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        nameTextField.text = ""
        emailTextField.text = ""
        phoneNumberTextField.text = ""
        passwordTextField.text = ""
        let destination = segue.destination as? FeedVC
        destination?.userID = self.ourUserID
        // destination.vcDelegate1 = self // PART 3 CODE
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
