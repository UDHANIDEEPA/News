//
//  LoginViewModel.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

import Foundation

class LoginViewModel : NSObject {
    typealias completionBlock = () -> ()
    
    var apiHandler = APIHandler.shared
    
    func authenticateUser(completionBlock : @escaping completionBlock) {
        apiHandler.authenticateUser(withUrl: K.EndPoint.strLoginUrl, completionBlock: { () in
            completionBlock()
        })
    }
}
