# Surfaces & Triggers

The concrete surface/trigger reference for this app — every AJO surface URI it fetches and every track action/state it fires. For the *concepts* (what a surface is, how triggering works, which channel to use), read [Messaging & Personalization](Messaging-And-Personalization.md) first; this page is the lookup table that grounds it.

A **surface** is the address a campaign targets: `mobileapp://<bundleId>/<path>`. The SDK auto-prepends `mobileapp://<bundleId>/`, so a marketer enters only the `<path>` in the campaign's surface field. A **trigger** is a `trackAction`/`trackState` value the in-app message rules match on. Keeping both typed in one place (rather than stringly-typed at call sites) prevents drift between app code and campaign config.

Matches the [Surface and Channel Matrix](https://wiki.corp.adobe.com/pages/viewpage.action?pageId=3994824077) wiki page. Related: [SDK API Reference](Services-API.md) for the methods these values are passed to.

## Surface URIs

Defined in [`SurfaceURI.swift`](../Nimbus/Core/Utilities/SurfaceURI.swift). The SDK auto-prepends `mobileapp://com.adobe.nimbus/` to the relative path — enter only the path in an AJO campaign's surface field.

| Constant | AJO path (enter this) | Full URI | Channel | Screen |
|---|---|---|---|---|
| `SurfaceURI.home` | `home` | `mobileapp://com.adobe.nimbus/home` | Content Cards | `HomeView` |
| `SurfaceURI.inbox` | `inbox` | `mobileapp://com.adobe.nimbus/inbox` | Inbox / Feed | `InboxView` |
| `SurfaceURI.shopAll` | `shop_all` | `mobileapp://com.adobe.nimbus/shop_all` | Code-Based Experience | `ShopView` (All) |
| `SurfaceURI.shopApparel` | `shop_apparel` | `mobileapp://com.adobe.nimbus/shop_apparel` | Code-Based Experience | `ShopView` (Apparel) |
| `SurfaceURI.shopAccessories` | `shop_accessories` | `mobileapp://com.adobe.nimbus/shop_accessories` | Code-Based Experience | `ShopView` (Accessories) |
| `SurfaceURI.shopGifts` | `shop_gifts` | `mobileapp://com.adobe.nimbus/shop_gifts` | Code-Based Experience | `ShopView` (Gifts) |
| *(implicit — app-wide)* | `/` | `mobileapp://com.adobe.nimbus/` | In-App Messaging | Any |

AJO preview deep link: replace the path with `path://` — e.g. `inbox://` for the inbox surface.

## Track triggers

| Trigger | Type | Value | Fired from | Channel |
|---|---|---|---|---|
| `order-complete` | Track Action | `action = order-complete` | `ShopViewModel.checkout()` | IAM |
| `add-to-cart` | Track Action | `action = add-to-cart` | `ShopViewModel.increment()` | IAM |
| `browse-category` | Track Action | `action = browse-category` | `ShopViewModel.selectCategory()` | IAM |
| Surface fetch | On appear | `Surface(path:)` call | `HomeViewModel`, `InboxViewModel`, `ShopCBEView` | Content Cards, Inbox, CBE |

## Screen → channel map

| Screen | Tab | Channels active | Surfaces fetched | Track states/actions fired |
|---|---|---|---|---|
| `ConsentPrimerView` | Gate | Consent | — | — |
| `LoginView` | Gate | Identity | — | — |
| `HomeView` | Home | Content Cards, Offer Decisioning | `home` | `trackState: home` |
| `ShopView` | Shop | CBE, IAM (via action) | `shop_*` | `trackState: shop`, `browse-category` |
| `CartView` | Shop (sheet) | IAM (trigger) | — | `trackState: cart`, `order-complete` |
| `InboxView` | Inbox | Inbox/Feed, Live Activity card | `inbox` | `trackState: inbox` |
| `ProfileView` | Profile | Push, Identity, Consent, Developer Tools | — | `trackState: profile` |

## Notes on the Inbox surface

Querying `inbox` alone can return content cards that were originally authored under a different surface (`home`, `shop_all`, etc.) — an AJO marketer can group any set of content cards into one Inbox channel regardless of their original surface, and the SDK returns the full grouped set on a single-surface query. If you need the item's original surface, read it from `PropositionItem.proposition.scopeDetails`; the flat `[PropositionItem]` array from `fetchInboxMessages` does not carry that on its own.
