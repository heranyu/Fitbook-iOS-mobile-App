//
//  DietTracker.swift
//  FitBook

//  Copyright © 2017年 Apple. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define an activity to take
 medication.
 */
struct DietTracker: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .dietTracker
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Use MyFitnessPal", comment: "")
        let summary = NSLocalizedString("track your diet", comment: "")
        let instructions = NSLocalizedString("Using MyFitnessPal is a simple method to keep track of your diet.\n\nAvoid frequent snacking or grazing between meals. This will result in the inability to lose an adequate amount of weight. Patients who succeed in keeping their weight off tend to pay attention to their food choices and portion sizes, as well as increasing their physical activity.", comment: "")
        
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,
            groupIdentifier: "Diet",
            title: title,
            text: summary,
            tintColor: Colors.red.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}


