//
//  MonounsaturatedFat.swift
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
struct MonounsaturatedFat: Assessment, HealthSampleBuilder {
    // MARK: Activity properties
    
    let activityType: ActivityType = .monounsaturatedfat
    
    // MARK: HealthSampleBuilder Properties
    
    let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatMonounsaturated)!
    
    let unit = HKUnit.gramUnit(with:.milli)
    
    // MARK: Activity
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        /*let thresholds = [
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 80), type: .numericGreaterThanOrEqual, upperValue: nil, title: "You eat too much today."),
            OCKCarePlanThreshold.numericThreshold(withValue: NSNumber.init(value: 60), type: .numericLessThanOrEqual, upperValue: nil, title: "You can eat more.")] as Array<OCKCarePlanThreshold>;*/
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Monounsaturated Fat", comment: "")
        let summary = NSLocalizedString("How much you eat today", comment: "")

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
        let title = NSLocalizedString("Input your MonounsaturatedFat", comment: "")
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
        let formatterUnit = MassFormatter.Unit.pound
        
        return formatter.unitString(fromValue: value, unit: formatterUnit)
    }
}


