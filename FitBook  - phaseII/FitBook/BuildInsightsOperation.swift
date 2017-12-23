/*
 Copyright (c) 2017, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CareKit

class BuildInsightsOperation: Operation {
    
    // MARK: Properties
    
//    var medicationEvents: DailyEvents?
//    var painEvents: DailyEvents?
    var calorieEvents: DailyEvents?
    var exerciseEvents: DailyEvents?
    var weightEvents: DailyEvents?
    var proteinEvents: DailyEvents?
    var drinkEvents: DailyEvents?
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
    
    // MARK: NSOperation
    
    override func main() {
        // Do nothing if the operation has been cancelled.
        guard !isCancelled else { return }
        
        // Create an array of insights.
        var newInsights = [OCKInsightItem]()
        
        
//        if let insight = createMedicationAdherenceInsight() {
//            newInsights.append(insight)
//        }
       if let insight = createExerciseInsight() {
            newInsights.append(insight)
       }
        if let insight = createDrinkInsight() {
            newInsights.append(insight)
        }

       //if let insight = createProteinInsight() {
         //   newInsights.append(insight)
        //}
//
   // if let insight = createWeightInsight() {
          // newInsights.append(insight)
        //}
       if let insight = createWeightInsight2() {
            newInsights.append(insight)
        }
       if let insight = createWeightInsight3() {
           newInsights.append(insight)
        }

        if !newInsights.isEmpty {
            insights = newInsights
        }
    }
    
    // MARK: Convenience
    
    func createExerciseInsight() -> OCKInsightItem? {
     // Make sure there are events to parse.
     guard let exerciseEvents = exerciseEvents else { return nil }
     
     // Determine the start date for the previous week.
     let calendar = Calendar.current
     let now = Date()
     
     var components = DateComponents()
     components.day = -7
     let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
     
     var totalEventCount = 0
     var completedEventCount = 0
     
     for offset in 0..<7 {
     components.day = offset
     let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
     let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
     let eventsForDay = exerciseEvents[dayComponents]
     
     totalEventCount += eventsForDay.count
     
     for event in eventsForDay {
     if event.state == .completed {
     completedEventCount += 1
     }
     }
     }
     
     guard totalEventCount > 0 else { return nil }
     
     // Calculate the percentage of completed events.
     let medicationAdherence = Float(completedEventCount) / Float(totalEventCount)
     
     // Create an `OCKMessageItem` describing medical adherence.
     let percentageFormatter = NumberFormatter()
     percentageFormatter.numberStyle = .percent
     let formattedAdherence = percentageFormatter.string(from: NSNumber(value: medicationAdherence))!
     
     let insight = OCKMessageItem(title: "Exercise", text: "You finished \(formattedAdherence) of your exercise plan last week.", tintColor: Colors.pink.color, messageType: .tip)
     
     return insight
     }
    
    func createDrinkInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let drinkEvents = drinkEvents else { return nil }
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -7
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in 0..<7 {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = drinkEvents[dayComponents]
            
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let medicationAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: medicationAdherence))!
        
        let insight = OCKMessageItem(title: "Drink", text: "You finished \(formattedAdherence) of your drink plan last week.", tintColor: Colors.pink.color, messageType: .tip)
        
        return insight
    }
    
    
    func createWeightInsight2() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let proteinEvents = proteinEvents,
            let weightEvents = weightEvents else { return nil }
        
        
        // Determine the date to start pain/medication comparisons from.
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -7
        
        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
        
        // Create formatters for the data.
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
        
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        
        /*
         Loop through 7 days, collecting medication adherance and pain scores
         for each.
         */
        var proteinValues = [Float]()
        var proteinLabels = [String]()

        var weightValues = [Float]()
        var weightLabels = [String]()
        
        var axisTitles = [String]()
        var axisSubtitles = [String]()
        
        for offset in 0..<7 {
            // Determine the day to components.
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            
            // Store the weight result for the current day.
            if let weightResult = weightEvents[dayComponents].first?.result, let score = Float(weightResult.valueString) , score > 0 {
                weightValues.append(score)
                weightLabels.append(weightResult.valueString)
            }
            else {
                weightValues.append(0)
                weightLabels.append(NSLocalizedString("N/A", comment: ""))
            }
            
            
            
            // Store the calories result for the current day.
            if let proteinResult = proteinEvents[dayComponents].first?.result, let score = Float(proteinResult.valueString) , score > 0 {
                proteinValues.append(score)
                proteinLabels.append(proteinResult.valueString)
            }
            else {
                proteinValues.append(0)
                proteinLabels.append(NSLocalizedString("N/A", comment: ""))
            }
            
            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
        }
        
        // Create a `OCKBarSeries` for each set of data.
        let weightBarSeries = OCKBarSeries(title: "Weight", values: weightValues as [NSNumber], valueLabels: weightLabels, tintColor: Colors.blue.color)
        
        let proteinBarSeries = OCKBarSeries(title: "Protein", values: proteinValues as [NSNumber], valueLabels: proteinLabels, tintColor: Colors.green.color)
        /*
         Add the series to a chart, specifing the scale to use for the chart
         rather than having CareKit scale the bars to fit.
         */
        let chart = OCKBarChart(title: "Weight and Protein per day",
                                text: nil,
                                tintColor: UIColor.green,
                                axisTitles: axisTitles,
                                //axisSubtitles: axisSubtitles,
                                axisSubtitles:nil,
                                // weightBarSeries exerciseBarSeries calorieBarSeries
                                dataSeries: [proteinBarSeries,weightBarSeries],
                                minimumScaleRangeValue: 0,
                                maximumScaleRangeValue: 100)
        
        return chart
    }

    func createWeightInsight3() -> OCKInsightItem? {
        // Make sure there are events to parse.
        // guard let calorieEvents = calorieEvents,
        guard let proteinEvents = proteinEvents,
            let weightEvents = weightEvents else { return nil }
        
        
        // Determine the date to start pain/medication comparisons from.
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -28 // 1 months
        
        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
        
        // Create formatters for the data.
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
        
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        
        /*
         Loop through 7 days, collecting medication adherance and pain scores
         for each.
         */
        //var calorieEventsValues = [Float]()
        //var calorieEventsLabels = [String]()
        var proteinValues = [Float]()
        var proteinLabels = [String]()
        var weightValues = [Float]()
        var weightLabels = [String]()
        
        var axisTitles = [String]()
        var axisSubtitles = [String]()
        
        for offset1 in 1..<5 {
            // Determine the day to components.
            //components.day = offset1 * 7
            let weekStart = calendar.date(byAdding: components as DateComponents, to: startDate)!
            
            var weightSum : Float = 0
            var weightCount : Float = 0
            var proteinSum : Float = 0 // total times of exercise tasks
            var proteinCount : Float = 0 // how many task completed
            
            for offset2 in 0..<7 {
                components.day = offset1 * 7 + offset2
                let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
                let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            
                // Store the weight result for the current day.
                
                if let result = weightEvents[dayComponents].first?.result, let score = Float(result.valueString) , score > 0 {
                    //weightValues.append(score)
                    //weightLabels.append(result.valueString)
                    weightSum = weightSum + score
                    weightCount += 1
                }
//                else {
//                    weightValues.append(0)
//                    weightLabels.append(NSLocalizedString("N/A", comment: ""))
//                }
            
                // Store the exercise adherance value for the current day.
                if let result = proteinEvents[dayComponents].first?.result, let score = Float(result.valueString) , score > 0 {
                    // Scale the adherance to the same 0-150 scale as pain values.
                    // let scaledAdeherence = adherence
                    
                
                    //exerciseValues.append(scaledAdeherence)
                    //exerciseLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                    proteinSum += score
                    proteinCount += 1
                }
//                else {
//                    exerciseValues.append(0.0)
//                    exerciseLabels.append(NSLocalizedString("N/A", comment: ""))
//                }
            
            }
            
//            weightValues.append(weightSum / weightCount)
//            weightLabels.append(String(weightSum / weightCount))
//            exerciseValues.append(exerciseSum / exerciseCount)
//            exerciseLabels.append(percentageFormatter.string(from: NSNumber(value: exerciseSum / exerciseCount))!)
            if (weightSum == 0.0) {
                weightValues.append(0)
                weightLabels.append(NSLocalizedString("N/A", comment: ""))
            } else {
                let weight : Float = (weightSum / weightCount)
                weightValues.append(weight)
                weightLabels.append(String(weight))
            }
            if (proteinCount == 0) {
                proteinValues.append(0)
                proteinLabels.append(NSLocalizedString("N/A", comment: ""))
            } else {
                let protein : Float = Float(proteinSum)/Float(proteinCount)
                proteinValues.append(protein)
                proteinLabels.append(String(protein))
            }

            axisTitles.append(dayOfWeekFormatter.string(from: weekStart))
            axisSubtitles.append(shortDateFormatter.string(from: weekStart))
        }
        
        // Create a `OCKBarSeries` for each set of data.
        let weightBarSeries = OCKBarSeries(title: "Weight", values: weightValues as [NSNumber], valueLabels: weightLabels, tintColor: Colors.blue.color)
        let proteinBarSeries = OCKBarSeries(title: "Protein", values: proteinValues as [NSNumber], valueLabels: proteinLabels, tintColor: Colors.red.color)
        
        /*
         Add the series to a chart, specifing the scale to use for the chart
         rather than having CareKit scale the bars to fit.
         */
        let chart = OCKBarChart(title: "Weekly average Weight and Protein",
                                text: nil,
                                tintColor: Colors.blue.color,
                                axisTitles: axisTitles,
                                axisSubtitles: axisSubtitles,
                                dataSeries: [weightBarSeries, proteinBarSeries],
                                minimumScaleRangeValue: 0,
                                maximumScaleRangeValue:200)
        
        return chart
    }
    
    /**
        For a given array of `OCKCarePlanEvent`s, returns the percentage that are
        marked as completed.
    */
    fileprivate func percentageEventsCompleted(_ events: [OCKCarePlanEvent]) -> Float? {
        guard !events.isEmpty else { return nil }
        
        let completedCount = events.filter({ event in
            event.state == .completed
        }).count
     
        return Float(completedCount) / Float(events.count)
    }
    fileprivate func timesEventsCompleted(_ events: [OCKCarePlanEvent]) -> Int? {
        guard !events.isEmpty else { return nil }
        
        let completedCount = events.filter({ event in
            event.state == .completed
        }).count
        
        return completedCount
    }
}

/**
 An extension to `SequenceType` whose elements are `OCKCarePlanEvent`s. The
 extension adds a method to return the first element that matches the day
 specified by the supplied `NSDateComponents`.
 */
extension Sequence where Iterator.Element: OCKCarePlanEvent {
    
    func eventForDay(_ dayComponents: NSDateComponents) -> Iterator.Element? {
        for event in self where
                event.date.year == dayComponents.year &&
                event.date.month == dayComponents.month &&
                event.date.day == dayComponents.day {
            return event
        }
        
        return nil
    }
}
