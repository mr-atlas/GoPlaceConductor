//
//  CcIniciarSesionViewController.swift
//  GoPlaceCliente
//
//  Created by JacoboR on 9/11/21.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class CcIniciarSesionViewController: UIViewController {

    
    @IBOutlet weak var anchorCenteryViewContent: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var tapToCloseKeyboard: UITapGestureRecognizer!
    
    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func clickBackToIniciarRegistrarrView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginClick(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { result, errror in
            if errror != nil {
                // Couldn't sign in
                self.errorLabel.text = errror!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.HomeViewController) as? CcInicioAppViewController
                            
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }// end Auth
        
    }// end loginClick
    
}//end class CcIniciarSesionViewController: UIViewController



//MARK: - Keyboard events
extension CcIniciarSesionViewController{
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }

    private func registerKeyboardNotification() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }




    @objc private func keyboardWillShow(_ notification: Notification) {

        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let viewContentFinalPosY = self.viewContent.frame.origin.y + self.viewContent.frame.size.height

        if keyboardFrame.origin.y < viewContentFinalPosY {

            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {

                let delta = keyboardFrame.origin.y - viewContentFinalPosY
                self.anchorCenteryViewContent.constant = delta
                self.view.layoutIfNeeded()

            }, completion: nil)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {

        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0

        UIView.animate(withDuration: animationDuration) {
            self.anchorCenteryViewContent.constant = 0
            self.view.layoutIfNeeded()
        }
    }


    
}
