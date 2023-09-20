import UIKit

extension UIViewController {
    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        return
    }
}
