//
//  water.swift
//  FitBook

//  Copyright © 2017年 Apple. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define an activity to take
 medication.
 */
struct Water: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .water
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [8, 8, 8, 8, 8, 8, 8])
    // 32
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Drink liquid", comment: "")
        let summary = NSLocalizedString("8 once per circle, total 64 onces perday", comment: "")
        let instructions = NSLocalizedString("Drink liquid about 64 ounce each day, tap one circle each time you drink 8 ounce water.", comment: "")
        
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,
            groupIdentifier: "Diet",
            title: title,
            text: summary,
            tintColor: Colors.blue.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}

