import ComposableArchitecture
import Models
import SwiftUI


// MARK: State
public typealias CommentRowState = Comment


// MARK: Actions
public enum CommentRowAction: Equatable {
    case placeholder
}

// MARK: Environment
public struct CommentRowEnvironment {
    public init() {}
}

// MARK: Reducer
public let commentRowReducer =
    Reducer<CommentRowState, CommentRowAction, CommentRowEnvironment> {
        state, action, environment in
        switch action {
		case .placeholder:
		    return .none
        }
    }

// MARK: - View

public struct CommentRowView: View {

    let store: Store<CommentRowState, CommentRowAction>
    @ObservedObject var viewStore: ViewStore<CommentRowState, CommentRowAction>

    public init(store: Store<CommentRowState, CommentRowAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name: \(viewStore.name)")
                .font(.title2)
            Text("Email: \(viewStore.email)")
            Text("Body: \(viewStore.body)")
            HStack {
                Text("id: \(viewStore.id)")
                Spacer()
                Text("postId: \(viewStore.postId)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.primary.opacity(0.15), radius: 3, x: 0, y: 1)
        
    }
}

// MARK: Preview
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView(store: Store<CommentRowState, CommentRowAction>(
            initialState: Comment(postId: 1, id: 1, name: "Name", email: "email@mail.com", body: "Some body text goes here. Some body text goes here."),
            reducer: commentRowReducer,
            environment: CommentRowEnvironment()
            )
        )
    }
}
