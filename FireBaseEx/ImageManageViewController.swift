import UIKit
import FirebaseStorage
import FirebaseAnalytics

class ImageManageViewController: UIViewController {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var storageSearchBar: UISearchBar!
    
    let storage = Storage.storage()
    var storageItems: [StorageReference] = []
    var imageURLs: [URL] = []
    
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
            self.storageItems = items
        }
    }
    
    func setImageURL(completion: @escaping ([URL]) -> Void) {
        var urls: [URL] = []
        
        Storage.storage().reference().child("myImages").listAll { result, error in
            guard let result = result else { return }
            
            result.items.forEach {
                $0.downloadURL { url, error in
                    guard let url = url else { return }
                    urls.append(url)
                    
                    if urls.count == result.items.count {
                        completion(urls)
                    }
                }
            }
        }
    }
    
    func downloadImage(text: String) {
        let names = storageItems.map { $0.name.components(separatedBy: ".")[0] }
        
        if names.contains(text) {
            storageItems.forEach {
                if $0.name.components(separatedBy: ".")[0] == text {
                    storage.reference(forURL: "gs://fir-ex-41229.appspot.com/\($0.fullPath)").downloadURL { url, error in
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
    
    @IBAction func imageUploadButton(_ sender: UIButton) {
        guard let img = UIImage(named: "Van de ven") else { return }
        var data = Data()
        
        data = img.jpegData(compressionQuality: 0.8)! // 지정한 이미지를 포함하는 데이터 개체를 JPEG 형식으로 반환, 0.8은 데이터의 품질을 나타낸것 1에 가까울수록 품질이 높은 것
        let filePath = "Van de ven"
        let metaData = StorageMetadata() // Firebase 저장소에 있는 개체의 메타데이터를 나타내는 클래스, URL, 콘텐츠 유형 및 문제의 개체에 대한 FIRStorage 참조를 검색하는 데 사용
        metaData.contentType = "image/png" // 데이터 타입을 image or png
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        Analytics.logEvent("search_button_clicked", parameters: nil)
        guard let searchText = storageSearchBar.text else { return }
        downloadImage(text: searchText)
    }
    
    @IBAction func moveToImagesVCButtonClicked(_ sender: UIButton) {
        guard let imagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagesViewController") as? ImagesViewController else { return }
        
        setImageURL { imagesURL in
            imagesVC.imageURLs = imagesURL
            self.navigationController?.pushViewController(imagesVC, animated: true)
        }
    }
}

extension ImageManageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = storageSearchBar.text else { return }
        downloadImage(text: searchText)
    }
}
