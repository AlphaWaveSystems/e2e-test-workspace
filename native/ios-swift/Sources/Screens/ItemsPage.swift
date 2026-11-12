import SwiftUI

/// Mirrors lib/features/items/presentation/pages/item_list_page.dart.
struct ItemsPage: View {
    @EnvironmentObject var items: ItemsStore
    @EnvironmentObject var snackbar: SnackbarCenter
    @State private var searchText: String = ""

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                TextField("Search items...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: searchText) { _, newValue in
                        items.search(newValue)
                    }
                    .accessibilityIdentifier("search_field")

                if items.filteredItems.isEmpty {
                    Text("No items found")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityIdentifier("empty_state")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(items.filteredItems.enumerated()), id: \.element.id) { index, item in
                                row(index: index, item: item)
                                Divider().padding(.leading, 16)
                            }
                        }
                    }
                    .accessibilityIdentifier("scrollable_list")
                }
            }

            Button {
                snackbar.show("Add item tapped")
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Circle().fill(Color.accentColor))
                    .shadow(radius: 4)
            }
            .padding(20)
            .accessibilityIdentifier("fab_add")
        }
        .navigationTitle("Items")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(index: Int, item: AppItem) -> some View {
        HStack {
            Text("\(item.id)")
                .frame(width: 32, height: 32)
                .background(Circle().fill(Color.accentColor.opacity(0.2)))
            VStack(alignment: .leading) {
                Text(item.title)
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .accessibilityIdentifier("list_item_\(index)")
        .background(Color(.systemBackground))
        .swipeToDismiss(direction: .leftOnly) {
            items.deleteItem(id: item.id)
        }
        .accessibilityIdentifier("dismissible_\(item.id)")
    }
}
