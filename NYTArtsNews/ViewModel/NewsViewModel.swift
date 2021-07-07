//
//  NewsViewModel.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

import Foundation

class NewsViewModel {
    
    typealias completionBlock = ([Any]) -> ()
    
    var apiHandler = APIHandler.shared
    var datasourceArray = [Any]()
    var carouselImageArray = [CarouselElement]()
    var isSearch = false
    
    func fetchNewsData(newsType: String, completionBlock : @escaping completionBlock) {
        isSearch = false
        
        let urlString = "\(K.EndPoint.strNewsUrl)&api-key=\(K.newsAPIKey)"
        apiHandler.getNewsData(withUrl: urlString, searching: false) { [weak self] (arrNews) in
            self?.datasourceArray = arrNews
            if(self?.carouselImageArray.count == 0){
                self?.getCarouselElementList()
            }
            completionBlock(arrNews)
        }
    }
    
    func fetchSearchNewsData(keyword : String, newsType: String, completionBlock : @escaping completionBlock) {
        isSearch = true
        //    https://api.nytimes.com/svc/search/v2/articlesearch.json?q=%27wall%27&fq=section_name:(%22arts%22)&api-key=XjvMKnWqQSrFsIaUIAPl75lAP2Zsli6u#
        let urlString = "\(K.EndPoint.strSearchNewsUrl)&q=\(keyword)&fq=\(newsType)&api-key=\(K.newsAPIKey)"
        apiHandler.getNewsData(withUrl: urlString, searching: true) { [weak self] (arrNews) in
            self?.datasourceArray = arrNews
            completionBlock(arrNews)
        }
    }
    
    func getNumberOfRowsInSection() -> Int{
        
        return datasourceArray.count
    }
    
    func getNewsAtIndex(index : Int) -> Any{
        
        let news = datasourceArray[index]
        return news
    }
    
    func getNewsCellData(index : Int) -> (String, String, String?){
        
        let news = self.getNewsAtIndex(index: index)
        if isSearch == false {
            if let unWrappedNews = news as? News {
                let title = unWrappedNews.title
                let description = unWrappedNews.abstract
                let imageUrl = unWrappedNews.multimedia?[0].url
                return (title,description,imageUrl)
            }
            return ("","",nil)
        }
        else {
            if let unWrappedNews = news as? SearchNews {
                let title = unWrappedNews.headline.printHeadline ?? unWrappedNews.headline.main
                let description = unWrappedNews.abstract
                let imageUrl : String? = nil
                
                //                if let multimediaValue = unWrappedNews.multimedia {
                //                    if(multimediaValue.count > 0) {
                //                        imageUrl = unWrappedNews.multimedia?[0].url
                //                    }
                //                }
                
                return (title,description,imageUrl)
            }
            return ("","",nil)
        }
        
    }
    
    func getCarouselElementList() {
        for article in datasourceArray{
            if let multimedia = (article as! News).multimedia {
                if multimedia.count > 0 {
                    self.carouselImageArray.append( CarouselElement.init(imageUrl: multimedia[0].url))
                }
            }
        }
    }
    
    func getCarouselElementAtIndex(index : Int) -> CarouselElement {
        return carouselImageArray[index]
    }
    
    func getNumberOfItemsInCarousel() -> Int {
        return carouselImageArray.count
    }
    
}
