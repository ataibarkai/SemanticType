//
//  Stringish.swift
//  T-CIMB
//
//  Created by Atai Barkai on 1/6/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation


// String extension that enables Overtyped to wrap a String type.
extension String: CustomStringConvertible{
	public var description: String {
		return self
	}
}

//// We cannot extend Overtyped specifically for values of type String, so we
//// create a new protocol, and make String conform to it
//protocol StringOnlyProtocol {}
//extension String: StringOnlyProtocol {}
//
//extension Overtyped where Self.UnderlyingValueType: StringOnlyProtocol {
//	
//}