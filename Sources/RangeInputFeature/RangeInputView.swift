import SwiftUI
import CommentsListFeature
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
            
            NavigationLink(
                destination: IfLetStore(
                    self.store.scope(state: \.commentsListState, action: RangeInputAction.commentsList)
                ) {
                    CommentsListView(store: $0)
                        .navigationTitle(
                            Text(
                                "Comments in [\(viewStore.lowerBound ?? 0), \((viewStore.upperBound != nil) ? "\(viewStore.upperBound!)" : "...")]"
                            )
                        )
                },
              isActive: viewStore.binding(
                get: { $0.commentsListState != nil },
                send: {
                  // NB: SwiftUI will print errors to the console about "AttributeGraph: cycle detected"
                  //     if you disable a text field while it is focused. This hack will force all
                  //     fields to unfocus before we send the action to the view store.
                  // CF: https://stackoverflow.com/a/69653555
                  _ = UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
                  )
                  return $0 ? .goButtonTapped : .commentsListDismissed
                }
              )
            ) {
                EmptyView()
            }
            if viewStore.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                    // Note: There seems to be a bug in SwiftUI where the progress view does not show
                    // a second time unless it is given a new identity.
                        .id(UUID())
                    Button("Cancel") { viewStore.send(.cancelButtonTapped) }
                        .buttonStyle(.borderedProminent)
                }
            } else {
                Button {
                    viewStore.send(.goButtonTapped)
                } label: {
                    Text("GO").font(.title2)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(store.scope(state: \.alert), dismiss: .validationMessageDismissed)
    }
}

// MARK: - Preview

struct RangeInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RangeInputView(store: Store<RangeInputState, RangeInputAction>(
                initialState: RangeInputState(),
                reducer: rangeInputReducer,
                environment: RangeInputEnvironment(commentsClient: .failure, mainQueue: .main)
            )
            )
        }
    }
}
