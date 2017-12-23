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
struct Tips: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .tips
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Tips to Prevent Nausea and Dehydration", comment: "")
        let summary = NSLocalizedString("Phase1", comment: "")
        let instructions = NSLocalizedString("Nausea after bariatric surgery can be caused by:\n\n 1.Drinking too fast.\n 2.Drinking too much at one time.\n 3.Because you are beginning to get dehydrated.\n 4.Side effect of certain medications.\n\nSigns that you are becoming dehydrated:\n\n 1.Urine is dark in color.\n 2.You are not urinating as frequently as usual.\n 3.Nausea.\n 4.Lips, mouth and / or skin are dry.\n 5.Skin is flushed.\n 6.Headache or dizziness.\n 7.Thirst.\n 8.Rapid pulse and breathing.\n\nTips:\n\n 1.Sip fluids slowly throughout the day.\n 2.Suck on a popsicle.\n 3.Experiment to see if cold beverages lessen the nausea or if you feel better with beverages at room temperature.\n 4.Sip on broth.\n 5.Suck on ice chips.\n 6.Wait for 30 minutes and start sipping liquids or sucking on a popsicle. Do not use a straw.\n 7.Don’t wait until you are thirsty to drink-up throughout the day.\n 8.If nauseated-try to sip no more than 60 cc/ml per hour.\n\nWhen to call your surgeon:\n\n 1.If you have a fever over 100.4°F.\n 2.Increased redness or drainage from your incision.\n 3.Nausea or vomiting not relieved by the above steps.\n 4.Chest pain or sudden shortness of breath.\n 5.Severe calf pain.\n 6.Pain not relieved by your prescribed pain medicine.", comment: "")
        
        let activity = OCKCarePlanActivity.readOnly(withIdentifier: activityType.rawValue, groupIdentifier: "Tips", title: title, text: summary, instructions: instructions, imageURL: nil, schedule: schedule, userInfo: nil)
        
        return activity
    }
}


