//
//  PrefactoScreenshots.swift
//  PrefactoScreenshots
//
//  Created by dani on 5/13/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import XCTest

class PrefactoScreenshots: XCTestCase {


    // xcodebuild -testLanguage en -scheme Prefacto -project ./Prefacto.xcodeproj -derivedDataPath '/tmp/PrefactoDerivedData/' -destination "platform=iOS Simulator,name=iPhone 13 Pro Max" build test

    var app: XCUIApplication!

    let aList = ["Check", "Factorize", "List", "Randomize", "Next", "Previous"]

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--prefactoScreenshots")
    }


    func anAction(word: String) {
        let tablesQuery = app.tables
        let aThing = tablesQuery.cells.staticTexts[word]
        XCTAssertTrue(aThing.waitForExistence(timeout: 5))
        aThing.tap()
        let firstTextField = app.textFields.firstMatch
        var textToType = ""
        switch word {
            case "Check":
                textToType = "2351"
            case "Factorize":
                textToType = "2350"
            case "List":
                textToType = "1"
            case "Randomize":
                break
            case "Next":
                textToType = "2350"
            case "Previous":
                textToType = "2350"
            default:
                break
        }

        if word != "Randomize" {
            firstTextField.typeText(textToType)
        }

        takeScreenshot(named: "\(word)-Home")

        if word == "Randomize" {
            app.buttons["Create Random Prime"].firstMatch.tap()
            app.buttons["Medium"].firstMatch.tap()
            takeScreenshot(named: "\(word)-Results")
            app.buttons["Done"].firstMatch.tap()
            app.navigationBars[word].buttons["Prime Number App"].tap()
            return
        }

        app.buttons[word].firstMatch.tap()

        if word == "List" {
            let aAlert = app.alerts.firstMatch
            XCTAssertTrue(aAlert.waitForExistence(timeout: 5))
            app.alerts.buttons.firstMatch.tap() // dismiss alert
            XCTAssertTrue(app.textFields.firstMatch.waitForExistence(timeout: 5))
            app.typeText("2350") // second field should have focus, from swift
            app.buttons[word].firstMatch.tap() // list
        }

        takeScreenshot(named: "\(word)-Results")

        app.buttons["Done"].firstMatch.tap()
        app.navigationBars[word].buttons["Prime Number App"].tap()
    }


    func testMakeScreenshots() {
        app.launch()

        // Home
        takeScreenshot(named: "Home")

        for aItem in aList {
            anAction(word: aItem)
        }
    }


    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()

        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)

        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways

        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }

}
