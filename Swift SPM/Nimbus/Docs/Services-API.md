# SDK Public APIs Used

Every AEP/AJO public API this app calls, grouped by extension. Each is only ever called from inside [`AEPIntegration/`](../Nimbus/AEPIntegration/) — never from a view or view model directly.

Related: [Identity & Auth](Identity-And-Auth.md) · [Surfaces & Triggers](Surfaces.md).

## Mobile Core

| API | What it does | What it's for |
|---|---|---|
| `MobileCore.registerExtensions` | Registers and starts every extension the app uses, then runs the completion once the SDK is initialized. | Called once at launch in [`AEPBootstrapper.start()`](../Nimbus/AEPIntegration/Bootstrap/AEPBootstrapper.swift). |
| `MobileCore.configureWith(appId:)` | Downloads and applies the Tags/Data Collection configuration for the given environment file ID. | Points the SDK at this app's datastream, extensions config, and rules. |
| `MobileCore.lifecycleStart(additionalContextData:)` / `MobileCore.lifecyclePause()` | Starts/pauses Lifecycle session tracking (launches, session length, crashes). | Called on scene foreground/background in [`NimbusApp`](../Nimbus/App/NimbusApp.swift). |
| `MobileCore.track(action:)` | Sends a named behavioral event. | Fires `order-complete`, `add-to-cart`, `browse-category` — used as AJO in-app message triggers. |
| `MobileCore.track(state:)` | Sends a screen-view event. | Fires on tab appearance (`home`, `shop`, `cart`, `inbox`, `profile`) — also usable as an IAM trigger. |
| `MobileCore.setPushIdentifier(_:)` | Registers the device's APNs token with the SDK. | Called from `AppDelegate.didRegisterForRemoteNotificationsWithDeviceToken`. |
| `MobileCore.messagingDelegate` | Delegate hook for gating/customizing in-app message presentation and handling message-triggered deep links. | Set to `InAppMessageDelegate.shared` in the bootstrapper. |

## Edge Network

| API | What it does | What it's for |
|---|---|---|
| `Edge.sendEvent(experienceEvent:)` | Sends one XDM `ExperienceEvent` to the Edge Network. | Every commerce event (product view, add to cart, purchase) — one call per event, never batched. |

## Identity for Edge Network

| API | What it does | What it's for |
|---|---|---|
| `Identity.getExperienceCloudId(completion:)` | Reads the device's ECID. | Read once at launch to seed `AppEnvironment.ecid`. |
| `Identity.getIdentities(completion:)` | Reads the full local `IdentityMap`. | Checks for an already-authenticated `Email` item on relaunch, and reads current items before removing them on logout. |
| `Identity.updateIdentities(with:)` | Merges new identity items into the local `IdentityMap`. Local only — does not call Edge by itself. | Links an `Email` item (authenticated, primary) to the current ECID on login. |
| `Identity.removeIdentity(item:withNamespace:)` | Removes one identity item from the local `IdentityMap`. | Unlinks the `Email` item on logout. The ECID and the server-side identity graph link are unaffected. |

Full flow: [Identity & Auth](Identity-And-Auth.md).

## Consent for Edge Network

| API | What it does | What it's for |
|---|---|---|
| `Consent.update(with:)` | Sends a consent XDM payload (`consents.collect.val`) to Edge immediately. | Applies the user's `yes`/`no` choice from the consent primer. `.pending` is never sent — the tag property's default consent setting stands until the user actively chooses. |

## Optimize

| API | What it does | What it's for |
|---|---|---|
| `Optimize.updatePropositions(for:withXdm:completion:)` | Requests decisions for a list of `DecisionScope`s and returns the resulting `OptimizeProposition`s in the completion. Warms the Optimize cache in the same call — no separate read is needed. | Fetches AJO Offer Decisioning and Adobe Target offers; the decision scope determines which engine responds. |
| `Offer.displayed()` | Sends a display interaction event for that offer. | Reported once a fetched offer is shown on screen. |
| `Offer.tapped()` | Sends a tap/click interaction event for that offer. | Reported on user tap. |

`Offer.proposition` is a `weak` reference back to its parent `OptimizeProposition`; both must be retained by the caller for as long as `displayed()`/`tapped()` may be called, or tracking silently no-ops.

## Messaging (AJO)

| API | What it does | What it's for |
|---|---|---|
| `Messaging.updatePropositionsForSurfaces(_:completion:)` | Fetches propositions for the given surfaces from Edge and refreshes the local cache for those surfaces. | Called before every content card, inbox, and CBE read. |
| `Messaging.getPropositionsForSurfaces(_:completion:)` | Reads propositions for the given surfaces from the local cache. | Called immediately after the update call above to retrieve the fetched result. |
| `Messaging.registerLiveActivities(_:)` | Registers a Live Activity attributes type so the SDK can collect its push-to-start/update tokens and drive it from AJO. | Registers `OrderActivityAttributes` at bootstrap. |
| `PropositionItem.track(withEdgeEventType:)` | Sends a display/interact/dismiss interaction event for that item. | Content card, inbox, and CBE display/tap/dismiss tracking. |

`PropositionItem.proposition` is a `weak` reference back to its parent `Proposition`; same retention requirement as Optimize's `Offer`/`OptimizeProposition`.

An inbox surface query can return items originally authored under a different surface (`home`, `shop_all`, etc.) — grouping content cards into an Inbox channel is done on the AJO side, and querying the inbox surface alone returns the full grouped set.

## Assurance

| API | What it does | What it's for |
|---|---|---|
| `Assurance.startSession(url:)` | Starts an Assurance session from a QR/deep link URL and presents the SDK's own PIN entry overlay. | Wired to `onOpenURL` in `NimbusApp` for QR/deep-link session connection. |

The in-app SDK Event Log (`Features/EventLog`) is a separate, local companion — it does not call this API.

## ActivityKit + AEPMessagingLiveActivity

| API | What it does | What it's for |
|---|---|---|
| `Activity.request(attributes:content:pushType:)` | Starts a new Live Activity. | Starts a mock order-tracking activity at step `.placed`. |
| `Activity.update(_:)` | Pushes a content update to a running activity. | Advances the activity to the next `OrderStep`. |
| `Activity.end(_:dismissalPolicy:)` | Ends a running activity. | Ends order tracking. |
| `Activity<T>.activities` | Reads all currently running activities of a given attributes type. | Re-attaches to an activity still running after a relaunch, and lists all active order activities. |

The order data itself is mock; the start/update/end calls against ActivityKit are real, and push-to-start/update tokens are still collected by `Messaging.registerLiveActivities` above so AJO can drive the activity server-side.
