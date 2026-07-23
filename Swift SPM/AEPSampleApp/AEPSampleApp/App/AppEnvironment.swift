//
//  AppEnvironment.swift
//  AEPSampleApp
//
//  Composition root + shared observable app state, injected via SwiftUI's
//  Environment. This is the ONLY place mock vs. real services are chosen
//  (see `.live()` — added in Stage 1), so swapping a capability to its real
//  SDK impl never touches a single view.
//
//  Cross-screen state (consent, identity) lives here so every screen observes
//  it. Screen-local data (products, propositions, inbox, diagnostics) is owned
//  by the individual view models.
//

import Observation

@Observable
final class AppEnvironment {

    // MARK: Shared observable state

    /// Default is `.pending` — the user must explicitly choose on first launch.
    var consent: ConsentState = .pending
    /// Tracks whether the one-time consent primer has been answered.
    var hasChosenConsent: Bool = false
    /// Authenticated test user, or nil when anonymous.
    var signedInUser: String?

    /// Anonymous device id, resolved asynchronously via `refreshIdentity()`.
    private(set) var ecid: String = "—"

    // MARK: Services (protocol types — the SDK seam)

    let analytics: AnalyticsService
    let identity: IdentityService
    let consentService: ConsentService
    let personalization: PersonalizationService
    let messaging: MessagingService
    let liveActivity: LiveActivityService
    let diagnostics: DiagnosticsService

    init(
        analytics: AnalyticsService,
        identity: IdentityService,
        consentService: ConsentService,
        personalization: PersonalizationService,
        messaging: MessagingService,
        liveActivity: LiveActivityService,
        diagnostics: DiagnosticsService
    ) {
        self.analytics = analytics
        self.identity = identity
        self.consentService = consentService
        self.personalization = personalization
        self.messaging = messaging
        self.liveActivity = liveActivity
        self.diagnostics = diagnostics
    }

    // MARK: Intent — cross-screen actions that wrap a service + update state

    /// Resolves the ECID from the identity service. Call once on launch.
    func refreshIdentity() async {
        if let id = await identity.experienceCloudId() { ecid = id }
    }

    func chooseConsent(_ state: ConsentState) {
        consentService.update(state)
        consent = state
        hasChosenConsent = true
    }

    func updateConsent(_ state: ConsentState) {
        consentService.update(state)
        consent = state
    }

    func login(username: String) {
        identity.login(username: username)
        signedInUser = username
    }

    func logout() {
        identity.logout()
        signedInUser = nil
    }

    /// Short display form of the ECID for the status strip.
    var shortECID: String { ecid == "—" ? "—" : String(ecid.prefix(6)) + "…" }
}

extension AppEnvironment {
    /// Fully mocked — no Adobe SDK. Useful for previews / offline UI work.
    static func mock() -> AppEnvironment {
        AppEnvironment(
            analytics: MockAnalyticsService(),
            identity: MockIdentityService(),
            consentService: MockConsentService(),
            personalization: MockPersonalizationService(),
            messaging: MockMessagingService(),
            liveActivity: MockLiveActivityService(),
            diagnostics: MockDiagnosticsService()
        )
    }

    /// Live wiring: Core/Edge/Identity/Consent/Assurance are real;
    /// personalization and messaging stay mocked until their stages
    /// (Messaging → Stage 3, Optimize → Stage 4).
    static func live() -> AppEnvironment {
        AppEnvironment(
            analytics: AEPEdgeAnalyticsService(),
            identity: AEPEdgeIdentityService(),
            consentService: AEPEdgeConsentService(),
            personalization: MockPersonalizationService(),
            messaging: AEPMessagingService(),
            liveActivity: MockLiveActivityService(),
            diagnostics: AEPDiagnosticsService()
        )
    }
}
