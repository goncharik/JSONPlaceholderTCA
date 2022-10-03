import CommentRowFeature
import ComposableArchitecture
import Models


// MARK: State
public struct CommentsListState: Equatable {

    var lowerBound: Int = 0
    var upperBound: Int? = nil
    var items: IdentifiedArrayOf<Comment>
    var canLoadNextPage: Bool
    
    public init(
        lowerBound: Int,
        upperBound: Int?,
        items: IdentifiedArrayOf<Comment>
    )
    {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.items = items
        
        if let upperBound {
            canLoadNextPage = items.count < upperBound - lowerBound
        } else {
            canLoadNextPage = true
        }
    }
}

// MARK: Actions
public enum CommentsListAction: Equatable {
    case row(id: Comment.ID, action: CommentRowAction)
}

// MARK: Environment
public struct CommentsListEnvironment {
    public init() {}
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
		case .row:
		    return .none
        }
    }
)
