import ComposableArchitecture

// MARK: - State

public struct RangeInputState: Equatable {
    var lowerBound: Int = 0
    var upperBound: Int = 0
    var isLoading: Bool = false

    public init(
    ) {
    }
}

// MARK: Actions
public enum RangeInputAction: Equatable {
    case updateLowerBound(String)
    case updateUpperBound(String)
    case goButtonTapped
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
        case .updateLowerBound(_):
            return .none
        case .updateUpperBound(_):
            return .none
        case .goButtonTapped:
            return .none
        }
    }
)
