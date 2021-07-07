//
//  SearchNewsModel.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/7/21.
//


import Foundation

// MARK: - SearchNewsDataModel
struct SearchNewsDataModel: Codable {
    let response: ResponseData
}

// MARK: - Response
struct ResponseData: Codable {
    let docs: [SearchNews]
}

// MARK: - Doc
struct SearchNews: Codable {
    let abstract: String
    let multimedia: [MultimediaData]?
    let headline: Headline
}

// MARK: - Multimedia
struct MultimediaData: Codable {
    let url: String
}


// MARK: - Headline
struct Headline: Codable {
    let main: String
    let printHeadline: String?

    enum CodingKeys: String, CodingKey {
        case main
        case printHeadline = "print_headline"
    }
}


