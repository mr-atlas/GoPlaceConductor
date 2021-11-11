//
//  CcRecuperarContrasenaViewController.swift
//  GoPlaceCliente
//
//  Created by JacoboR on 10/11/21.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class CcRecuperarContrasenaViewController: UIViewController {

    
    @IBOutlet weak var anchorCenteryViewContent: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var tapToCloseKeyboard: UITapGestureRecognizer!
    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
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
    
    
    
    @IBAction func clickBackToIniciarRegistrarrrView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendClick(_ sender: Any) {
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().sendPasswordReset(withEmail: email) { errror in
            if errror != nil {
                let alertController = UIAlertController(title: "Error", message: "Usuario incorrecto o inexistente", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }else
            {
                self.performSegue(withIdentifier: "SegueCcIniciarSesionViewController", sender: nil)
                
                let alertController = UIAlertController(title: "Enviado Correctamente", message: "Revise su correo", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(alertController, animated: true, completion: nil)
                
                
            }

            
            
        }
    }
    
    
    

}






//MARK: - Keyboard events
extension CcRecuperarContrasenaViewController{
    
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
