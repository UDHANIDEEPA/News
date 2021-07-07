//
//  APIServices.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

import Foundation

class APIHandler :  NSObject {
    
    //private let sourcesURL = URL(string: "https://reqres.in/api/login")!
    
    static let shared = APIHandler()
    
    func authenticateUser(withUrl strUrl : String, completionBlock : @escaping () -> ()) {
        if let unwrappedUrl = URL(string: strUrl){
            URLSession.shared.dataTask(with: unwrappedUrl, completionHandler: { (data, response, error) in
                completionBlock()
            })
        }
    }
    
    func getNewsData(withUrl strUrl : String, searching: Bool, completionBlock : @escaping ([Any]) -> ()){
        
        guard let url = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError("fatal error")}
        if let unwrappedUrl = URL(string: url){
            
            URLSession.shared.dataTask(with: unwrappedUrl, completionHandler: { (data, response, error) in
                
                if data != nil{
                    
                    let string1 = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                    print(string1)
                    //                    let jsonDecoder = JSONDecoder()
                    let decoder = JSONDecoder()
                    do {
                        if(!searching) {
                            let decodedData = try decoder.decode(NewsDataModel.self, from: data!)
                            let newsArray = decodedData.results
                            completionBlock(newsArray)
                        }else {
                            let decodedData = try decoder.decode(SearchNewsDataModel.self, from: data!)
                            let newsArray = decodedData.response.docs
                            completionBlock(newsArray)
                        }
                        
                    } catch {
                        print(error)
                    }
                    //      
                }else{
                    let aArray = [News]()
                    completionBlock(aArray)
                }
                
            }).resume()
        }
    }
}
