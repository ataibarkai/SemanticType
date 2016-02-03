//
//  FailableTypeBurrito-String.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 2/2/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import TypeBurritoFramework

class FailableTypeBurrito_String: XCTestCase {

	typealias HebrewCharactersOnlyString = FailableTypeBurrito<_HebrewCharactersOnlyString>
	enum _HebrewCharactersOnlyString: FailableTypeBurritoSpec {
		typealias TheTypeInsideTheBurrito = String
		
		static func gatewayMap(preMap: TheTypeInsideTheBurrito) -> TheTypeInsideTheBurrito?{
			
			func stringContainsOnlyHebrewCharacters(str: String) -> Bool{
				func charIsHebrew(char: Character) -> Bool{
					return (char >= "א" && char <= "ת")
				}
				
				for char in str.characters {
					if !charIsHebrew(char){
						return false
					}
				}
				return true
			}
			
			return stringContainsOnlyHebrewCharacters(preMap) ? preMap : nil
		}
	}
	
	func testFailabilityOfFailableTypeBurrito() {
		
		let hebrewCharsOnlyString = "שלוםעולם"
		let hewbrewCharsAndSpaceString = "שלום עולם"
		let englishCharsAndSpaceString = "Hello world"
		
		XCTAssertNotNil(HebrewCharactersOnlyString(hebrewCharsOnlyString))
		XCTAssertNil(HebrewCharactersOnlyString(hewbrewCharsAndSpaceString))
		XCTAssertNil(HebrewCharactersOnlyString(englishCharsAndSpaceString))
		
	}
	
	
}
