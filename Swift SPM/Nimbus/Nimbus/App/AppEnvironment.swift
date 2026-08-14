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

import Foundation
import Observation

@Observable
final class AppEnvironment {

    // MARK: Shared observable state

    /// Default is `.pending` — the user must explicitly choose on first launch.
    /// Persisted so the choice (and the UI that reflects it) survives a cold
    /// relaunch. The SDK holds the authoritative consent; this mirror keeps the
    /// app in sync without a per-launch read-back.
    var consent: ConsentState = Persisted.consent {
        didSet { UserDefaults.standard.set(consent.rawValue, forKey: Persisted.consentKey) }
    }
    /// Tracks whether the one-time consent primer has been answered. Persisted
    /// so the primer stays genuinely one-time across cold launches (otherwise it
    /// resets to false on every relaunch and re-sends consent.update).
    var hasChosenConsent: Bool = Persisted.hasChosenConsent {
        didSet { UserDefaults.standard.set(hasChosenConsent, forKey: Persisted.hasChosenConsentKey) }
    }
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

    /// Mirrors Live Activity step changes (local advance OR remote AJO push) into
    /// `activeOrderStep`, so the in-app Inbox card stays in sync with the Dynamic
    /// Island / Lock Screen. Long-lived — call once at launch; it runs for the
    /// app's lifetime.
    @MainActor
    func observeLiveActivityUpdates() async {
        for await step in liveActivity.stepUpdates() {
            activeOrderStep = step
        }
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

/// Local persistence for the consent choice so the one-time consent primer
/// stays one-time across cold launches. Kept in UserDefaults — the SDK remains
/// the source of truth for consent itself; these are just the app-side flags
/// that drive whether the consent gate shows. (The login prompt is intentionally
/// not persisted: logged-in users are restored from the SDK identity map in
/// refreshIdentity(), and guests are re-prompted on next cold launch.)
private enum Persisted {
    static let consentKey = "consent.value"
    static let hasChosenConsentKey = "consent.hasChosen"

    static var consent: ConsentState {
        ConsentState(rawValue: UserDefaults.standard.string(forKey: consentKey) ?? "") ?? .pending
    }
    static var hasChosenConsent: Bool { UserDefaults.standard.bool(forKey: hasChosenConsentKey) }
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
