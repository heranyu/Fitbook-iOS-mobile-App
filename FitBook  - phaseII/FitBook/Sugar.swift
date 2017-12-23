//
//  Sugar.swift
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
struct Sugar: Assessment, HealthSampleBuilder {
    // MARK: Activity properties
    
    let activityType: ActivityType = .sugar
    
    // MARK: HealthSampleBuilder Properties
    
    let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!
    
    let unit = HKUnit.gram()
    
    // MARK: Activity
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
       /* let thresholds = [
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 1600), type: .numericGreaterThanOrEqual, upperValue: nil, title: "too much calcium! Remember only 2 calcium citrate per day and 1000-1500 mg daily."),
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 1000), type: .numericLessThanOrEqual, upperValue: nil, title: "Not enough calcium! Remember only 2 calcium citrate per day and 1000-1500 mg daily")] as Array<OCKCarePlanThreshold>;*/
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Sugar", comment: "")
        let summary = NSLocalizedString("How much you eat today", comment: "Added sugars should be limited")
        
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
        let title = NSLocalizedString("Input your Sugar", comment: "fruit has naturally occurring sugar")
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
        guard let firstResult = result.firstResult as? ORKStepResult, let CalciumResult = firstResult.results?.first else { fatalError("Unexepected task results") }
        
        // Get the numeric answer for the result.
        guard let calciumResult = CalciumResult as? ORKNumericQuestionResult, let calciumAnswer = calciumResult.numericAnswer else { fatalError("Unable to determine result answer") }
        
        // Create a `HKQuantitySample` for the answer.
        let quantity = HKQuantity(unit: unit, doubleValue: calciumAnswer.doubleValue)
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

