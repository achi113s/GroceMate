//
//  Haptics.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/3/23.
//

import CoreHaptics
import SwiftUI

public enum HapticType {
    case simpleSuccess
    case longPressSuccess
}

/// A class for playing haptics. Using a class allows to create only one
/// haptic engine for the whole app.
class HapticEngine: ObservableObject {
    //MARK: - State
    @Published var hapticEngine: CHHapticEngine?
    
    /// Keep track of when the system stops our haptic engine.
    private var hapticEngineWasStopped: Bool
    
    //MARK: - Properties
    init(hapticEngine: CHHapticEngine? = nil, hapticEngineWasStopped: Bool = false) {
        self.hapticEngine = hapticEngine
        self.hapticEngineWasStopped = hapticEngineWasStopped
    }
    
    lazy var simpleSuccessHaptic: [CHHapticEvent] = {
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        return events
    }()
    
    lazy var longPressSuccessHaptic: [CHHapticEvent] = {
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 0.2, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        return events
    }()
    
    //MARK: - Private Methods
    /// A synchronous function to start the haptic engine.
    private func syncPrepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }
        
        do {
            hapticEngine = try CHHapticEngine()
            
            /// This allows us to know if the haptic engine was
            /// stopped by the system.
            hapticEngine?.stoppedHandler = { [weak self] _ in
                self?.hapticEngineWasStopped = true
            }
            
            try hapticEngine?.start()
            print("Haptic engine started.")
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Public Methods
    /// Play a haptic based on the input haptic type.
    public func playHaptic(_ hapticType: HapticType) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }
        
        if hapticEngine == nil {
            /// When calling this for the first time, there is some lag
            /// due to using the synchronous start() method.
            syncPrepareHaptics()
        } else if hapticEngineWasStopped {
            syncPrepareHaptics()
            hapticEngineWasStopped = false
        }
        
        do {
            var events: [CHHapticEvent] = []
            
            switch hapticType {
            case .simpleSuccess:
                events = simpleSuccessHaptic
            case .longPressSuccess:
                events = longPressSuccessHaptic
            }
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            print("played")
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
