import UIKit
import SnapKit

class ImagesPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    // MARK: -부모뷰에 삽입할 PageViewConroller 리스트
    
    var PageViewControllerList = [UIViewController]()
    var imagesInform: [ImageInform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        setupPageViewController()
    }
    
    // MARK: Pageview를 구성할 ViewController 생성
    func createPageViewController() {
        for inform in imagesInform {
            let vc: PageContentViewController = PageContentViewController(imageURL: inform.url, imageName: inform.imageName)
            PageViewControllerList.append(vc)
        }
    }
    
    // MARK: PageViewController 설정
    func setupPageViewController() {
        // MARK: PageViewController DataSource 연결
        self.dataSource = self
        
        //첫번째로 위치할 ViewController 배치
        if let firstviewController = PageViewControllerList.first {
            setViewControllers([firstviewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    // MARK: - 😀 Place for UIPageViewControllerDataSource
    // MARK: 이전페이지에 위치할 ViewController return
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = PageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return PageViewControllerList.last }
        guard PageViewControllerList.count > previousIndex else { return nil }
        
        return PageViewControllerList[previousIndex]
    }
    
    // MARK: 다음페이지에 위치할 ViewController return
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = PageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard PageViewControllerList.count != nextIndex else { return PageViewControllerList.first }
        guard PageViewControllerList.count > nextIndex else { return nil }
        
        return PageViewControllerList[nextIndex]
    }
}
