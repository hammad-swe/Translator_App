//
//  LanguageService.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import Foundation

class LanguageService{
    
//    static let shared = LanguageService()
//        private let apiKey = "YOUR_GOOGLE_API_KEY"


        // MARK: - Fetch Languages
        func fetchLanguages(completion: @escaping (Result<[Language], Error>) -> Void) {
            guard let url = URL(string: "\(Constants.baseURL)/languages") else { return }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error)); return
                }
                guard let data = data else { return }
                do {
                    let languages = try JSONDecoder().decode([Language].self, from: data)
                    completion(.success(languages))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }

        // MARK: - Translate Text
        func translate(text: String, from source: String, to target: String,
                       completion: @escaping (Result<String, Error>) -> Void) {

            guard let url = URL(string: "\(Constants.baseURL)/translate") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")

            let body: [String: Any] = [
                "q": text,
                "source": source,
                "target": target,
                "format": "text"
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error)); return
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let translated = json["translatedText"] as? String else { return }
                completion(.success(translated))
            }.resume()
        }
    }


