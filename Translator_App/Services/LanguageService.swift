//
//  LanguageService.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import Foundation

class LanguageService{
    
    // MARK: - Shared Request Builder (GET only, no auth needed)
        private func makeRequest(url: URL) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }
    
    
    func fetchLanguages(completion: @escaping (Result<[Language], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.first.org/data/v1/languages") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            
            print("Languages raw:", String(data: data, encoding: .utf8) ?? "")
            
            do {
                // Response: { "data": { "en": "English", "ur": "Urdu", ... } }
                let raw = try JSONDecoder().decode(FirstOrgResponse.self, from: data)
                
                let languages = raw.data
                    .map { Language(code: $0.key, name: $0.value) }
                    .sorted { $0.name < $1.name } // alphabetical order
                
                completion(.success(languages))
                
            } catch {
                print("❌ Language decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    
//    // MARK: - Fetch Languages (static list, MyMemory has no language endpoint)
//        func fetchLanguages(completion: @escaping (Result<[Language], Error>) -> Void) {
//            let languages: [Language] = [
//                Language(code: "en", name: "English"),
//                Language(code: "ur", name: "Urdu"),
//                Language(code: "ar", name: "Arabic"),
//                Language(code: "fr", name: "French"),
//                Language(code: "de", name: "German"),
//                Language(code: "es", name: "Spanish"),
//                Language(code: "zh", name: "Chinese"),
//                Language(code: "hi", name: "Hindi"),
//                Language(code: "tr", name: "Turkish"),
//                Language(code: "ru", name: "Russian")
//            ]
//            completion(.success(languages))
//        }

       
    // MARK: - Translate Text
    func translate(text: String, from source: String, to target: String,
                   completion: @escaping (Result<String, Error>) -> Void) {

        // ✅ Use URLComponents instead of manual string building
        var components = URLComponents(string: "\(Constants.baseURL)/get")!
        components.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(source)|\(target)")
        ]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "LanguageService", code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let request = makeRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }

            if let data = data {
                print("MyMemory raw response:", String(data: data, encoding: .utf8) ?? "")
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(MyMemoryResponse.self, from: data)

                guard result.responseStatus == 200 else {
                    completion(.failure(NSError(domain: "LanguageService", code: result.responseStatus,
                        userInfo: [NSLocalizedDescriptionKey: result.responseDetails ?? "Translation failed"])))
                    return
                }

                // ✅ Decode any leftover percent-encoding in the response
                let translated = result.responseData.translatedText
                    .removingPercentEncoding ?? result.responseData.translatedText

                completion(.success(translated))

            } catch {
                print("❌ Decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }
               
        }


