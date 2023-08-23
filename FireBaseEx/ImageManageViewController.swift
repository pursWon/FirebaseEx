import UIKit
import FirebaseStorage
import FirebaseAuth

class ImageManageViewController: UIViewController {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var storageSearchBar: UISearchBar!
    
    let storage = Storage.storage()
    var imageNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        setUpstorageImage()
        pictureImageView.contentMode = .scaleAspectFill
    }
    
    func setUpSearchBar() {
        storageSearchBar.delegate = self
        storageSearchBar.searchBarStyle = .minimal
    }
    
    func setUpstorageImage() {
        storage.reference().child("myImages").listAll { result, error in
            guard let items = result?.items else { return }
            
            items.forEach {
                self.imageNames.append($0.name)
            }
        }
    }
    
    @IBAction func imageUploadButton(_ sender: UIButton) {
        guard let img = UIImage(named: "Van de ven") else { return }
        var data = Data()
        
        data = img.jpegData(compressionQuality: 0.8)! // 지정한 이미지를 포함하는 데이터 개체를 JPEG 형식으로 반환, 0.8은 데이터의 품질을 나타낸것 1에 가까울수록 품질이 높은 것
        let filePath = "Van de ven"
        let metaData = StorageMetadata() // Firebase 저장소에 있는 개체의 메타데이터를 나타내는 클래스, URL, 콘텐츠 유형 및 문제의 개체에 대한 FIRStorage 참조를 검색하는 데 사용
        metaData.contentType = "image/png" // 데이터 타입을 image or png
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let text = storageSearchBar.text else { return }
        
        if !imageNames.filter({ $0.components(separatedBy: ".")[0] == text }).isEmpty {
            imageNames.forEach {
                if $0.components(separatedBy: ".")[0] == text {
                    storage.reference(forURL: "gs://fir-ex-41229.appspot.com/myImages/\($0)").downloadURL { url, error in
                        guard error == nil else { return }
                        guard let url = url else { return }
                        
                        DispatchQueue.global().async {
                            if let data = try? Data(contentsOf: url) {
                                if let pictureImage = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.pictureImageView.image = pictureImage
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.pictureImageView.image = UIImage(named: "검색 X")
            }
        }
    }
}

extension ImageManageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = storageSearchBar.text else { return }
    }
}
