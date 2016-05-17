//
//  StringExtensions.swift
//  TypeBurritoFramework
//
//  Created by Atai Barkai on 2/2/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

// String extension that enables TypeBurrito to wrap a String type.
extension String: CustomStringConvertible{
	public var description: String {
		return self
	}
}
