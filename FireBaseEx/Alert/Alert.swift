import UIKit
import Kingfisher

extension UIViewController {
    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        return
    }
    
    func showImage(title: String, name: String, imageURL: URL) {
        let alert = UIAlertController(title: title, message: name, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        imageView.kf.setImage(with: imageURL)
        
        alert.view.addSubview(imageView)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}
