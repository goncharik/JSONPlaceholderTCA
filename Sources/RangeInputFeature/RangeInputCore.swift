import CommentsClient
import ComposableArchitecture
import Models

// MARK: - State

public struct RangeInputState: Equatable {
    var lowerBound: Int?
    var upperBound: Int?
    
    var isLoading: Bool = false
    var alert: AlertState<RangeInputAction>?

    public init() {}
}

// MARK: Actions
public enum RangeInputAction: Equatable {
    case updateLowerBound(String)
    case updateUpperBound(String)
    case goButtonTapped
    case validationMessageDismissed
    
    case didLoadComments(Result<[Comment], ClientError>)
}

// MARK: - Environment

public struct RangeInputEnvironment {
    var commentsClient: CommentsClient
    
    public init(commentsClient: CommentsClient) {
        self.commentsClient = commentsClient
    }
}

// MARK: - Reducer

public let rangeInputReducer =
Reducer<RangeInputState, RangeInputAction, RangeInputEnvironment>.combine(
    Reducer<RangeInputState, RangeInputAction, RangeInputEnvironment> {
        state, action, environment in
        switch action {
        case .updateLowerBound(let bound):
            state.lowerBound = Int(bound)
            return .none
        case .updateUpperBound(let bound):
            state.upperBound = Int(bound)
            return .none
        case .goButtonTapped:
            if let lowerBound = state.lowerBound, let upperBound = state.upperBound, lowerBound >= upperBound {
                state.alert = AlertState(
                    title: .init("Validation Error"),
                    message: .init("Lower bound should be lower than upper bound."),
                    dismissButton: .cancel(.init("OK"))
                )
                return .none
                
            }
            //TODO: fetch regular request
            let limit = 10
            
            return environment.commentsClient.fetch(state.lowerBound, limit)
                .catchToEffect()
                .map(RangeInputAction.didLoadComments)                
        case .validationMessageDismissed:
            state.alert = nil
            return .none
        case .didLoadComments(.success(let comments)):
            state.isLoading = false
            return .none
        case .didLoadComments(.failure):
            state.isLoading = false
            state.alert = AlertState(
                title: .init("Loading Error"),
                message: .init("Something went wrong. Please try again"),
                dismissButton: .cancel(.init("OK"))
            )
            return .none
        }
    }
).debug()
