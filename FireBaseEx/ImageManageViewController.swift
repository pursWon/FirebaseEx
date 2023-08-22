import UIKit
import FirebaseStorage

class ImageManageViewController: UIViewController {
    @IBOutlet weak var pictureImageView: UIImageView!
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func imageUploadButton(_ sender: UIButton) {
        guard let img = UIImage(named: "Van de ven") else { return }
        var data = Data()
        
        data = img.jpegData(compressionQuality: 0.8)! // 지정한 이미지를 포함하는 데이터 개체를 JPEG 형식으로 반환, 0.8은 데이터의 품질을 나타낸것 1에 가까울수록 품질이 높은 것
        let filePath = "Van de ven"
        let metaData = StorageMetadata() // Firebase 저장소에 있는 개체의 메타데이터를 나타내는 클래스, URL, 콘텐츠 유형 및 문제의 개체에 대한 FIRStorage 참조를 검색하는 데 사용
        metaData.contentType = "image/png" // 데이터 타입을 image or png
        
        storage.reference().child(filePath).putData(data, metadata: metaData) {
            (metaData,error) in if let error = error { // 실패
                print(error)
                
                return
            } else {
                print("성공")
            }
        }
    }
    
    @IBAction func imageDownloadButton(_ sender: UIButton) {
        storage.reference(forURL: "gs://fir-ex-41229.appspot.com/Van de ven .jpeg").downloadURL { url, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return }
            
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
