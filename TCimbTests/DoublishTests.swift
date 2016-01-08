//
//  DoublishTests.swift
//  TCIMB
//
//  Created by Atai Barkai on 1/6/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TCimb

struct kg: Doublish{
	var value: Double = 0
}

struct meters: Doublish{
	var value: Double = 0
}

class DoublishTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDoublishCreation() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
