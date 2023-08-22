import UIKit
import FirebaseRemoteConfig
import FirebaseStorage

class HomeViewController: UIViewController {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    let storage = Storage.storage()
    var remoteConfig: RemoteConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        fetch()
    }
    
    func fetch() {
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                remoteConfig.activate { changed, error in
                    print(changed)
                    
                    let myString = remoteConfig["myString"].stringValue
                    let isButtonHidden = remoteConfig["hideButton"].boolValue
                    let myJsonData = remoteConfig["myJsonData"].dataValue
                    var informArr: [Information] = []
                    
                    guard let inform = try? JSONDecoder().decode(Human.self, from: myJsonData) else { return }
                    informArr = inform.information
                    
                    print(informArr)
                    
                    DispatchQueue.main.async {
                        self.myLabel.text = myString
                        self.myLabel.textColor = .brown
                        
                        self.myButton.isHidden = isButtonHidden
                    }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    @IBAction func moveLoginVC(_ sender: UIButton) {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else { return }
        
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func moveImageVC(_ sender: UIButton) {
        guard let imageManageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageManageViewController") else { return }
        
        navigationController?.pushViewController(imageManageVC, animated: true)
    }
}
