//
//  InboxView.swift
//  AEPSampleApp
//
//  Inbox/feed tab: Live Activity entry point on top, then the message list
//  with read/unread state and swipe-to-dismiss. The tab badge shows unread
//  count (wired in RootView in a later pass; count exposed via the model).
//

import SwiftUI

struct InboxView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = InboxViewModel()
    @State private var inspector: InspectorPayload?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    LiveActivityCardView(isActive: model.liveActivityActive) {
                        Task { await model.toggleLiveActivity(env) }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }

                Section("Messages") {
                    if model.messages.isEmpty && model.isLoading {
                        ProgressView()
                    } else if model.messages.isEmpty {
                        Text("No messages yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(model.messages) { message in
                            InboxRowView(message: message) {
                                model.markRead(message)
                                inspector = inspectorPayload(for: message)
                            }
                            .onTapGesture { model.markRead(message) }
                            .swipeActions {
                                Button(role: .destructive) {
                                    model.dismiss(message)
                                } label: {
                                    Label("Dismiss", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Inbox")
            .task { await model.onAppear(env) }
            .refreshable { await model.refresh(env) }
            .sheet(item: $inspector) { InspectorSheet(payload: $0) }
        }
    }

    private func inspectorPayload(for m: InboxMessage) -> InspectorPayload {
        InspectorPayload(
            title: m.title,
            source: m.surface,
            json: m.rawJSON,
            tracking: ["propositionDisplay", "propositionInteract (on tap)"]
        )
    }
}
