import SwiftUI
import ComposableArchitecture

public struct RangeInputView: View {

    let store: Store<RangeInputState, RangeInputAction>

    public init(store: Store<RangeInputState, RangeInputAction>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Text("RangeInputView")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

struct RangeInputView_Previews: PreviewProvider {
    static var previews: some View {
        RangeInputView(store: Store<RangeInputState, RangeInputAction>(
            initialState: RangeInputState(),
            reducer: rangeInputReducer,
            environment: RangeInputEnvironment()
            )
        )
    }
}
