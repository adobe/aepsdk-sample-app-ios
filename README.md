# AEP SDK Sample App for iOS

# Notice of deprecation

Each [respective extension repository](https://developer.adobe.com/client-sdks/documentation/current-sdk-versions/#ios) now has its own test app. Please refer to those repositories for their test apps.


## About this Project

This repository contains iOS sample apps for the AEP SDK. Examples are provided for both Objective-c and Swift implementation.

## Requirements

- Xcode 14.1.0 or newer
- Swift 5.1 or newer (Swift project only)
- Cocoapods 1.6 or newer

## Installation

#### Swift

- Navigate to the `Swift` directory, and run the following command from terminal:

  ```
  pod install
  ```

- After the above command finishes, open the Xcode workspace:

  ```
  open AEPSampleApp.xcworkspace
  ```

- Run the `AEPSampleApp` target on the simulator of your choice.

#### Objective-c

- Navigate to the `Obj-C` directory, and run the following command from terminal:

  ```
  pod install
  ```

- After the above command finishes, open the Xcode workspace:

  ```
  open AEPSampleAppObjC.xcworkspace
  ```

- Run the `AEPSampleAppObjC` target on the simulator of your choice.

#### Nimbus (Swift Package Manager)

Nimbus is a standalone SwiftUI sample app that uses Swift Package Manager (no CocoaPods) and requires **Xcode 16+** / **iOS 18+**. It showcases Edge, Identity, Consent, Messaging (push, in-app, content cards, inbox), Optimize (Offer Decisioning + Target), and Live Activities.

1. Open the project directly — no `pod install` needed:

   ```
   open "Swift SPM/Nimbus/Nimbus.xcodeproj"
   ```

2. Set your Data Collection mobile property environment ID in [`AEPConfig.swift`](Swift%20SPM/Nimbus/Nimbus/AEPIntegration/Bootstrap/AEPConfig.swift):

   ```swift
   static let appId = "<your-environment-file-id>"
   ```

3. Ensure [`Core/OrderActivityAttributes.swift`](Swift%20SPM/Nimbus/Nimbus/Core/OrderActivityAttributes.swift) is a member of **both** the `Nimbus` app target **and** the `OrderActivityWidget` extension target. It defines the shared Live Activity type used by both; select the file in Xcode, open the File Inspector, and confirm both boxes under **Target Membership** are checked. Live Activities won't build/run correctly otherwise.

4. Set your development team under **Signing & Capabilities**. Push notifications require a paid Apple Developer account (APNs can't deliver to the Simulator).

5. Run the `Nimbus` target on a simulator or device.

See the [Nimbus README](Swift%20SPM/Nimbus/README.md) and [Docs](Swift%20SPM/Nimbus/Docs/) for architecture, the Services API, and the surface/trigger reference.

## Documentation
### Launch Edge Extensions Prerequisites
App needs to be configured with the following edge extensions in Launch before it can be used: 
- [Edge](https://developer.adobe.com/client-sdks/documentation/edge-network/)
- [Edge Identity](https://developer.adobe.com/client-sdks/documentation/identity-for-edge-network/)
- [Consent](https://developer.adobe.com/client-sdks/documentation/consent-for-edge-network/)
- [Messaging](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer/)

### Lifecycle for Edge Network 
Follow the [documentation](https://developer.adobe.com/client-sdks/documentation/lifecycle-for-edge-network/) to forward Lifecycle extension metrics to the Adobe Experience Platform.

### Messaging
Follow the [documentation](Documentation/README.md) for enabling messaging in the sample app.

### Nimbus (Swift Package Manager)
See [Installation → Nimbus](#nimbus-swift-package-manager) above for setup. Deeper docs live in the [Nimbus README](Swift%20SPM/Nimbus/README.md) and [Docs](Swift%20SPM/Nimbus/Docs/) — architecture, identity/auth behavior, the Services API, and the surface/trigger reference.

## Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

## Licensing

This project is licensed under the MIT License. See [LICENSE](LICENSE) for more information.
