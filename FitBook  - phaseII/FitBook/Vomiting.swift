

import ResearchKit
import CareKit

/**
 Struct that conforms to the `Assessment` protocol to define a mood
 assessment.
 */
struct Vomiting: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .vomiting
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        //        let thresholds = [OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 7), type: .numericGreaterThan, upperValue: nil, title: "Good mood."), OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 3), type: .numericLessThanOrEqual, upperValue: nil, title: "Bad mood.")] as Array<OCKCarePlanThreshold>
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Vomiting", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: "Yes/No",
            title: title,
            text: nil,
            tintColor: Colors.green.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil,
            //thresholds: [thresholds],
            thresholds: nil,
            optional: false
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        // Get the localized strings to use for the task.
        let question = NSLocalizedString("Do you have vomiting today?", comment: "")
        
        let answerFormat = ORKBooleanAnswerFormat()
        
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: question, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
    }
}
