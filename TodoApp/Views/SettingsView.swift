import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var dailyReminderEnabled = true

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.14))
                            .frame(width: 56, height: 56)

                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Todo Nv")
                            .font(.headline)
                        Text("test@email.com")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }

            Section("Preferences") {
                Toggle(isOn: $notificationsEnabled) {
                    SettingsRowLabel(title: "Notifications", subtitle: "Task alerts and reminders", iconName: "bell")
                }

                Toggle(isOn: $dailyReminderEnabled) {
                    SettingsRowLabel(title: "Daily Reminder", subtitle: "Show today’s pending tasks", iconName: "clock")
                }

                Toggle(isOn: $darkModeEnabled) {
                    SettingsRowLabel(title: "Dark Mode", subtitle: "Use system appearance in this demo", iconName: "moon")
                }
            }

            Section("App Details") {
                SettingsInfoRow(title: "App Name", value: "TodoApp")
                SettingsInfoRow(title: "Version", value: "1.0.0.25")
                SettingsInfoRow(title: "Storage", value: "Local SwiftData")
                SettingsInfoRow(title: "Architecture", value: "SwiftUI MVVM")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

private struct SettingsRowLabel: View {
    let title: String
    let subtitle: String
    let iconName: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundStyle(.blue)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct SettingsInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
