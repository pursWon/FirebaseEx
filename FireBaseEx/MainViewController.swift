import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let email = user?.email else { return }
        emailLabel.text = email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAlert(title: "로그인에 성공하였습니다.")
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            guard let loginVC = self.presentingViewController else { return }
            self.dismiss(animated: true) {
                loginVC.showAlert(title: "로그아웃 하였습니다.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func resignButtonClicked(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("계정 삭제 성공")
                self.dismiss(animated: true)
            }
        }
    }
}
