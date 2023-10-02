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

## Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

## Licensing

This project is licensed under the MIT License. See [LICENSE](LICENSE) for more information.
