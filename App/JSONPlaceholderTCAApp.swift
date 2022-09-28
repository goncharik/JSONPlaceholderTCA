import ComposableArchitecture
import RangeInputFeature
import SwiftUI

@main
struct JSONPlaceholderTCAApp: App {
    var body: some Scene {
        WindowGroup {
            RangeInputView(
                store: Store<RangeInputState, RangeInputAction>(
                    initialState: RangeInputState(),
                    reducer: rangeInputReducer,
                    environment: RangeInputEnvironment()
                )
            )
        }
    }
}
