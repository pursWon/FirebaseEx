import UIKit

extension UIViewController {
    func checkLogin(idText: String, passwordText: String) {
        if idText.isEmpty && passwordText.isEmpty {
            self.showAlert(title: "아이디와 비밀번호를 입력해주세요.")
        } else if idText.isEmpty {
            self.showAlert(title: "아이디를 입력해주세요.")
        } else if passwordText.isEmpty {
            self.showAlert(title: "비밀번호를 입력해주세요.")
        }
    }
}
