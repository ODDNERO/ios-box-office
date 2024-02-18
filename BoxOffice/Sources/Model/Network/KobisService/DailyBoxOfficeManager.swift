//
//  URLSession.swift
//  BoxOffice
//
//  Created by Roh on 2/16/24.
//

import Foundation

struct DailyBoxOfficeManager {
    var urlRequest: URLRequest?
    var urlString: String
    var keyValue: String
    private var targetDtValue: String
    
    init(urlString: String, keyValue: String, targetDtValue: String) {
        self.urlString = urlString
        self.keyValue = keyValue
        self.targetDtValue = targetDtValue
    }
}

extension DailyBoxOfficeManager: kobisService {
    func request() -> URLRequest? {
        guard let url = setURL() else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    func response(request: URLRequest, completionHandler: @escaping (Result<Any, Error>) -> ()) {
        let session: URLSession = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let successRange: Range = (200..<300)
            guard let data: Data = data,
                    error == nil
            else {
                completionHandler(.failure(NetworkError.invalidURL))
                return
            }
            
            if let response: HTTPURLResponse = response as? HTTPURLResponse {
                if successRange.contains(response.statusCode) {
                    guard let userInfo: DailyBoxOfficeDTO = try? JSONDecoder().decode(DailyBoxOfficeDTO.self, from: data) else {
                        completionHandler(.failure(NetworkError.decodingError))
                        return
                    }
                    completionHandler(.success(userInfo))
                } else {
                    completionHandler(.failure(NetworkError.serverError(code: response.statusCode)))
                }
            }
        }.resume()
    }
    
    func setURL() -> URL? {
        guard var urlComponents: URLComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: keyValue),
            URLQueryItem(name: "targetDt", value: targetDtValue)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        return url
    }
}