////
////  DoublishTests.swift
////  TCIMB
////
////  Created by Atai Barkai on 1/6/16.
////  Copyright © 2016 Atai Barkai. All rights reserved.
////
//
//import XCTest
//@testable import OvertypedFramework
//
//struct Kg: Doublish{
//	var value: Double = 0
//}
//
//struct Meters: Doublish{
//	var value: Double = 0
//}
//
//class DoublishTests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//	
//	
//
//    func testDoublishComparison() {
//		
//		let massOfMacbook = Kg(1.2)
//		let massOfPerson = Kg(90.2)
//		
//		
//		let lengthOfMacbook = Meters(0.3)
//		let lengthOfPerson = Meters(1.87)
//		
//		// can compare Kg to Kg
//		if(massOfMacbook < massOfPerson) {
//			print("all good")
//		}
//		else{
//			XCTFail("Doublish ordering is wrong")
//		}
//		
//		// can compare Meters to Meters
//		if(lengthOfMacbook < lengthOfPerson) {
//			print("all good")
//		}
//		else{
//			XCTFail("Doublish ordering is wrong")
//		}
//		
//		// cannot compare Kg to Meters
//		// should be a compile-time error:
////		if(massOfPerson < lengthOfPerson){
////			
////		}
//    }
//
//}
