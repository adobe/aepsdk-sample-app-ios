/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import SwiftUI

class PlacesViewController: UIHostingController<PlacesView> {}

struct PlacesView: View {
    @State var monitoringStatus = "Not Monitoring"
    @State var monitoringType = "Not Monitoring"
    @State var currentLocation = "Unknown"
    @State var lastKnownLocation = "Unknown"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Monitoring Status: ")
                Text(monitoringStatus)
            }
            HStack {
                Text("Monitoring Type: ")
                Text(monitoringType)
            }
            HStack {
                Text("Current Location: ")
                Text(currentLocation)
            }
            HStack {
                Text("Last Known Location: ")
                Text(lastKnownLocation)
            }
            HStack {
                Button(action: {
//                    ACPPlacesMonitor.start()
//                    ACPPlacesMonitor.setRequestAuthorizationLevel(.requestMonitorAuthorizationLevelAlways)
                    self.monitoringType = "Monitoring Always"
                    self.monitoringStatus = "Monitoring Now"
                    
                }){
                    Text("Start Monitoring")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
                Button(action: {
//                    ACPPlacesMonitor.stop(true)
                    self.monitoringType = "Monitoring Stopped"
                    self.monitoringStatus = "Monitoring Stopped"
                }) {
                    Text("Stop Monitoring")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
            }
            HStack {
                Button(action: {
//                    ACPPlacesMonitor.setRequestAuthorizationLevel(.requestMonitorAuthorizationLevelAlways)
                    self.monitoringType = "Monitoring Always"
                    self.monitoringStatus = "Monitoring Now"
                }){
                    Text("Monitor Always")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
                Button(action: {
//                    ACPPlacesMonitor.setRequestAuthorizationLevel(.monitorRequestAuthorizationLevelWhenInUse)
                    self.monitoringType = "Monitor while using"
                    self.monitoringStatus = "Monitoring Now"
                }) {
                    Text("Monitor While Using")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
            }
            HStack {
                Button(action: {
//                    ACPPlaces.getCurrentPoints(ofInterest: { placesPOIS in
//                        if let placesPOIS = placesPOIS {
//                            for poi in placesPOIS {
//                                self.currentLocation = poi.name ?? ""
//                            }
//                        }
//                    })
//                    ACPPlaces.getLastKnownLocation({ location in
//                        let latitude = location?.coordinate.latitude ?? 0.0
//                        let longitude = location?.coordinate.longitude ?? 0.0
//                        self.lastKnownLocation = "latitude:\(latitude), longitude: \(longitude)"
//                    })
                    
                }){
                    Text("Current Location")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
            }
        }.padding()
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView()
    }
}
