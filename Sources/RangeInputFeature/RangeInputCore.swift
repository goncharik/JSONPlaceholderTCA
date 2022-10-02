import CommentsClient
import CommentsListFeature
import ComposableArchitecture
import Foundation
import IdentifiedCollections
import Models

// MARK: - State

public struct RangeInputState: Equatable {
    var lowerBound: Int?
    var upperBound: Int?
    
    var isLoading: Bool = false
    var alert: AlertState<RangeInputAction>?
    
    var commentsListState: CommentsListState?

    public init() {}
}

// MARK: Actions
public enum RangeInputAction: Equatable {
    case updateLowerBound(String)
    case updateUpperBound(String)
    case goButtonTapped
    case cancelButtonTapped
    case validationMessageDismissed
    
    case didLoadComments(Result<IdentifiedArrayOf<Comment>, ClientError>)
    
    case commentsListDismissed
    case commentsList(CommentsListAction)
}

// MARK: - Environment

public struct RangeInputEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var commentsClient: CommentsClient
    
    public init(commentsClient: CommentsClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.commentsClient = commentsClient
        self.mainQueue = mainQueue
    }
}

// MARK: - Reducer

public let rangeInputReducer =
Reducer<RangeInputState, RangeInputAction, RangeInputEnvironment>.combine(
    Reducer<RangeInputState, RangeInputAction, RangeInputEnvironment> { state, action, environment in
        enum CancelID {}
        
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
            state.isLoading = true
            
            var limit = 10
            if let upperBound = state.upperBound {
                limit = min(10, upperBound - (state.lowerBound ?? 0))
            }
            
            #warning("Replace with 3 in production")
            let waitSeconds = 1
            
            return Effect.task {
                try await environment.mainQueue.sleep(for: .seconds(waitSeconds))
                return ()
            }
            .combineLatest(environment.commentsClient.fetch(state.lowerBound, limit).catchToEffect())
            .eraseToEffect()
            .map { $0.1 }
            .map(RangeInputAction.didLoadComments)
            .cancellable(id: CancelID.self)
                
        case .cancelButtonTapped:
            state.isLoading = false
            return .cancel(id: CancelID.self)
        case .validationMessageDismissed:
            state.alert = nil
            return .none
        case .didLoadComments(.success(let comments)):
            state.isLoading = false
            state.commentsListState = .init(lowerBound: state.lowerBound ?? 0, upperBound: state.upperBound, items: comments)
            return .none
        case .commentsListDismissed:
            state.commentsListState = nil
            return .none
        case .didLoadComments(.failure):
            state.isLoading = false
            state.alert = AlertState(
                title: .init("Loading Error"),
                message: .init("Something went wrong. Please try again"),
                dismissButton: .cancel(.init("OK"))
            )
            return .none
        case .commentsList:
            return .none
        }
    }
).debug()
