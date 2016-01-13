//
//  Overtyped-String-Tests.swift
//  OvertypedFramework
//
//  Created by Atai Barkai on 1/12/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import OvertypedFramework


struct Name: Overtyped {
	var value: String = ""
}


struct Hometown: Overtyped {
	var value: String = "Unspecified"
}

struct SQLQuery: Overtyped {
	var value: String = ""
}

struct Person {
	var name: Name
	var hometown: Hometown
}


class Overtyped_String_Tests: XCTestCase {
	
	func testOvertypedCompilation() {
		
		func bookCharactersSqlQuery(forHometown hometown: Hometown) -> SQLQuery{
			return SQLQuery("SELECT * FROM BookCharacters WHERE Name = \(hometown);")
		}
		
		func findPersonsByPerformingSQLQuery(sqlQuery: SQLQuery) -> [Person]{
			// perform sql query...
			return [Person(name: Name("Lazas Long"), hometown: Hometown("Basoom"))]
		}
		
		let results = findPersonsByPerformingSQLQuery(bookCharactersSqlQuery(forHometown: Hometown("Basoom")))
		XCTAssert(results.count == 1)
	}

}
