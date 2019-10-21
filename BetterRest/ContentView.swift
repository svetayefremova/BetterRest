//
//  ContentView.swift
//  BetterRest
//
//  Created by Yes on 19.10.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 7.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
        
//    let now = Date()
//    let tomorrow = Date().addingTimeInterval(86400)
//    let range = now ... tomorrow
    
    var body: some View {
        NavigationView {
            Form {
                Text("Your ideal bedtime is.. \(idealBedTime)")
                Section(header: Text("When do you want to wake up?").font(.headline)) {
                    DatePicker("Please enter the time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }

                
                 //VStack(alignment: .leading, spacing: 0) {
                 // Text("Desired amount of sleep")
                Section(header: Text("Desired amount of sleep").font(.headline)) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                       Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                   
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("Dayly coffee intake")
//                        .font(.headline)
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
                Section {
                    Picker("Dayly coffee intake", selection: $coffeeAmount) {
                        ForEach(1..<20) { number in
                            if number == 1 {
                                Text("1 cup")
                            } else {
                                Text("\(number) cups")
                            }
                        }
                    }

                }
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                Button(action: calculateBedTime) {
//                    Text("Calculate")
//                }
//            )
                
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var idealBedTime: String {
        let model = Sleep()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Error"
        }
    }
    
//  ---WITH ALERT AND NAVIGATION BUTTON ---
//    func calculateBedTime() {
//        let model = Sleep()
//
//        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//
//        do {
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is..."
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bed time"
//        }
//
//        showingAlert = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
