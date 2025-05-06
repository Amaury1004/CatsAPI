import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let baseURL = "https://api.thecatapi.com"
    private let ver = "/v1"
    private let apiKey = "live_PvwxovYWKoNyZcHanV1SOHNtRH6gqIMVOzY2Gwv8JNueEkAI8yn700O9TxTc9fOU"
    private let has_breads = "has_breeds"
    enum NetworkRequest: String {
        case none = ""
        case search = "images/search"
    }
    
    enum TypeRequest: Int {
        case noneBreads = 0
        case hasBreads = 1
    }
    
    func request<T: Decodable>(_ url: NetworkRequest,
                               parameters: [String: String]? = nil,
                               typeRequest: TypeRequest? = .noneBreads,
                               completion: @escaping (Result<T, Error>) -> Void) {
        let baseUrl = self.requestUrl(url)
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            return
        }
        
        components.queryItems = parameters?.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) } ?? []

        if typeRequest == .hasBreads {
            queryItems.append(URLQueryItem(name: "has_breeds", value: "1"))
            }
        components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))

        guard let url = components.url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let statusError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected HTTP status code: \(httpResponse.statusCode)"])
                completion(.failure(statusError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func requestUrl(_ url: NetworkRequest) -> URL {
        URL(string: "\(baseURL)\(ver)/\(url.rawValue)")!
    }
}
