//
//  How_ToTests.swift
//  How ToTests
//
//  Created by Chris Dobek on 5/26/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import How_To

class HowToTests: XCTestCase {

    func testSignUp() {
        let login = APIController()
        let user = User()

        let expectation = self.expectation(description: "Waiting for Sign In")
        login.signUp(with: user) { error in
            if let error = error {
                NSLog("Error when signing up: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
