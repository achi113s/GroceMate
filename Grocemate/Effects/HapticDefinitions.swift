//
//  HapticDefinitions.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/23/23.
//

import CoreHaptics

var swipeSuccessHaptic: [CHHapticEvent] = {
    var events = [CHHapticEvent]()

    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    events.append(event)

    return events
}()

var longPressSuccessHaptic: [CHHapticEvent] = {
    var events = [CHHapticEvent]()

    var intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    var sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.0)
    events.append(event1)

    intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
    sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 5)
    let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.1)
    events.append(event2)

    return events
}()
