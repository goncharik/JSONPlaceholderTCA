import ComposableArchitecture

// MARK: State
public struct CommentsListState: Equatable {

    public init(
    )
    {
    }
}

// MARK: Actions
public enum CommentsListAction: Equatable {
    case placeholder
}

// MARK: Environment
public struct CommentsListEnvironment {
    public init() {}
}

// MARK: Reducer
public let commentsListReducer =
Reducer<CommentsListState, CommentsListAction, CommentsListEnvironment>.combine(
    Reducer<CommentsListState, CommentsListAction, CommentsListEnvironment> {
        state, action, environment in
        switch action {
		case .placeholder:
		    return .none
        }
    }
)
