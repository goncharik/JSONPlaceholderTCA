import Foundation

public enum API {}

public protocol APIConfiguration {
    var host: String { get }
}

public protocol APIRequest {
    func createRequest() -> URLRequest
}

public extension APIRequest {
    func getRequest(path: String, queryItems: [URLQueryItem]? = nil) -> URLRequest {
        guard let host = (self as? APIConfiguration)?.host else {
            fatalError("\(String(describing: self)) is not configured!")
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return request
    }
}

extension API {
    public enum Comments: APIRequest {
        case loadPage(start: Int?, limit: Int)
        
        public func createRequest() -> URLRequest {
            switch self {                
            case .loadPage(start: let start, limit: let limit):
                let path = "/comments"
                let queryItems: [URLQueryItem] = [
                    start != nil ? .init(name: "_start", value: "\(start!)") : nil,
                      .init(name: "_limit", value: "\(limit)")
                ].compactMap { $0 }
                return getRequest(path: path, queryItems: queryItems)
            }
        }
    }
}
