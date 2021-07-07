// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - NewsDataModel
struct NewsDataModel: Codable {
    let results: [News]
}

// MARK: - Result
struct News: Codable {
    let section, subsection, title, abstract: String
    let multimedia: [Multimedia]?
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let url: String
}


