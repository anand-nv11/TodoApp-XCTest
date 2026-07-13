import SwiftData
import SwiftUI

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TodoListViewModel()
    @State private var isShowingAddTodo = false
    @State private var isShowingMenu = false
    @State private var isShowingUpcomingTodos = false
    @State private var isShowingCalendar = false
    @State private var isShowingSettings = false
    @State private var isShowingLists = false
    @State private var isShowingGoals = false
    @State private var isShowingNotifications = false

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    SearchHeader(searchText: $viewModel.searchText)
                        .listRowInsets(EdgeInsets(top: 4, leading: 18, bottom: 10, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    SectionTitleRow(title: "Today's Tasks", actionTitle: viewModel.filteredTodos.isEmpty ? nil : "View All") {
                        isShowingUpcomingTodos = true
                    }
                        .listRowInsets(EdgeInsets(top: 4, leading: 18, bottom: 4, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    FilterChip(title: viewModel.searchText.isEmpty ? "Upcoming" : "Search Results", iconName: "chevron.down")
                        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 6, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    if viewModel.filteredTodos.isEmpty {
                        EmptyStateView(isSearching: !viewModel.searchText.isEmpty)
                            .frame(maxWidth: .infinity, minHeight: 170)
                            .listRowInsets(EdgeInsets(top: 8, leading: 18, bottom: 16, trailing: 18))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(viewModel.filteredTodos) { todo in
                            NavigationLink {
                                TodoDetailView(todo: todo, viewModel: viewModel)
                            } label: {
                                TodoCardView(todo: todo) {
                                    viewModel.toggleCompletion(for: todo, using: modelContext)
                                }
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.delete(todo, using: modelContext)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }

                    SectionTitleRow(title: "Lists", actionTitle: "View All") {
                        isShowingLists = true
                    }
                        .listRowInsets(EdgeInsets(top: 18, leading: 18, bottom: 6, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    listCards
                        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 12, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    SectionTitleRow(title: "Goals", actionTitle: "View All") {
                        isShowingGoals = true
                    }
                        .listRowInsets(EdgeInsets(top: 8, leading: 18, bottom: 6, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    goalCards
                        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 96, trailing: 18))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(dashboardBackground)
                .contentMargins(.top, 64, for: .scrollContent)
                .refreshable {
                    viewModel.loadTodos(using: modelContext)
                }

                VStack {
                    DashboardTopBar(
                        menuAction: {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                                isShowingMenu = true
                            }
                        },
                        settingsAction: {
                            isShowingSettings = true
                        },
                        notificationsAction: {
                            isShowingNotifications = true
                        }
                    )
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .overlay(alignment: .bottom) {
                        Divider().opacity(0.35)
                    }

                    Spacer()
                }
                .zIndex(1)

                BottomHomeBar(
                    calendarAction: {
                        isShowingCalendar = true
                    },
                    addAction: {
                        isShowingAddTodo = true
                    }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                if isShowingMenu {
                    SideMenuOverlay(
                        isPresented: $isShowingMenu,
                        tasksAction: {
                            isShowingUpcomingTodos = true
                        },
                        calendarAction: {
                            isShowingCalendar = true
                        },
                        listsAction: {
                            isShowingLists = true
                        },
                        goalsAction: {
                            isShowingGoals = true
                        },
                        settingsAction: {
                            isShowingSettings = true
                        },
                        notificationsAction: {
                            isShowingNotifications = true
                        }
                    )
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .zIndex(2)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isShowingAddTodo) {
                AddEditTodoView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .navigationDestination(isPresented: $isShowingUpcomingTodos) {
                UpcomingTodosView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isShowingCalendar) {
                CalendarTodosView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isShowingSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $isShowingLists) {
                ListsOverviewView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isShowingGoals) {
                GoalsOverviewView()
            }
            .navigationDestination(isPresented: $isShowingNotifications) {
                NotificationsView(viewModel: viewModel)
            }
            .task {
                viewModel.loadTodos(using: modelContext)
            }
            .alert("Todo Error", isPresented: errorBinding) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Something went wrong.")
            }
        }
    }

    private var listCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryCard(title: "Personal Tasks", subtitle: "\(viewModel.pendingCount) item", iconName: "person.fill", colors: [.pink, .red])
                CategoryCard(title: "Java Exercise", subtitle: "2 item", iconName: "figure.run", colors: [.orange, .yellow])
                CategoryCard(title: "Swift Writing", subtitle: "13 item", iconName: "pencil", colors: [.teal, .cyan])
            }
            .padding(.vertical, 2)
        }
    }

    private var goalCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            CategoryCard(title: "Weekly Goals", subtitle: "Progress", iconName: "square.stack.3d.up.fill", colors: [.blue, .cyan])
            CategoryCard(title: "Books", subtitle: "Keep reading", iconName: "book.closed.fill", colors: [.indigo, .blue])
        }
    }

    private var dashboardBackground: some View {
        LinearGradient(
            colors: [
                Color(uiColor: .systemGroupedBackground),
                Color.blue.opacity(0.08),
                Color(uiColor: .systemGroupedBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )
    }
}

private struct DashboardTopBar: View {
    let menuAction: () -> Void
    let settingsAction: () -> Void
    let notificationsAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Button(action: menuAction) {
                Image(systemName: "line.3.horizontal")
                    .font(.title3.weight(.semibold))
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Menu")

            Spacer()
            Text("Home")
                .font(.headline.weight(.semibold))

      //      Text(Date.now.formatted(date: .omitted, time: .shortened))
                .font(.headline.weight(.semibold))

            Spacer()

            HStack(spacing: 8) {
                Button(action: settingsAction) {
                    Image(systemName: "gearshape")
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Settings")
                .accessibilityIdentifier("homeSettingsButton")

                Button(action: notificationsAction) {
                    Image(systemName: "bell")
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Notifications")
                .accessibilityIdentifier("homeNotificationsButton")
            }
            .font(.title3.weight(.medium))
            .foregroundStyle(.blue)
        }
        .foregroundStyle(.primary)
    }
}

private struct SideMenuOverlay: View {
    @Binding var isPresented: Bool
    let tasksAction: () -> Void
    let calendarAction: () -> Void
    let listsAction: () -> Void
    let goalsAction: () -> Void
    let settingsAction: () -> Void
    let notificationsAction: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                        isPresented = false
                    }
                }

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Good\nAfternoon,")
                        .font(.largeTitle.weight(.medium))
                        .foregroundStyle(.blue)
                        .lineSpacing(3)

                    Text("Todo Nv")
                        .font(.subheadline.weight(.semibold))
                        .padding(.top, 8)

                    Text("test@email.com")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 34)
                .padding(.top, 42)
                .padding(.bottom, 28)

                Divider()
                    .padding(.horizontal, 34)

                VStack(alignment: .leading, spacing: 26) {
                    SideMenuRow(title: "Tasks", iconName: "checkmark.square") {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        tasksAction()
                    }
                    SideMenuRow(title: "Lists", iconName: "list.bullet") {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        listsAction()
                    }
                    SideMenuRow(title: "Goals", iconName: "flag") {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        goalsAction()
                    }
                    SideMenuRow(title: "Calendar", iconName: "calendar") {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        calendarAction()
                    }
                    SideMenuRow(title: "Settings", iconName: "gearshape") {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        settingsAction()
                    }
                    SideMenuRow(title: "Notification", iconName: "bell") {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        notificationsAction()
                    }
                }
                .padding(.horizontal, 34)
                .padding(.top, 32)

                Spacer()

                Text("1.0.0.25")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 34)
            }
            .frame(width: 292)
            .frame(maxHeight: .infinity)
            .background {
                ZStack {
                    Color(uiColor: .secondarySystemGroupedBackground)

                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.16),
                            Color.blue.opacity(0.04),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )

                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color(uiColor: .systemGroupedBackground).opacity(0.65)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: .black.opacity(0.14), radius: 24, x: 10, y: 0)
            .padding(.vertical, 18)
        }
    }
}

private struct SideMenuRow: View {
    let title: String
    let iconName: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .frame(width: 22)

                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier("sideMenu\(title)")
    }
}

private struct SearchHeader: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 10) {
            TextField("Search Task List or Goal", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .accessibilityIdentifier("todoSearchField")

            if searchText.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.primary)
                    .accessibilityHidden(true)
            } else {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 8)
    }
}

private struct SectionTitleRow: View {
    let title: String
    let actionTitle: String?
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.headline.weight(.semibold))
            Spacer()
            if let actionTitle {
                Button(actionTitle) {
                    action?()
                }
                .font(.caption.weight(.semibold))
                .buttonStyle(.plain)
                .foregroundStyle(.blue)
                .accessibilityIdentifier("\(title.replacingOccurrences(of: " ", with: ""))ViewAllButton")
            }
        }
    }
}

private struct FilterChip: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
            Image(systemName: iconName)
                .font(.caption.weight(.bold))
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(.blue)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.12), in: Capsule())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct CategoryCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: iconName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Spacer(minLength: 8)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(width: 128, height: 104, alignment: .leading)
        .padding(14)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
}

private struct BottomHomeBar: View {
    let calendarAction: () -> Void
    let addAction: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            BottomBarItem(title: "Home", iconName: "house.fill", isSelected: true, action: {})
            BottomBarItem(title: "Calendar", iconName: "calendar", isSelected: false, action: calendarAction)
            BottomBarItem(title: "Add Todo", iconName: "plus", isSelected: false, action: addAction)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(.separator.opacity(0.25))
        }
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 8)
    }
}

private struct BottomBarItem: View {
    let title: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.headline)
                Text(title)
                    .font(.caption2.weight(.medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .foregroundStyle(isSelected ? .blue : .primary)
            .background(isSelected ? Color.blue.opacity(0.10) : Color.clear, in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

#Preview {
    TodoListView()
        .modelContainer(try! TodoDatabase.makeModelContainer(inMemory: true))
}
