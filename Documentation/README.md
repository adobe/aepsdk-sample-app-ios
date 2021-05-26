# Messaging

## Configuration
Before using messaging feature in the sample app you need to follow the below steps to configure it:

1. Update the `Team` option in the `Siging & Capabilities` tab with the available Apple account. 
1. Setup [Journey Optimizer](https://aep-sdks.gitbook.io/docs/beta/adobe-journey-optimizer)
1. Update the `LAUNCH_ENVIRONMENT_FILE_ID` constant value in `AppDelegate.swift` file with the config app id of the property.
    1. For more information on how to get the config app id from launch check this [document](https://experienceleague.adobe.com/docs/launch/using/publish/environments/environments.html?lang=en#mobile-configuration)
1. After following the above steps Run the app on an iOS device (Apple Push Notification cannot be delivered to a Simulator).

