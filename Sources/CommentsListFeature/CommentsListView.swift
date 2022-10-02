import SwiftUI
import ComposableArchitecture

// MARK:- View
public struct CommentsListView: View {

    let store: Store<CommentsListState, CommentsListAction>
    @ObservedObject var viewStore: ViewStore<CommentsListState, CommentsListAction>

    public init(store: Store<CommentsListState, CommentsListAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    public var body: some View {
        ZStack {
            Text("CommentsListView")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: Preview
struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsListView(store: Store<CommentsListState, CommentsListAction>(
            initialState: CommentsListState(lowerBound: 0, upperBound: nil, items: []),
            reducer: commentsListReducer,
            environment: CommentsListEnvironment()
            )
        )
    }
}

