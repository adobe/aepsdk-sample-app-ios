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

These are written as a **general AEP/AJO knowledge base** — each doc leads with how the SDK behaves in common scenarios and the questions that come up most, then grounds it in how this app demonstrates it. Useful whether or not you work on Nimbus.

| Doc | Covers |
|---|---|
| [Identity, Consent & Auth](Docs/Identity-And-Auth.md) | ECID lifecycle, login/logout/guest scenarios, identity graph vs. profile attributes, namespaces, consent timing, quick-answer Q&A |
| [Messaging & Personalization](Docs/Messaging-And-Personalization.md) | Which channel to use (IAM / content card / CBE / inbox / push / Live Activity), surfaces, proposition tracking & the weak-ref trap, Offer Decisioning vs. Target, quick-answer Q&A |
| [Surfaces & Triggers](Docs/Surfaces.md) | The concrete surface URI + trigger + screen→channel reference for this app |
| [SDK API Reference](Docs/Services-API.md) | Every AEP/AJO SDK API used, grouped by extension — what it does and when to call it |

## Related

- [Main repo README](../../README.md)
