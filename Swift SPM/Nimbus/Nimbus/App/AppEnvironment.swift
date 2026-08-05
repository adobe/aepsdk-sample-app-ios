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
    /// Tracks whether the login prompt has been seen (login or guest tap). Skips
    /// the screen if the user was already logged in when the app launched.
    var hasSeenLoginPrompt: Bool = false
    /// Authenticated test user, or nil when anonymous.
    var signedInUser: String?

    /// Current order-tracking Live Activity step, or nil when no activity is running.
    /// Single source of truth — written by checkout and inbox controls alike.
    private(set) var activeOrderStep: OrderStep? = nil

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

    /// Resolves the ECID, restores any authenticated email, and re-attaches to a
    /// running Live Activity if the app was relaunched mid-order. Call once on launch.
    func refreshIdentity() async {
        async let ecidResult = identity.experienceCloudId()
        async let emailResult = identity.loggedInEmail()
        if let id = await ecidResult { ecid = id }
        if let email = await emailResult {
            signedInUser = email
            hasSeenLoginPrompt = true
        }
        activeOrderStep = liveActivity.currentStep()
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
        hasSeenLoginPrompt = true
    }

    func continueAsGuest() {
        hasSeenLoginPrompt = true
    }

    func logout() {
        identity.logout()
        signedInUser = nil
    }

    // MARK: Live Activity intents

    /// Ends any running order activity, then starts a fresh one at step `.placed`.
    /// Called automatically after checkout.
    func startOrderTrackingForCheckout() async {
        await liveActivity.endOrderTracking()
        let started = await liveActivity.startOrderTracking()
        activeOrderStep = started ? .placed : nil
    }

    func advanceLiveActivityStep() async {
        if let next = await liveActivity.advanceStep() {
            activeOrderStep = next
        }
    }

    func endLiveActivity() async {
        await liveActivity.endOrderTracking()
        activeOrderStep = nil
    }

    /// Short display form of the ECID for the status strip.
    var shortECID: String { ecid == "—" ? "—" : String(ecid.prefix(6)) + "…" }
}

extension AppEnvironment {
    /// Live wiring — every service is SDK-backed (personalization via AEP
    /// Optimize).
    static func live() -> AppEnvironment {
        AppEnvironment(
            analytics: AEPEdgeAnalyticsService(),
            identity: AEPEdgeIdentityService(),
            consentService: AEPEdgeConsentService(),
            personalization: AEPOptimizeService(),
            messaging: AEPMessagingService(),
            liveActivity: LiveActivityManager(),
            diagnostics: AEPDiagnosticsService()
        )
    }
}
