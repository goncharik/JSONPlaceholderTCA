import SwiftUI
import ComposableArchitecture

public struct RangeInputView: View {

    let store: Store<RangeInputState, RangeInputAction>
    @ObservedObject var viewStore: ViewStore<RangeInputState, RangeInputAction>

    public init(store: Store<RangeInputState, RangeInputAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    public var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("Enter Comments Range")
                    .font(.title)
                    .padding(.vertical, 24)
                VStack(alignment: .leading) {
                    Text("Lower Bound")
                    TextField(
                        "no bound",
                        text: Binding(get: { viewStore.lowerBound != nil ? "\(viewStore.lowerBound!)" : "" }, set: { viewStore.send(.updateLowerBound($0)) } )
                    )
                    .font(.title)
                    .keyboardType(.numberPad)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading) {
                    Text("Upper Bound")
                    TextField(
                        "no bound",
                        text: Binding(get: { viewStore.upperBound != nil ? "\(viewStore.upperBound!)" : "" }, set: { viewStore.send(.updateUpperBound($0)) } )
                    )
                    .font(.title)
                    .keyboardType(.numberPad)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Button {
                viewStore.send(.goButtonTapped)
            } label: {
                Text("GO").font(.title2)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(store.scope(state: \.alert), dismiss: .validationMessageDismissed)
    }
}

// MARK: - Preview

struct RangeInputView_Previews: PreviewProvider {
    static var previews: some View {
        RangeInputView(store: Store<RangeInputState, RangeInputAction>(
            initialState: RangeInputState(),
            reducer: rangeInputReducer,
            environment: RangeInputEnvironment(commentsClient: .failure)
            )
        )
    }
}
