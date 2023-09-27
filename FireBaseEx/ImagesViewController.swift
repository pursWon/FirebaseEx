import UIKit
import FirebaseStorage
import Kingfisher

class ImagesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let storage = Storage.storage()
    var imageURLs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as?
                ImagesCell else { return UICollectionViewCell() }
        
        cell.myImageView.kf.setImage(with: imageURLs[indexPath.row])
        cell.myImageView.contentMode = .scaleAspectFill
        cell.myImageView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let lineCount: CGFloat = 2
        let interSpacing: CGFloat = 40
        let totalWidth = width - (interSpacing * (lineCount - 1))
        let itemSize: CGFloat = totalWidth / lineCount
        
        return CGSize(width: itemSize, height: itemSize)
    }
}


