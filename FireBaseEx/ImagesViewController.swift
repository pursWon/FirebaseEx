import UIKit
import FirebaseStorage
import Kingfisher

class ImagesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let storage = Storage.storage()
    var imagesInform: [ImageInform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func moveButtonClicked(_ sender: UIButton) {
        guard let imagesPageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagesPageViewController") as? ImagesPageViewController else { return }
        imagesPageVC.imagesInform = imagesInform
        
        navigationController?.pushViewController(imagesPageVC, animated: true)
    }
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesInform.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as?
                ImagesCell else { return UICollectionViewCell() }
        
        cell.myImageView.kf.setImage(with: imagesInform[indexPath.row].url)
        cell.nameLabel.text = imagesInform[indexPath.row].imageName
        cell.myImageView.contentMode = .scaleAspectFill
        cell.myImageView.clipsToBounds = true
        cell.nameLabel.textAlignment = .center
        cell.nameLabel.backgroundColor = .systemGray5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let lineCount: CGFloat = 2
        let interSpacing: CGFloat = 30
        let totalWidth = width - (interSpacing * (lineCount - 1))
        let itemSize: CGFloat = totalWidth / lineCount
        
        return CGSize(width: itemSize, height: itemSize)
    }
}
