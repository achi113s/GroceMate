//
//  IngredientRecognitionHandlerLimits.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/1/24.
//

import Foundation

extension IngredientRecognitionHandler {
    private func allowedToPerformRecognition() -> Bool {
        // Returns 0 if key doesn't exist yet.
        let currentNumberOfCalls = UserDefaults.standard.integer(
            forKey: RecognitionCallLimits.numberOfRecognitionCallsThisPeriod.userDefaultsKey)

        return currentNumberOfCalls < 50
    }

    private func incrementPeriodRecognitionCalls() {
        // Returns 0 if key doesn't exist yet.
        let currentNumberOfCalls = UserDefaults.standard.integer(
            forKey: RecognitionCallLimits.numberOfRecognitionCallsThisPeriod.userDefaultsKey
        )

        UserDefaults.standard.setValue(
            currentNumberOfCalls + 1,
            forKey: RecognitionCallLimits.numberOfRecognitionCallsThisPeriod.userDefaultsKey
        )

        print("numberOfRecognitionCallsThisPeriod incremented to: \(UserDefaults.standard.integer(forKey: RecognitionCallLimits.numberOfRecognitionCallsThisPeriod.userDefaultsKey))")
    }

    private func resetPeriodRecognitionCalls() {
        UserDefaults.standard.setValue(
            0,
            forKey: RecognitionCallLimits.numberOfRecognitionCallsThisPeriod.userDefaultsKey
        )

        print("numberOfRecognitionCallsThisPeriod reset to: \(UserDefaults.standard.integer(forKey: RecognitionCallLimits.numberOfRecognitionCallsThisPeriod.userDefaultsKey))")
    }

    private func setLastResetDateToNow() {
        UserDefaults.standard.setValue(
            Date.now,
            forKey: RecognitionCallLimits.lastResetDate.userDefaultsKey
        )

        if let currentLastResetDate = UserDefaults.standard.object(
            forKey: RecognitionCallLimits.lastResetDate.userDefaultsKey
        ) as? Date {
            print("lastResetDate set to: \(currentLastResetDate)")
        }
    }

    private func resetDateOfFirstRecognitionCallIfNeeded() {
        let calendar = Calendar.current

        // Example date.
        UserDefaults.standard.setValue(
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 10))!,
            forKey: RecognitionCallLimits.lastResetDate.userDefaultsKey
        )

        guard let lastResetDate = UserDefaults.standard.object(
            forKey: RecognitionCallLimits.lastResetDate.userDefaultsKey
        ) as? Date else {
            return
        }

        /* If current date is greater than one month after the
         lastResetDate, reset the numberOfRecognitionCalls to zero.
         Also set the lastResetDate to the current date.
         */

        if Date.now > calendar.date(byAdding: .month, value: 1, to: lastResetDate)! {
            // Reset recognition calls this period to zero.
            resetPeriodRecognitionCalls()

            // Set the lastResetDate to now.
            setLastResetDateToNow()
        }
    }
}
