//
//  OnboardingPayload.swift
//  TogglDesktop
//
//  Created by Nghia Tran on 4/1/20.
//  Copyright © 2020 Alari. All rights reserved.
//

import Foundation

/// Represent type of each onboarding
@objc enum OnboardingHint: Int {
    case newUser = 0
    case oldUser
    case manualMode
    case timelineTab
    case editTimeEntry
    case timelineTimeEntry
    case timelineView
    case timelineActivity
    case recordActivity // Use TimelineActivityRecorderViewController instead

    var debuggingName: String {
        switch self {
        case .editTimeEntry: return "editTimeEntry"
        case .manualMode: return "manualMode"
        case .newUser: return "newUser"
        case .oldUser: return "oldUser"
        case .recordActivity: return "recordActivity"
        case .timelineActivity: return "timelineActivity"
        case .timelineTab: return "timelineTab"
        case .timelineTimeEntry: return "timelineTimeEntry"
        case .timelineView: return "timelineView"
        }
    }
}

/// Represent the Tab that the onboarding view will show
@objc enum OnboardingPresentViewTab: Int {
    case timeEntry
    case timeline
}

/// Represent all info that the Onboarding need
struct OnboardingPayload {

    // MARK: Variable

    let title: String
    let hint: OnboardingHint
    let view: NSView

    /// Determine the position of the Popover arrow
    var preferEdges: NSRectEdge {
        switch hint {
        case .newUser,
             .oldUser,
             .editTimeEntry,
             .recordActivity:
            return .minY
        case .timelineTimeEntry,
              .timelineTab,
             .timelineView:
            return .maxY
        case .timelineActivity:
            return .minX
        default: // Fill more later
            return .maxX
        }
    }

    // MARK: Init

    init(hint: OnboardingHint, view: NSView) {
        self.hint = hint
        self.view = view
        switch hint {
        case .editTimeEntry: self.title = "Click on Time Entry to edit it!"
        case .manualMode: self.title = "It’s also possible to add Time Entries manually!\n\nChange to manual mode there..."
        case .newUser: self.title = "Describe your task and start tracking!"
        case .oldUser: self.title = "Start typing to access your tasks"
        case .recordActivity: self.title = "Having trouble recalling what you were working on?"
        case .timelineActivity: self.title = "Your recorded activity will be shown right here"
        case .timelineTab: self.title = "See your Time Entries on Timeline!"
        case .timelineTimeEntry: self.title = "Add and edit Time Entries in this area"
        case .timelineView: self.title = "See all your Time Entries visualised in chronological order! "
        }
    }
}
