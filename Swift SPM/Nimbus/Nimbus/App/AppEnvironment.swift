//
//  AppEnvironment.swift
//  Nimbus
//
//  Composition root + shared observable app state, injected via SwiftUI's
//  Environment. `.live()` is the single place service implementations are
//  chosen, so swapping a capability's impl never touches a view.
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
        // Unlinks the email locally; ECID stays the same.
        identity.logout()
        signedInUser = nil
    }

    /// Short display form of the ECID for the status strip.
    var shortECID: String { ecid == "—" ? "—" : String(ecid.prefix(6)) + "…" }
}

extension AppEnvironment {
    /// Live wiring. All services are SDK-backed except personalization, which
    /// stays mocked until Optimize/Decisioning is integrated.
    static func live() -> AppEnvironment {
        AppEnvironment(
            analytics: AEPEdgeAnalyticsService(),
            identity: AEPEdgeIdentityService(),
            consentService: AEPEdgeConsentService(),
            personalization: MockPersonalizationService(),
            messaging: AEPMessagingService(),
            liveActivity: LiveActivityManager(),
            diagnostics: AEPDiagnosticsService()
        )
    }
}
