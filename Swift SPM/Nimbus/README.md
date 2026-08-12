# Nimbus

Nimbus is the Swift Package Manager–based iOS reference app for the AEP/AJO Mobile SDK. It exercises Edge, Identity, Consent, Messaging (push, in-app, content cards, inbox), Optimize (Offer Decisioning + Target), and Live Activities through a small commerce app (Home / Shop / Inbox / Profile).

Bundle ID: `com.adobe.nimbus`

## Requirements

- Xcode 16 or newer
- iOS 18 simulator/device (uses `@Observable`, `NavigationStack`, `Tab(value:)`)
- A paid Apple Developer account for push notification testing (APNs cannot deliver to a Simulator)

## Getting started

1. Open `Nimbus.xcodeproj` in Xcode.
2. Set your Team under **Signing & Capabilities**.
3. Configure the Data Collection tag property and Datastream for this app, then set the resulting environment file ID in [`AEPConfig.swift`](Nimbus/AEPIntegration/Bootstrap/AEPConfig.swift).
4. Run the `Nimbus` target.

## Architecture

The app is split into three layers:

- **`Features/`** — SwiftUI views + `@Observable` view models, one folder per screen (Home, Shop, Inbox, Profile, Login, Consent, Optimize, Assurance, EventLog).
- **`Services/`** — protocol seams (`AnalyticsService`, `IdentityService`, `ConsentService`, `PersonalizationService`, `MessagingService`, `DiagnosticsService`, `LiveActivityService`). Views and view models depend only on these protocols, never on an Adobe SDK type.
- **`AEPIntegration/`** — the concrete, SDK-backed implementation of each protocol. This is the only layer that imports an `AEP*` module.

[`AppEnvironment`](Nimbus/App/AppEnvironment.swift) is the composition root: `AppEnvironment.live()` wires every protocol to its real AEP-backed implementation and is injected once via SwiftUI's `Environment`.

## Docs

| Doc | Covers |
|---|---|
| [Identity & Auth](Docs/Identity-And-Auth.md) | ECID lifecycle, consent gate, login/guest flow, logout behavior |
| [Services API](Docs/Services-API.md) | Every protocol in `Services/`, its real AEP SDK call, and where it's used |
| [Surfaces & Triggers](Docs/Surfaces.md) | Every AJO surface URI and track action/state trigger this app fires |

## Related

- [Main repo README](../../README.md)
