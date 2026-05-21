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
        
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=languages") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            
            do {
                // ✅ Response is an ARRAY: [ {"languages": {"en":"English"}}, ... ]
                let countries = try JSONDecoder().decode([CountryLanguages].self, from: data)
                
                var seen = Set<String>()
                var languages: [Language] = []
                
                for country in countries {
                    guard let langs = country.languages else { continue }
                    for (code, name) in langs {
                        guard !seen.contains(code) else { continue }
                        seen.insert(code)
                        languages.append(Language(code: code, name: name))
                    }
                }
                
                completion(.success(languages.sorted { $0.name < $1.name }))
                
            } catch {
                print("❌ Language decode error:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    //
    
    func translate(text: String, from source: String, to target: String,
                   completion: @escaping (Result<String, Error>) -> Void) {
        
        // ✅ Split into sentences if text is long
        let chunks = splitIntoChunks(text, maxLength: 300)
        
        guard chunks.count > 1 else {
            // Short text — translate directly
            performTranslation(text: text, from: source, to: target, completion: completion)
            return
        }
        
        // Translate each chunk and join results
        var results = [String](repeating: "", count: chunks.count)
        let group = DispatchGroup()
        var failed: Error?
        
        for (index, chunk) in chunks.enumerated() {
            group.enter()
            performTranslation(text: chunk, from: source, to: target) { result in
                switch result {
                case .success(let translated):
                    results[index] = translated
                case .failure(let error):
                    failed = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = failed {
                completion(.failure(error))
            } else {
                completion(.success(results.joined(separator: " ")))
            }
        }
    }
    
    // MARK: - Split text into chunks by sentence
    private func splitIntoChunks(_ text: String, maxLength: Int) -> [String] {
        guard text.count > maxLength else { return [text] }
        
        var chunks: [String] = []
        var current = ""
        
        // Split by sentence endings
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?\n"))
        
        for sentence in sentences {
            let trimmed = sentence.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }
            
            if current.count + trimmed.count + 1 <= maxLength {
                current += (current.isEmpty ? "" : ". ") + trimmed
            } else {
                if !current.isEmpty { chunks.append(current) }
                current = trimmed
            }
        }
        
        if !current.isEmpty { chunks.append(current) }
        return chunks
    }
    
    // MARK: - Single chunk translation (your existing logic)
    private func performTranslation(text: String, from source: String, to target: String,
                                    completion: @escaping (Result<String, Error>) -> Void) {
        
        let cleanedText = text
                .replacingOccurrences(of: "\n", with: " ")
                .replacingOccurrences(of: "\r", with: " ")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        
        var components = URLComponents(string: "\(Constants.baseURL)/get")!
        components.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(source)|\(target)"),
            URLQueryItem(name: "de", value: "youremail@gmail.com") // ✅ better quality + 50k/day
        ]
        
        guard let url = components.url else { return }
        
        URLSession.shared.dataTask(with: makeRequest(url: url)) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
                
                guard result.responseStatus == 200 else {
                    completion(.failure(NSError(
                        domain: "LanguageService",
                        code: result.responseStatus,
                        userInfo: [NSLocalizedDescriptionKey: result.responseDetails ?? "Translation failed"]
                    )))
                    return
                }
                
                let translated = result.responseData.translatedText
                    .removingPercentEncoding ?? result.responseData.translatedText
                
                completion(.success(translated))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
    
    
    //    // MARK: - Translate Text
    //    func translate(text: String, from source: String, to target: String,
    //                   completion: @escaping (Result<String, Error>) -> Void) {
    //
    //        // ✅ Use URLComponents instead of manual string building
    //        var components = URLComponents(string: "\(Constants.baseURL)/get")!
    //        components.queryItems = [
    //            URLQueryItem(name: "q", value: text),
    //            URLQueryItem(name: "langpair", value: "\(source)|\(target)")
    //        ]
    //
    //        guard let url = components.url else {
    //            completion(.failure(NSError(domain: "LanguageService", code: 0,
    //                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
    //            return
    //        }
    //
    //        let request = makeRequest(url: url)
    //
    //        URLSession.shared.dataTask(with: request) { data, _, error in
    //            if let error = error { completion(.failure(error)); return }
    //
    //            if let data = data {
    //                print("MyMemory raw response:", String(data: data, encoding: .utf8) ?? "")
    //            }
    //
    //            guard let data = data else { return }
    //
    //            do {
    //                let result = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
    //
    //                guard result.responseStatus == 200 else {
    //                    completion(.failure(NSError(domain: "LanguageService", code: result.responseStatus,
    //                        userInfo: [NSLocalizedDescriptionKey: result.responseDetails ?? "Translation failed"])))
    //                    return
    //                }
    //
    //                // ✅ Decode any leftover percent-encoding in the response
    //                let translated = result.responseData.translatedText
    //                    .removingPercentEncoding ?? result.responseData.translatedText
    //
    //                completion(.success(translated))
    //
    //            } catch {
    //                print("❌ Decode error:", error)
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
    //
    //        }
    //
    //

