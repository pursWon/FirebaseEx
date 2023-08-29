import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func clearText() {
        idTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        guard
            let idText = idTextField.text,
            let passwordText = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: idText, password: passwordText) { authResult, error in
            self.checkLogin(idText: idText, passwordText: passwordText)
            
            if let error = error {
                switch error.localizedDescription {
                case "The email address is already in use by another account.":
                    self.showAlert(title: "중복된 계정입니다.")
                default:
                    print(error.localizedDescription)
                }
            } else {
                self.showAlert(title: "회원가입이 완료되었습니다.")
                self.clearText()
            }
        }
    }
}
