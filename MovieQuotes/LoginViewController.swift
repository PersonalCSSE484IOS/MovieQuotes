//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 4/18/22.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
class LoginViewController: UIViewController{
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle = AuthManager.shared.addLoginObserver {
            print("TODO: Fire the showlist segue! there is already someone signed in ")
            self.performSegue(withIdentifier: kshowListSegue, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }

    @IBAction func pressedCreateNewUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        print("Create user")
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: password)
    }
    
    @IBAction func pressedExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        print("login user")
        AuthManager.shared.loginExistingEmailPasswordUser(email: email, password: password)
    }
    
    @IBAction func pressRosefire(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: kRosefireRegToken){(err, result) in
            if let err = err{
                print("Rosefire sign in error \(err)")
                return
            }
           // print("Result \(result!.token!)")
           // print("Result \(result!.username!)")
            print("Result \(result!.name!)")
           // print("Result \(result!.email!)")
           // print("Result \(result!.group!)")
            
            AuthManager.shared.signInWithRosefireToken(result!.token)
        }
    }
    @IBAction func pressedGoogleSignIn(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {user, error in

          if let error = error {
            print("Error with google sign in \(error)")
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

          print("Google Sign in Worked! Now use the credential to do the real fIREBASE SIGN IN")
            
            AuthManager.shared.signInWithGoogleCredential(credential)
        }
    }
}
