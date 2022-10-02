import Foundation
import Combine
import IdentifiedCollections
import Models


public enum ClientError: Error, Equatable {
    case networkError
    case decodingError
}

public struct CommentsClient {
    public var fetch: (_ start: Int?, _ limit: Int) -> AnyPublisher<IdentifiedArrayOf<Comment>, ClientError>
}

public extension CommentsClient {
    static var live = Self(
        fetch: { start, limit in            
            URLSession.shared
                .dataTaskPublisher(
                    for: API.Comments.loadPage(start: start, limit: limit).createRequest()
                )
                .mapError { _ in ClientError.networkError }
                .tryMap {
                    try JSONDecoder().decode(IdentifiedArrayOf<Comment>.self, from: $0.data)
                }
                .mapError { _ in ClientError.decodingError }
                .eraseToAnyPublisher()
        }
    )
}

extension API.Comments: APIConfiguration {
    public var host: String { "jsonplaceholder.typicode.com" }
}

#if DEBUG
public extension CommentsClient {
    static var mock = Self(
        fetch: { _, _ in
            Just([])
                .setFailureType(to: ClientError.self)
                .eraseToAnyPublisher()
        }
    )
    
    static var failure = Self(
        fetch: { _, _ in
            Fail(error: .networkError)
                .eraseToAnyPublisher()
        }
    )
}
#endif
