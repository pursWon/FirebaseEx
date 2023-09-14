import UIKit
import FirebaseAuth

class PassWordResetViewController: UIViewController {
    @IBOutlet weak var passWordResetTextField: UITextField!
    
    func clearTextField() {
        passWordResetTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func resetPassWordButtonClicked(_ sender: UIButton) {
        guard let resetPassWord = passWordResetTextField.text else { return }
        
        Auth.auth().currentUser?.updatePassword(to: resetPassWord) { error in
            if error == nil {
                do {
                    try Auth.auth().signOut()
                    self.clearTextField()
        
                    guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                    
                    self.navigationController?.pushViewController(loginVC, animated: true)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                guard let error = error?.localizedDescription else { return }
        
                print(error)
            }
        }
    }
}
