import Foundation
import Combine
import Models

public enum ClientError: Error, Equatable {
    case networkError
    case decodingError
}

public struct CommentsClient {
    public var fetch: (_ start: Int?, _ limit: Int) -> AnyPublisher<[Comment], ClientError>
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
