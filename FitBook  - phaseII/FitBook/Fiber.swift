//
//  Fiber.swift
//  FitBook
//
//  Created by Heran Yu on 9/24/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import ResearchKit
import CareKit

/**
 Struct that conforms to the `Sample` protocol to define a weight assessment.
 */
struct Fiber: Assessment, HealthSampleBuilder {
    
    // MARK: Activity properties
    
    let activityType: ActivityType = .fiber
    
    // MARK: HealthSampleBuilder Properties
    
    let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!
    
    let unit = HKUnit.gram()
    
    // MARK: Activity
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        /*let thresholds = [
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 30), type: .numericGreaterThanOrEqual, upperValue: 50, title: "too much Iron if you are a men or post-menopausal woman! Remember only 1 Iron pill per day and 18- 30 mg daily. If you are a pre-menopausal woman, you should eat more!"),
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 18), type: .numericLessThanOrEqual, upperValue: nil, title: "Not enough Iron!\n Remember only 1 Iron pill per day! 18- 30 mg daily for men and post-menopausal women.\n 50-65 mg per day for pre--menopausal women"),
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 18), type: .numericGreaterThanOrEqual, upperValue: 30, title: "appropriate Iron if you are a man or post-menopausal woman! Remember only 1 Iron pill per day and 18- 30 mg daily. If you are a pre-menopausal woman, you should eat more!"),
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 50), type: .numericGreaterThanOrEqual, upperValue: 65, title: "appropriate Iron if you are a pre-menopausal woman. Too much Iron if you are a men or post-menopausal woman! Remember only 1 Iron pill per day and 18- 30 mg daily."),
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 65), type: .numericGreaterThanOrEqual, upperValue: nil, title: "Too much Iron! Remember only 1 Iron pill per day. 18 - 30 mg daily for men and post-menopausal women.\n 50 - 65 mg per day for pre-menopausal women")
            ] as Array<OCKCarePlanThreshold>;*/
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Fiber", comment: "")
        let summary = NSLocalizedString("How much you eat today", comment: "Fiber from fruits and vegetables at each meal")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: "Diet",
            title: title,
            text: summary,
            tintColor: Colors.yellow.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil,
            thresholds: nil,
            optional: false
        )
        
        return activity
    }
    // MARK: Assessment
    
    func task() -> ORKTask {
        // Get the localized strings to use for the task.
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .decimal)
        
        // Create a question.
        let title = NSLocalizedString("Input your Fiber", comment: "")
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: title, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
    }
    
    // MARK: HealthSampleBuilder
    
    /// Builds a `HKQuantitySample` from the information in the supplied `ORKTaskResult`.
    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample {
        // Get the first result for the first step of the task result.
        guard let firstResult = result.firstResult as? ORKStepResult, let stepResult = firstResult.results?.first else { fatalError("Unexepected task results") }
        
        // Get the numeric answer for the result.
        guard let weightResult = stepResult as? ORKNumericQuestionResult, let weightAnswer = weightResult.numericAnswer else { fatalError("Unable to determine result answer") }
        
        // Create a `HKQuantitySample` for the answer.
        let quantity = HKQuantity(unit: unit, doubleValue: weightAnswer.doubleValue)
        let now = Date()
        
        return HKQuantitySample(type: quantityType, quantity: quantity, start: now, end: now)
    }
    
   
    /**
     Uses an NSMassFormatter to determine the string to use to represent the
     supplied `HKQuantitySample`.
     */
    func localizedUnitForSample(_ sample: HKQuantitySample) -> String {
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.unitStyle = .short
        
        let value = sample.quantity.doubleValue(for: unit)
        let formatterUnit = MassFormatter.Unit.gram
        
        return formatter.unitString(fromValue: value, unit: formatterUnit)
    }
}

