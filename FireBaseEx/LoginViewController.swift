import UIKit
import FirebaseCore
import FirebaseAuth
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
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    func setBorder() {
        [idTextField, passWordTextField].forEach {
            $0?.layer.borderWidth = 0.5
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.layer.cornerRadius = 5
        }
    }
    
    func clearTextField() {
        idTextField.text = ""
        passWordTextField.text = ""
    }
    
    @objc func signIn() {
        // 구글에서 파이어베이스 authencation을 사용하는 사용자의 고유 아이디값을 필요로 하기 때문에 configutration 정보를 만들어서 대입해준다.
        let clientID = GIDConfiguration.init(clientID: "336306821307-oqapl9lu7f2b923jnsrbkvdimvb350at.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = clientID
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let result = result {
                    print(result)
                    print("성공")
                } else {
                    print("실패")
                }
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let email: String = idTextField.text?.description else { return }
        guard let passWord: String = passWordTextField.text?.description else { return }
        
        Auth.auth().signIn(withEmail: email, password: passWord) { authResult, error in
            if let authResult = authResult {
                print("로그인 성공")
                let currentUser = User(email: authResult.user.email, uid: authResult.user.uid, photoURL: authResult.user.photoURL, displayName: authResult.user.displayName)
                guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
                mainVC.user = currentUser
                mainVC.modalPresentationStyle = .fullScreen
                self.navigationController?.present(mainVC, animated: true)
            } else {
                print("로그인 실패")
                print(error.debugDescription)
            }
            
            self.clearTextField()
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

