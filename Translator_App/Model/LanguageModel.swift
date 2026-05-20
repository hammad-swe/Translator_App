//
//  LanguageModel.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import Foundation


struct MyMemoryResponse: Decodable, Sendable {
    let responseData: MyMemoryTranslation
    let responseStatus: Int
    let responseDetails: String?
}

struct MyMemoryTranslation: Decodable , Sendable{
    let translatedText: String
}

struct Language: Codable , Sendable{
    let code: String
    let name: String
}

 struct FirstOrgResponse: Decodable, Sendable {
    let data: [String: String]
}


