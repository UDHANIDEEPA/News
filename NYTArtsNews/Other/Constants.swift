//
//  Constants.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

struct K {
    static let appName = "Arts News"
    static let cellIdentifier = "NewsArticleTableViewCell"
    static let cellNibName = "NewsArticleTableViewCell"
    static let loginSegue = "LoginToNews"
    static let newsAPIKey = "XjvMKnWqQSrFsIaUIAPl75lAP2Zsli6u"
    static let carouselCellIdentifier = "carouselCellId"
    static let carouselNibName = "CarouselCell"
    
    struct EndPoint {
        static let strSearchNewsUrl = "https://api.nytimes.com/svc/search/v2/articlesearch.json?"
        static let strNewsUrl = "https://api.nytimes.com/svc/topstories/v2/arts.json?"
        static let strLoginUrl = "https://reqres.in/api/login"
    }
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    struct ErrorMsg {
        static let errorPasswordMsg = "Your password field is empty"
        static let errorEmailMsg = "Your email id field is empty"
    }
    
}
