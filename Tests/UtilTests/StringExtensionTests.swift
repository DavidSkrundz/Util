//
//  StringExtensionTests.swift
//  Util
//

@testable import Util
import XCTest

class StringExtensionTests: XCTestCase {
	func testIntIndexing() {
		let string = "123456789"
		XCTAssertEqual(string[3..<5], "45")
	}
	
	func testMapFix() {
		let string = "1234"
		let characters = string.map { $0 }
		XCTAssertEqual(characters, ["1", "2", "3", "4"])
	}
	
	func testEndsWith() {
		let string = "1234"
		XCTAssertTrue(string.endsWith("1234"))
		XCTAssertTrue(string.endsWith("34"))
		XCTAssertTrue(string.endsWith("4"))
		XCTAssertFalse(string.endsWith("1"))
		XCTAssertFalse(string.endsWith("12"))
		XCTAssertFalse(string.endsWith("aeo"))
		XCTAssertFalse(string.endsWith("12341234"))
	}
	
	func testStartsWith() {
		let string = "1234"
		XCTAssertTrue(string.startsWith("1234"))
		XCTAssertFalse(string.startsWith("34"))
		XCTAssertFalse(string.startsWith("4"))
		XCTAssertTrue(string.startsWith("1"))
		XCTAssertTrue(string.startsWith("12"))
		XCTAssertFalse(string.startsWith("aeo"))
		XCTAssertFalse(string.startsWith("12341234"))
	}
	
	static var allTests = [
		("testIntIndexing", testIntIndexing),
		("testMapFix", testMapFix),
		("testEndsWith", testEndsWith),
		("testStartsWith", testStartsWith),
	]
}
