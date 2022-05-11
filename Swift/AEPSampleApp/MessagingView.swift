/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI

import AEPCore
import AEPEdge
import AEPIdentity
import AEPMessaging
import AEPServices

class MessagingViewController: UIHostingController<MessagingView> {}

struct MessagingView: View {
    @State private var ecidState:String = ""

    let LOG_PREFIX = "MessagingViewController"
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 12) {
            messaging
        }.padding().onAppear() {
            MobileCore.track(state: "Messaging", data:nil)
        }
    }

    /// UI elements for the product review example
    var messaging: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Push Messaging").font(.title).bold()
                Text("Messaging SDK setup is complete with ECID:")
                Text(ecidState).bold()
                Spacer(minLength: 15)
                Text("Click a button below to schedule a notification:")
                Text("(clicking on a notification demonstrates how to handle a notification response)").italic()
                Button("Sample notification") {
                    scheduleNotification()
                }
                Button("Sample notification with custom actions") {
                    scheduleNotificationWithCustomAction()
                }
                Spacer(minLength: 15)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("In-App Messaging (beta)").font(.title).bold()
                Text("Click a button below to trigger an in-app message:")
                Button("Sample fullscreen message") {
                    MobileCore.track(action: "sampleAppFullscreen", data: nil)
                }
                Button("Sample modal message") {
                    MobileCore.track(action: "sampleAppModal", data: nil)
                }
                Button("Sample top banner") {
                    MobileCore.track(action: "sampleAppBannerTop", data: nil)
                }
                Button("Sample bottom banner") {
                    MobileCore.track(action: "sampleAppBannerBottom", data: nil)
                }
                Spacer()
            }
        }.onAppear() {
            updateEcid()
        }
    }

    func updateEcid() {
        Identity.getExperienceCloudId { (ecid, err) in
            if ecid == nil {return}
            ecidState = ecid ?? ""
        }
    }
    
    // MARK: - Creation of local notifications for demonstrating notification click-throughs
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Simple notification"
        content.body = "This notification does not have any custom actions."
        
        /// the structure of `userInfo` is the same as you'd see with an actual push message.
        /// the values are made up for demonstration purposes.
        content.userInfo = [
            "_xdm": [
                "cjm": [
                    "_experience": [
                        "customerJourneyManagement": [
                            "messageExecution": [
                                "messageExecutionID": "00000000-0000-0000-0000-000000000000",
                                "messageID": "message-1",
                                "journeyVersionID": "someJourneyVersionId",
                                "journeyVersionInstanceId": "someJourneyVersionInstanceId"
                            ]
                        ]
                    ]
                ]
            ]
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let identifier = "Simple local notification identifier"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: handleNotificationError(_:))
    }
    
    func scheduleNotificationWithCustomAction() {
        let content = UNMutableNotificationContent()
        content.title = "Custom actions notification"
        content.body = "This notification has custom actions. Click and hold on the notification to show the custom action buttons."
        content.categoryIdentifier = "MEETING_INVITATION"
        
        /// the structure of `userInfo` is the same as you'd see with an actual push message.
        /// the values are made up for demonstration purposes.
        content.userInfo = [
            "_xdm": [
                "cjm": [
                    "_experience": [
                        "customerJourneyManagement": [
                            "messageExecution": [
                                "messageExecutionID": "11111111-1111-1111-1111-111111111111",
                                "messageID": "message-2",
                                "journeyVersionID": "someJourneyVersionId",
                                "journeyVersionInstanceId": "someJourneyVersionInstanceId"
                            ]
                        ]
                    ]
                ]
            ]
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let identifier = "Custom action local notification identifier"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Define the custom actions
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                                                title: "Accept",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
                                                 title: "Decline",
                                                 options: UNNotificationActionOptions(rawValue: 0))
        
        // Define the notification type
        let meetingInviteCategory = UNNotificationCategory(identifier: "MEETING_INVITATION",
                                                           actions: [acceptAction, declineAction],
                                                           intentIdentifiers: [],
                                                           hiddenPreviewsBodyPlaceholder: "",
                                                           options: .customDismissAction)
        
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        notificationCenter.add(request, withCompletionHandler: handleNotificationError(_:))
    }
    
    func handleNotificationError(_ error: Error?) {
        if let error = error {
            print("An error occurred when adding a notification: \(error.localizedDescription)")
        }
    }
}
