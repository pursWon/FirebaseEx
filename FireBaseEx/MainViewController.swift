import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(user)
        
        guard let email = user?.email else { return }
        emailLabel.text = email
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
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
