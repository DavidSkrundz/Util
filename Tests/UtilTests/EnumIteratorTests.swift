//
//  EnumIteratorTests.swift
//  Util
//

import Util
import XCTest

private enum BasicEnum {
	case One
	case Two
	case Three
}

private enum StringEnum: String {
	case One = "1"
	case Two = "2"
	case Three = "3"
}

class EnumIteratorTests: XCTestCase {
	func testBasicEnum() {
		let enums = iterateEnum(BasicEnum.self).toArray()
		XCTAssertEqual(enums.count, 3)
		switch enums[0] {
			case .One: break
			case .Two: XCTFail()
			case .Three: XCTFail()
		}
		switch enums[1] {
			case .One: XCTFail()
			case .Two: break
			case .Three: XCTFail()
		}
		switch enums[2] {
			case .One: XCTFail()
			case .Two: XCTFail()
			case .Three: break
		}
	}
	
	func testStringEnum() {
		let enums = iterateEnum(StringEnum.self).toArray()
		XCTAssertEqual(enums.count, 3)
		switch enums[0] {
			case .One: break
			case .Two: XCTFail()
			case .Three: XCTFail()
		}
		switch enums[1] {
			case .One: XCTFail()
			case .Two: break
			case .Three: XCTFail()
		}
		switch enums[2] {
			case .One: XCTFail()
			case .Two: XCTFail()
			case .Three: break
		}
	}
	
	static var allTests = [
		("testBasicEnum", testBasicEnum),
		("testStringEnum", testStringEnum),
	]
}
