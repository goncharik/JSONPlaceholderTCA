import SwiftUI
import CommentRowFeature
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
            if viewStore.items.count == 0 {
                Text("No comments in selected bounds")
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEachStore(
                            self.store.scope(state: \.items, action: CommentsListAction.row(id:action:))
                        ) { item in
                            CommentRowView(store: item)
                                .padding([.top], 2)
                                .padding([.leading, .trailing])
                                .padding([.bottom], 6)
                        }
                        if viewStore.isLoading {
                            ProgressView()
                            // Note: There seems to be a bug in SwiftUI where the progress view does not show
                            // a second time unless it is given a new identity.
                                .id(UUID())
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: Preview
import Models

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommentsListView(store: Store<CommentsListState, CommentsListAction>(
                initialState: CommentsListState(
                    lowerBound: 0,
                    upperBound: nil,
                    limit: 1,
                    items: [
                        Comment(postId: 1, id: 1, name: "Name", email: "email@mail.com", body: "Some body text goes here. Some body text goes here."),
                        Comment(postId: 1, id: 2, name: "Name2", email: "email@mail.com", body: "Some body text goes here. Some body text goes here."),
                        Comment(postId: 1, id: 3, name: "Name3", email: "email@mail.com", body: "Some body text goes here. Some body text goes here."),
                    ]
                ),
                reducer: commentsListReducer,
                environment: CommentsListEnvironment(commentsClient: .failure, mainQueue: .main)
            )
            )
            .navigationBarTitle(
                Text(
                    "Comments in selected bounds"
                ),
                displayMode: .inline
            )
        }
    }
}

