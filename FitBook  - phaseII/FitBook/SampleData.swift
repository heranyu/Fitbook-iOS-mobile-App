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

import ResearchKit
import CareKit

class SampleData: NSObject {
    
    // MARK: Properties

    /// An array of `Activity`s used in the app.
    let activities: [Activity] = [
        // activity
        OutdoorWalk(),
        DietTracker(),
        NauseaMedication(),
        // assessment
        Weight(),
        // yes or no
        Vitamin(),
        Nausea(),
        Vomiting(),
        Diarrhea(),
        Incision(),
        // read only
        Instruction(),
        Tips(),
        //Diet
        Water(),
        Carbohydrates(),
        Sugar(),
        Protein(),
        Fiber(),
        MonounsaturatedFat(),
        PolyunsaturatedFat(),
        SaturatedFat(),
        TotalFat(),
    ]
    /**
     An `OCKPatient` object to assign contacts to.
     */
    
    var patient: OCKPatient
    
    /**
        An array of `OCKContact`s to display on the Connect view.
    */
    let contacts: [OCKContact] = [
        OCKContact(contactType: .careTeam,
            name: "Dr. George Eid",
            relation: "Surgeon",
            contactInfoItems: [OCKContactInfo.phone("412-512-2134"), OCKContactInfo.sms("412-512-2134"), OCKContactInfo.email("george.eid@ahn.org")],
            tintColor: Colors.blue.color,
            monogram: "GE",
            image: nil),
        
        OCKContact(contactType: .careTeam,
            name: "Emily Mitnik",
            relation: "Assistant",
            contactInfoItems: [OCKContactInfo.phone("412-359-5000"), OCKContactInfo.sms("412-359-5000"), OCKContactInfo.email("emily.mitnik@ahn.org")],
            tintColor: Colors.green.color,
            monogram: "EM",
            image: nil),
        
        OCKContact(contactType: .personal,
            name: "William Arbuckle",
            relation: "Father",
            contactInfoItems: [OCKContactInfo.phone("412-555-5511"), OCKContactInfo.sms("412-555-5511")],
            tintColor: Colors.yellow.color,
            monogram: "CG",
            image: nil)
    ]
    
    /**
     Connect message items
     */
    
    let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
    var connectMessageItems = [OCKConnectMessageItem]()
    var contactsWithMessageItems = [OCKContact]()
    
    
    // MARK: Initialization
    
    required init(carePlanStore: OCKCarePlanStore) {
        self.patient = OCKPatient(identifier: "patient", carePlanStore: carePlanStore, name: "Roscoe Arbuckle", detailInfo: nil, careTeamContacts: contacts, tintColor: Colors.lightBlue.color, monogram: "RA", image: nil, categories: nil, userInfo: ["Age": "21", "Gender": "M", "Phone":"412-555-5512"])
        
        for contact in contacts {
            if contact.type == .careTeam {
                contactsWithMessageItems.append(contact)
                self.connectMessageItems = [OCKConnectMessageItem(messageType: OCKConnectMessageType.sent, name: contact.name, message: "I am feeling good after taking the medication! Thank you.", dateString:dateString)]
                break
            }
        }
        
        super.init()

        // Populate the store with the sample activities.
        for sampleActivity in activities {
            let carePlanActivity = sampleActivity.carePlanActivity()
            
            carePlanStore.add(carePlanActivity) { success, error in
                if !success {
                    print(error!.localizedDescription)
                }
            }
        }
        
    }
    
    // MARK: Convenience
    
    /// Returns the `Activity` that matches the supplied `ActivityType`.
    func activityWithType(_ type: ActivityType) -> Activity? {
        for activity in activities where activity.activityType == type {
            return activity
        }
        
        return nil
    }
    func generateSampleDocument(chart: OCKChart?) -> OCKDocument {
        let subtitle = OCKDocumentElementSubtitle(subtitle: "Insights for Weight and Protein")
        
        let paragraph = OCKDocumentElementParagraph(content: "I have been tracking my protein dietary. Please check the attached report to see if I am in the right condition.")
        var documentElements: [OCKDocumentElement] = [paragraph]

        if let chart = chart {
            documentElements.append(OCKDocumentElementChart(chart: chart))
        }
        let document = OCKDocument(title: "Weight and Protein", elements: documentElements)
        document.pageHeader = "App Name: FitBook, Weekly Protein"
        
        return document
    }
}
