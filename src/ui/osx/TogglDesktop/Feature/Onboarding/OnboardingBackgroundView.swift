//
//  OnboardingBackgroundView.swift
//  TogglDesktop
//
//  Created by Nghia Tran on 4/3/20.
//  Copyright © 2020 Alari. All rights reserved.
//

import Cocoa

protocol OnboardingBackgroundViewDelegate: class {
    func onboardingBackgroundDidClick(_ sender: OnboardingBackgroundView, onHighlightedArea: Bool, event: NSEvent)
}

/// Responsible for the background of the onboarding view
final class OnboardingBackgroundView: NSView {

    // MARK: Variable

    weak var delegate: OnboardingBackgroundViewDelegate?
    private lazy var maskLayer = CAShapeLayer()
    private lazy var backgroundColor: NSColor = {
        if #available(OSX 10.13, *) {
            return NSColor(named: NSColor.Name("onboarding-background-color"))!
        } else {
            return NSColor(calibratedWhite: 0, alpha: 0.5)
        }
    }()
    private var maskFrame: CGRect?

    // MARK: Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initCommon()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initCommon()
    }

    // MARK: Public

    /// Draw the grey background, except the view that the Onboarding is pointing to
    /// - Parameter frame: the frame of the view
    func drawMask(at frame: CGRect) {
        maskFrame = frame

        // Create a bezier path
        let path = NSBezierPath(rect: frame)
        path.append(NSBezierPath(rect: bounds))

        //TODO: Find the way to support 4 rounded corners
        // For some reasons, the NSBezierPath is skew
        // https://github.com/toggl-open-source/toggldesktop/issues/4106

        // Set mask
        maskLayer.path = path.cgPath
        layer?.mask = maskLayer
    }

    override func mouseDown(with event: NSEvent) {
        let clickedPoint = convert(event.locationInWindow, from: nil)

        // pass the click action to the below view if it's in the mask area
        var onHighlightedArea = false
        if let maskFrame = maskFrame,
            maskFrame.contains(clickedPoint) {
            onHighlightedArea = true
            super.mouseDown(with: event)
        }

        delegate?.onboardingBackgroundDidClick(self, onHighlightedArea: onHighlightedArea, event: event)
    }
}

// MARK: Private

extension OnboardingBackgroundView {

    private func initCommon() {
        wantsLayer = true
        layer?.backgroundColor = backgroundColor.cgColor
        maskLayer.backgroundColor = NSColor.white.cgColor
        maskLayer.fillRule = .evenOdd // invert mask
    }
}
