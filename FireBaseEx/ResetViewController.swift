import UIKit
import FirebaseAuth

class ResetViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func clearTextField() {
        idTextField.text = ""
        passWordTextField.text = ""
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        guard let email = idTextField.text else { return }
        guard let passWord = passWordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: passWord) { authResult, error in
            self.checkLogin(idText: email, passwordText: passWord)
            
            if let authResult = authResult {
                self.clearTextField()
                
                guard let passWordResetVC = self.storyboard?.instantiateViewController(withIdentifier: "PassWordResetViewController") as? PassWordResetViewController else { return }
                
                self.navigationController?.pushViewController(passWordResetVC, animated: true)
            } else {
                self.showAlert(title: "해당 계정은 존재하지 않습니다.")
                print(error.debugDescription)
            }
        }
    }
}
