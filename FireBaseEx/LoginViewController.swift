import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseAnalytics
import GoogleSignIn

struct User {
    let email: String?
    let uid: String
    let photoURL: URL?
    let displayName: String?
}

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorder()
        signInButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    }
    
    func setBorder() {
        [idTextField, passWordTextField].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.layer.cornerRadius = 5
        }
    }
    
    func clearTextField() {
        idTextField.text = ""
        passWordTextField.text = ""
    }
    
    @objc func googleSignIn() {
        let clientID = GIDConfiguration.init(clientID: "336306821307-oqapl9lu7f2b923jnsrbkvdimvb350at.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = clientID
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let result = result {
                    print(result)
                    
                    let currentUser = User(email: result.user.email, uid: result.user.uid, photoURL: result.user.photoURL, displayName: result.user.displayName)
                    
                    guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
                    mainVC.modalPresentationStyle = .fullScreen
                    mainVC.user = currentUser
                    self.navigationController?.present(mainVC, animated: true)
                } else {
                    self.showAlert(title: "구글 로그인에 실패하였습니다.")
                }
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let email: String = idTextField.text?.description else { return }
        guard let passWord: String = passWordTextField.text?.description else { return }
        
        Auth.auth().signIn(withEmail: email, password: passWord) { authResult, error in
            self.checkLogin(idText: email, passwordText: passWord)
            
            if let authResult = authResult {
                self.clearTextField()
                let currentUser = User(email: authResult.user.email, uid: authResult.user.uid, photoURL: authResult.user.photoURL, displayName: authResult.user.displayName)
                Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                
                guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
                mainVC.user = currentUser
                mainVC.modalPresentationStyle = .fullScreen
                self.navigationController?.present(mainVC, animated: true)
            } else {
                self.showAlert(title: "해당 계정은 존재하지 않습니다.")
                print(error.debugDescription)
            }
        }
    }
    
    @IBAction func changePasswordButton(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
