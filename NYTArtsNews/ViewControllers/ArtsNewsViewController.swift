//
//  ViewController.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

import UIKit

class ArtsNewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var carouselView: UICollectionView!
    @IBOutlet weak var carouselPageControl: UIPageControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var carouselTimer : Timer?
    var carouselCurrentIndex: Int = 0
    var newsViewModel = NewsViewModel()
    
    var isSearching = false
    //MARK : View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.startActivityIndicator()
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        self.searchBar.delegate = self
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        newsTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        newsViewModel.fetchNewsData(newsType: "arts", completionBlock: { (_) in
            
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                
                self?.newsTableView.reloadData()
                
                self?.carouselView.delegate = self
                self?.carouselView.dataSource = self
                self?.carouselView.prefetchDataSource = self
                
                self?.configureCarousel()
                self?.configureCarouselPageControl()
                self?.carouselView.reloadData()
                
                self?.carouselTimer =  Timer.scheduledTimer(timeInterval: 3.0, target: self as Any, selector: #selector(self?.carouselTimerNextImage), userInfo: nil, repeats: true)
            }
        })
    }
    
    deinit {
        self.carouselTimer?.invalidate()
        self.carouselTimer = nil
    }
    
    //MARK : Carousel and Page Control configurations
    
    fileprivate func configureCarousel() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        carouselView.collectionViewLayout = flowLayout
        carouselView.showsHorizontalScrollIndicator = false
        carouselView.showsVerticalScrollIndicator = false
        carouselView.isPagingEnabled = true
        carouselView.allowsMultipleSelection = false
        
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.prefetchDataSource = self
        carouselView.isPrefetchingEnabled = true
        
        carouselView.register(UINib(nibName: K.carouselNibName, bundle: nil), forCellWithReuseIdentifier: K.carouselCellIdentifier)
    }
    
    fileprivate func configureCarouselPageControl() {
        carouselPageControl.numberOfPages = newsViewModel.getNumberOfItemsInCarousel()
        carouselPageControl.currentPage = 0
    }
    
    //MARK: Other functions
    
    func startActivityIndicator(){
        self.activityIndicator.isHidden = false
        self.view.bringSubviewToFront(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
}

//MARK: Searchbardelegate methods
extension ArtsNewsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        self.startActivityIndicator()
        if(self.searchBar.text?.isEmpty == true && self.isSearching == true){
            self.fetchNewsData()
        } else {
            newsViewModel.fetchSearchNewsData (keyword : searchBar.text ?? "", newsType: "arts", completionBlock: { (_) in
                DispatchQueue.main.async { [weak self] in
                    self?.isSearching = true
                    self?.newsTableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    
                }
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.searchBar.text?.isEmpty == true){
            if(isSearching == true){
                self.searchBar.endEditing(true)
                self.fetchNewsData()
            }else {
                self.searchBar.endEditing(true)
            }
            
        }
    }
    
    func fetchNewsData() {
        self.startActivityIndicator()
        newsViewModel.fetchNewsData(newsType: "arts", completionBlock: { (_) in
            DispatchQueue.main.async { [weak self] in
                self?.isSearching = false
                self?.newsTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        })
    }
    
}
// MARK :- Extension for collection view

extension ArtsNewsViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        for currenCell : UICollectionViewCell in carouselView.visibleCells {
            let currentCellIndexPath = carouselView.indexPath(for: currenCell)
            if(currentCellIndexPath != indexPath) {
                carouselPageControl.currentPage = currentCellIndexPath?.row ?? 0
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsViewModel.getNumberOfItemsInCarousel()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CarouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.carouselCellIdentifier, for: indexPath) as! CarouselCell
        cell.model = newsViewModel.getCarouselElementAtIndex(index: indexPath.row)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            var model = newsViewModel.getCarouselElementAtIndex(index: indexPath.row)
            if(model.image == nil) {
                ImageDownloader.downloadImage(imageUrl: model.imageUrl) { (imageDownloaded) in
                    model.image = imageDownloaded
                }
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    
    // MARK: Timer Functions
    
    @objc fileprivate func carouselTimerNextImage() {
        var newIndex = carouselPageControl.currentPage + 1
        if(newIndex >= newsViewModel.getNumberOfItemsInCarousel()) {
            newIndex = 0
        }
        carouselView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
        //carouselPageControl.currentPage = newIndex
    }
    
}
// MARK :- Extension for TableView

extension ArtsNewsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsData : (title: String, description: String, imageUrl: String?) = newsViewModel.getNewsCellData(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! NewsArticleTableViewCell
        cell.titleLabel.text = newsData.title
        cell.abstractLabel.text = newsData.description
        cell.articleImageView.downloadFrom(link: newsData.imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
        return cell
        
    }
    
}

