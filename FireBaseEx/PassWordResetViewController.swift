import UIKit
import FirebaseAuth

class PassWordResetViewController: UIViewController {
    @IBOutlet weak var passWordResetTextField: UITextField!
    var existPassWord: String?
    
    func clearTextField() {
        passWordResetTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func resetPassWordButtonClicked(_ sender: UIButton) {
        guard let resetPassWord = passWordResetTextField.text else { return }
        
        guard existPassWord != resetPassWord else {
            self.clearTextField()
            self.showAlert(title: "기존의 비밀번호와 같습니다.")
        return }
        
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
