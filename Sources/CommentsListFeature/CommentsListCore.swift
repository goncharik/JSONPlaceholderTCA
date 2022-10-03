import CommentRowFeature
import CommentsClient
import ComposableArchitecture
import Foundation
import Models


// MARK: State
public struct CommentsListState: Equatable {

    var lowerBound: Int
    var upperBound: Int?
    var limit: Int
    var items: IdentifiedArrayOf<Comment>
    var canLoadNextPage: Bool
    var isLoading: Bool = false
    
    public init(
        lowerBound: Int,
        upperBound: Int?,
        limit: Int,
        items: IdentifiedArrayOf<Comment>
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.limit = limit
        self.items = items
        
        if let upperBound {
            canLoadNextPage = items.count < upperBound - lowerBound
        } else {
            canLoadNextPage = true
        }
    }
    
    func isLastItem(_ itemId: Comment.ID) -> Bool {
        let itemIndex = items.index(id: itemId)
        return itemIndex == items.endIndex - 1
    }
}

// MARK: Actions
public enum CommentsListAction: Equatable {
    case row(id: Comment.ID, action: CommentRowAction)
    
    case loadNextPageIfNeeded(itemId: Int)
    case didLoadComments(Result<IdentifiedArrayOf<Comment>, ClientError>)
}

// MARK: Environment
public struct CommentsListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var commentsClient: CommentsClient
    
    public init(commentsClient: CommentsClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.commentsClient = commentsClient
        self.mainQueue = mainQueue
    }
}

// MARK: Reducer
public let commentsListReducer =
Reducer<CommentsListState, CommentsListAction, CommentsListEnvironment>.combine(
    commentRowReducer.forEach(
        state: \.items,
        action: /CommentsListAction.row(id:action:),
        environment: { _ in CommentRowEnvironment() }
      ),
    Reducer<CommentsListState, CommentsListAction, CommentsListEnvironment> {
        state, action, environment in
        switch action {
        case .row(id: let id, action: .appeared):
            return .init(value: .loadNextPageIfNeeded(itemId: id))
        case .loadNextPageIfNeeded(itemId: let itemId):
            guard state.isLastItem(itemId), !state.isLoading, state.canLoadNextPage else { return .none }
            let start = state.lowerBound + state.items.count
            var limit = state.limit
            if let upperBound = state.upperBound {
                guard start <= upperBound else {
                    return .none
                }
                limit = min((upperBound + 1) - start, limit)
            }
            state.isLoading = true
            return environment.commentsClient.fetch(start, limit)
                .delay(for: .seconds(2), scheduler: environment.mainQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(CommentsListAction.didLoadComments)            
        case .didLoadComments(.success(let comments)):
            state.isLoading = false
            state.items.append(contentsOf: comments)
            state.canLoadNextPage = !comments.isEmpty
            return .none
        case .didLoadComments(.failure(let error)):
            state.isLoading = false
            print(error) // show some error message
            return .none
        }
    }
)
