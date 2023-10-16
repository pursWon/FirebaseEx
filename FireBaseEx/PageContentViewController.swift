import UIKit
import SnapKit
import Kingfisher

class PageContentViewController: UIViewController {
    private var myImageView = UIImageView()
    private var nameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpLayOut()
    }
    
    init(imageURL: URL, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        
        myImageView.kf.setImage(with: imageURL)
        nameLabel.text = imageName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        myImageView.contentMode = .scaleAspectFit
        nameLabel.textAlignment = .center
    }
    
    private func setUpLayOut() {
        view.addSubview(myImageView)
        view.addSubview(nameLabel)
        
        myImageView.snp.makeConstraints { make in
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(240)
            make.bottom.equalTo(-240)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
            make.top.equalTo(myImageView.snp.bottom).offset(10)
            make.bottom.equalTo(-150)
        }
    }
}

