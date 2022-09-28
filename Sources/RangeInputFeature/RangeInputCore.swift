import ComposableArchitecture

// MARK: - State

public struct RangeInputState: Equatable {

    public init(
    )
    {
    }
}

// MARK: Actions
public enum RangeInputAction: Equatable {
    case placeholder
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
		case .placeholder:
		    return .none
        }
    }
)
