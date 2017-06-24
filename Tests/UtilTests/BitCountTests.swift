//
//  BitCountTests.swift
//  Util
//

import Util
import XCTest

class BitCountTests: XCTestCase {
	func testZero() {
		XCTAssertEqual(0.bitCount(), 0)
	}
	
	func testIntMax() {
		XCTAssertEqual(UInt8(255).bitCount(), 8)
	}
	
	func testTwoBits() {
		XCTAssertEqual(17.bitCount(), 2)
	}
	
	static var allTests = [
		("testZero", testZero),
		("testIntMax", testIntMax),
		("testTwoBits", testTwoBits),
	]
}
