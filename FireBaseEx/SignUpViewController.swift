import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        guard let idText = idTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: idText, password: passwordText) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(authResult?.user.email)
            }
        }
    }
}
