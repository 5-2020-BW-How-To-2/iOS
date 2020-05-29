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
        let user = User(username: "Test", password: "test")
        let expectation = self.expectation(description: "Waiting for Sign Up")
        login.signUp(with: user) { error in
            if let error = error {
                NSLog("Error when signing up: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testSignIn() {
        let login = APIController()
        let user = User(username: "Test", password: "Test")
        let expectation = self.expectation(description: "Waiting for Sign In")
        login.signIn(with: user) { error in
            if let error = error {
                NSLog("Error when signing up: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testCreateUser() {
        let user = User(username: "Chris", password: "12345")
        XCTAssertEqual(user.username, "Chris")
        XCTAssertEqual(user.password, "12345")
    }
    func testFetchLifeHack() {
        let apiController = APIController()
        let expectation = self.expectation(description: "Waiting to fetch life hacks")

        apiController.fetchLifeHacksFromServer { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(APIController.lifeHacksRep?.count, 4)
    }
    func testMyFetchLifeHack() {
        let apiController = APIController()
        let expectation = self.expectation(description: "Waiting to fetch my life hacks")
        apiController.fetchMyLifeHacksFromServer { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(APIController.lifeHacksRep?.count, 0)
    }
    
}
