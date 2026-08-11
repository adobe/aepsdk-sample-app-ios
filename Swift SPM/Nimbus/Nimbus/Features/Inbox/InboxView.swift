//
//  InboxView.swift
//  Nimbus
//
//  Inbox/feed tab: Live Activity entry point on top, a Custom ↔ SDK rendering
//  toggle, then either the app's custom list (raw propositions + InboxStore)
//  or the SDK-rendered Inbox channel container (getInboxUI).
//

import SwiftUI

struct InboxView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = InboxViewModel()
    @State private var mode: Mode = .custom

    private enum Mode: String, CaseIterable {
        case custom = "Custom"
        case sdk = "SDK UI"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LiveActivityCardView(
                    isActive: env.activeOrderStep != nil,
                    step: env.activeOrderStep,
                    canAdvance: env.activeOrderStep?.isTerminal == false,
                    onToggle: {
                        Task {
                            if env.activeOrderStep != nil {
                                await env.endLiveActivity()
                            } else {
                                await env.startOrderTrackingForCheckout()
                            }
                        }
                    },
                    onAdvance: { Task { await env.advanceLiveActivityStep() } }
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Picker("Rendering", selection: $mode) {
                    ForEach(Mode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(16)

                switch mode {
                case .custom: customList
                case .sdk:    SDKInboxView(surfacePath: SurfaceURI.inbox)
                }
            }
            .navigationTitle("Inbox")
            .onAppear { env.analytics.trackState("inbox", data: nil) }
            .task { await model.onAppear(env) }
        }
    }

    private var customList: some View {
        List {
            if model.messages.isEmpty && model.isLoading {
                ProgressView()
            } else if model.messages.isEmpty {
                Text("No messages yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(model.messages) { message in
                    InboxRowView(message: message)
                        .contentShape(Rectangle())
                        .onTapGesture { model.markRead(message, env: env) }
                        .swipeActions {
                            Button(role: .destructive) {
                                model.dismiss(message, env: env)
                            } label: {
                                Label("Dismiss", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .refreshable { await model.refresh(env) }
    }
}
