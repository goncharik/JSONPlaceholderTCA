import ComposableArchitecture

// MARK: - State

public struct RangeInputState: Equatable {
    var lowerBound: Int?
    var upperBound: Int?
    
    var isLoading: Bool = false
    var validationAlert: AlertState<RangeInputAction>?

    public init() {}
}

// MARK: Actions
public enum RangeInputAction: Equatable {
    case updateLowerBound(String)
    case updateUpperBound(String)
    case goButtonTapped
    case validationMessageDismissed
}

// MARK: - Environment

public struct RangeInputEnvironment {
    public init() {}
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
                state.validationAlert = AlertState(
                    title: .init("Validation Error"),
                    message: .init("Lower bound should be lower than upper bound."),
                    dismissButton: .cancel(.init("OK"))
                )
                return .none
                
            }
            //TODO: fetch regular request
            return .none
        case .validationMessageDismissed:
            state.validationAlert = nil
            return .none
        }
    }
)
