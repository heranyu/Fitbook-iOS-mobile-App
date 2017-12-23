//
//  Instruction.swift
//  FitBook
//
//  Copyright © 2017年 Apple. All rights reserved.
//

//
//  water.swift
//  FitBook
//

//  Copyright © 2017年 Apple. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define an activity to take
 medication.
 */
struct Instruction: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .instruction
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Instruction For Phase II Diet: Soft Foods ", comment: "")
        let summary = NSLocalizedString("Phase2", comment: "")
        let instructions = NSLocalizedString("Expect to be in this phase for about four weeks. This phase includes soft, easily digestible foods. These may be slowly introduced into your diet and must be chewed well. Choose soft meats and  sh, soups, cooked vegetables and canned fruit (in juice or water). Remember to choose low-fat or fat-free dairy, lean meats and low- sugar items.\n if you have more questions, please click the link to get the document for more comprehensive instruction :\n https://www.ahn.org/sites/default/files/file/Bariatric/bariatric-nutrition-guidelines.pdf ", comment: "comment")
        
        let activity = OCKCarePlanActivity.readOnly(withIdentifier: activityType.rawValue, groupIdentifier: "Tips", title: title, text: summary, instructions: instructions, imageURL: nil, schedule: schedule, userInfo: nil)
        
        return activity
    }
}


