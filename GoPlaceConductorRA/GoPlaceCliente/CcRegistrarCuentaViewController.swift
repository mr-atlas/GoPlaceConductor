//
//  CcRegistrarCuentaViewController.swift
//  GoPlaceCliente
//
//  Created by JacoboR on 9/11/21.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class CcRegistrarCuentaViewController: UIViewController {

    @IBOutlet weak var anchorCenteryViewContent: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var tapToCloseKeyboard: UITapGestureRecognizer!
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
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
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
        
    
    
    func validateFields() -> String? {
            
        // Verifico que todos los campos estén llenos
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Porfavor llenar los campos"
        }
            
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Contrasena minimo de 8 caracteres, con caracter especial y un numero."
        }
        return nil
    }
    
    
    
    @IBAction func clickBackToIniciarRegistrarView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpClick(_ sender: Any) {
        
        // Valido los campos
        let error = validateFields()
        
        if error != nil {
            //Si hay algun problema con los campos, muestra un mensaje de error
            showError(error!)
        }else{
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { result, errror in
                if errror != nil {
                    self.showError("Error al crear usuario") //Funcion creada mas abajo
                }else{
                    self.performSegue(withIdentifier: "SegueCcIniciarSesionViewController", sender: nil)
                }
            }//end Auth
        }

    }// end signUpClick
    
    
    // otras funciones
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }


}// end class CcRegistrarCuentaViewController: UIViewController



//MARK: - Keyboard events
extension CcRegistrarCuentaViewController{
    
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

