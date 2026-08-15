# Messaging & Personalization

How the AJO/Optimize delivery channels differ, when to use each, and the gotchas that bite everyone — followed by how this app demonstrates each. Start with [Which channel do I use?](#which-channel-do-i-use) and [Quick answers](#quick-answers).

Related: [Surfaces & Triggers](Surfaces.md) for the surface/trigger reference · [SDK API Reference](Services-API.md) · [Identity, Consent & Auth](Identity-And-Auth.md).

## Which channel do I use?

AJO delivers to mobile through several channels. They look similar but differ in **who renders the UI**, **how they're triggered**, and **whether they persist**:

| Channel | Who renders | Trigger | Persists? | Use when |
|---|---|---|---|---|
| **In-App Message (IAM)** | The SDK (modal/banner/fullscreen) | `trackAction` / `trackState` → local rules | No | Interrupt-style promo tied to an action or screen |
| **Content Card** | You (custom) *or* SDK-templated | Surface fetch on screen appear | While cached | Embedded cards in your own layout (carousel, list) |
| **Code-Based Experience (CBE)** | You, fully | Surface fetch | While cached | Arbitrary JSON/HTML you render however you want |
| **Inbox / Feed** | You | Surface fetch (inbox surface) | Yes (message list) | A persistent "mailbox" grouping many messages |
| **Push** | OS notification | Server-initiated | OS-managed | Reach the user when the app is closed |
| **Live Activity** | Widget extension + your in-app card | Local start, then local or AJO push updates | Until ended | Real-time ongoing status (order, ride, game) |

Key distinction: **IAM and push are interruptive and SDK/OS-rendered; content cards, CBE, and inbox are pull-based surfaces you fetch and (usually) render yourself.**

## Surfaces: the join key

Content cards, CBE, and inbox are all addressed by a **surface** — a URI of the form `mobileapp://<bundleId>/<path>`. The `<path>` is what a marketer types into the AJO campaign's surface field; the SDK auto-prepends `mobileapp://<bundleId>/`.

A surface is simply the agreed-upon address between app code and campaign. The app fetches a surface; AJO returns whatever campaigns target it. See [Surfaces & Triggers](Surfaces.md) for the full list this app uses.

The fetch is always two steps: **`updatePropositionsForSurfaces`** (warms the surface from Edge) then **`getPropositionsForSurfaces`** (reads the cache). One important consequence: `updatePropositionsForSurfaces` **clears a surface's cache before repopulating it**, so two concurrent fetches of the *same* surface can race and wipe each other — fetch a given surface from one place at a time.

## Proposition vs. PropositionItem (and why tracking silently fails)

A fetch returns **propositions**, each containing one or more **items**:

```
Proposition (per surface/decision)
 └── items: [PropositionItem]   ← the actual card/offer content
       └── proposition  → weak reference back to the parent
```

`PropositionItem.proposition` (Messaging) and `Offer.proposition` (Optimize) are **weak** references — to avoid a retain cycle. The trap: if you keep only the item array and let the parent proposition deallocate, that weak ref becomes `nil`, and every later `track(...)` / `displayed()` / `tapped()` call **silently no-ops** — no crash, no error, just missing data in AEP.

**Rule: retain the parent proposition for as long as you might track its items.** Store the `[Proposition]` array somewhere that lives as long as the items do.

## Tracking: display vs. interact vs. dismiss

Interactions are reported per item:

- **Display** — the item appeared on screen. Report once when it renders.
- **Interact** (a.k.a. click) — the user tapped it. Often carries a token like `"click"`.
- **Dismiss** — the user dismissed it (inbox/IAM).

These flow to Edge as `decisioning.propositionDisplay` / `decisioning.propositionInteract` events. In Assurance, verify the display event fires when the item renders — if it's missing, you're likely hitting the weak-ref trap above.

## Personalization: Offer Decisioning vs. Adobe Target

Both run through the **same Optimize API**. You request one or more **decision scopes**; the **scope determines which engine answers**:

- `Optimize.updatePropositions(for:withXdm:completion:)` warms the cache **and returns** the decisions in its completion — no separate read needed.
- An AJO **Offer Decisioning** decision and an Adobe **Target** activity are both just decision scopes from the app's point of view.
- Report engagement with `Offer.displayed()` and `Offer.tapped()` (same weak-parent retention rule as above).

A frequent cold-launch symptom: an offer fetch right at launch returns empty because the Edge configuration hasn't finished downloading yet. Fetching a moment later (or after config settles) returns the offer. It's a timing issue, not a decisioning failure.

## In-App Messages: how triggering works

IAMs are evaluated **locally** by the Messaging rules engine — no network round-trip at trigger time:

1. App calls `trackAction("order-complete")` or `trackState("home")`.
2. The Messaging extension evaluates its downloaded rules against that event.
3. On a match, it shows the message and reports display/interact back to Edge.

So the campaign's trigger condition in AJO (e.g. `action == "order-complete"`) must match exactly what the app sends. In Assurance the chain to look for is: track event → **Rules Consequence** → **Show Message**. If you see the track event but no consequence, the rule didn't match.

## Push

Push is server-initiated:

1. Register for remote notifications; hand the APNs device token to the SDK via `setPushIdentifier`.
2. Configure a push channel + credentials (APNs key) in AJO, and add the push profile dataset to the datastream.
3. AJO journeys/campaigns send to the token.

Dev builds get a **sandbox** APNs token; tell the SDK to use sandbox (`messaging.useSandbox`) or APNs rejects it. Push cannot be delivered to the Simulator.

## Live Activities: local vs. AJO-driven

A Live Activity has two update paths:

- **Local** — the app calls `Activity.update(...)` on device. Needs no push token; drives both the OS UI (Dynamic Island / Lock Screen) and any in-app mirror card.
- **Remote (AJO-driven)** — request the activity with `pushType: .token`, forward the minted update token to the SDK, and AJO pushes content-state updates (`"content-state": { "step": 3, … }`). The OS UI updates automatically; to keep an **in-app** card in sync you must subscribe to ActivityKit's `contentUpdates` stream, since a remote push doesn't otherwise notify your app code.

`registerLiveActivities` lets the SDK collect **push-to-start** and **update** tokens so AJO can both start and drive activities.

## Inbox: cross-surface grouping

An inbox is a **grouping channel**, not just another surface. A marketer can group content cards **authored under different surfaces** (`home`, `shop_all`, …) into one inbox, and querying the **inbox surface alone** returns the whole grouped set. If you need an item's original surface, read it from `PropositionItem.proposition.scopeDetails` — the flat item array doesn't carry it.

## Quick answers

| Question | Answer |
|---|---|
| IAM vs. content card vs. CBE? | IAM = SDK-rendered interrupt; content card = embedded card you place; CBE = raw payload you render fully. |
| Why did my `track(...)` do nothing? | The parent proposition deallocated (weak ref). Retain the `[Proposition]` while items live. |
| Offer Decisioning vs. Target in code? | Identical — both are decision scopes through `Optimize.updatePropositions`. |
| Offer is empty right at launch? | Edge config likely hasn't downloaded yet; fetch after it settles. |
| IAM didn't show? | The `trackAction`/`trackState` value must match the campaign's trigger exactly; check for a Rules Consequence in Assurance. |
| Two fetches of the same surface returned nothing? | `updatePropositionsForSurfaces` clears the cache before repopulating — don't fetch one surface concurrently. |
| In-app Live Activity card doesn't update on remote push? | Subscribe to ActivityKit `contentUpdates`; remote pushes update the OS UI, not your app code. |
| Inbox returns cards from other surfaces? | Expected — inbox is a grouping channel across surfaces. |

## How this app demonstrates it

All Messaging/Optimize calls live behind `MessagingService` / `PersonalizationService`, implemented in [`AEPIntegration/`](../Nimbus/AEPIntegration/).

- **Content cards** — both custom (`ContentCardCarouselView`) and SDK-templated (`SDKContentCardsView`) rendering off the `home` surface.
- **CBE** — `ShopCBEView` fetches per-category surfaces (`shop_*`) and renders the raw JSON.
- **Inbox** — `InboxView` fetches the `inbox` surface; read/dismiss state is layered locally.
- **IAM** — triggered by `trackAction`/`trackState` from the Shop/Cart flows.
- **Optimize** — Home shows Offer Decisioning + Target results side by side, fetched via the same `fetchPropositions`.
- **Push** — `PushManager` handles authorization + token; sandbox is set for dev builds.
- **Live Activity** — order tracking; local advance plus an AJO-driven path (`pushType: .token`) with an in-app card kept live via a `stepUpdates` stream.
- **Weak-ref retention** — the services keep parent propositions in reference-type stores so tracking stays valid; see the store types in [`AEPMessagingService`](../Nimbus/AEPIntegration/Messaging/AEPMessagingService.swift) and [`AEPOptimizeService`](../Nimbus/AEPIntegration/Optimize/AEPOptimizeService.swift).
