//
//  ChunksTests.swift
//  Util
//

import Util
import XCTest

class ChunksTests: XCTestCase {
	func testChunks() {
		let array = [0,1, 2,3, 4,5]
		XCTAssertEqual(array.chunks(of: 2).count, 3)
		XCTAssertEqual(array.chunks(of: 2)[0], [0,1])
		XCTAssertEqual(array.chunks(of: 2)[1], [2,3])
		XCTAssertEqual(array.chunks(of: 2)[2], [4,5])
	}
	
	func testChunksWithLeftovers() {
		let array = [0,1, 2,3, 4,5, 6]
		XCTAssertEqual(array.chunks(of: 2).count, 4)
		XCTAssertEqual(array.chunks(of: 2)[0], [0,1])
		XCTAssertEqual(array.chunks(of: 2)[1], [2,3])
		XCTAssertEqual(array.chunks(of: 2)[2], [4,5])
		XCTAssertEqual(array.chunks(of: 2)[3], [6])
	}
	
	func testChunkString() {
		let string = "12345"
		XCTAssertEqual(string.chunks(of: 2).count, 3)
		XCTAssertEqual(string.chunks(of: 2)[0], ["1","2"])
		XCTAssertEqual(string.chunks(of: 2)[1], ["3","4"])
		XCTAssertEqual(string.chunks(of: 2)[2], ["5"])
	}
	
	static var allTests = [
		("testChunks", testChunks),
		("testChunksWithLeftovers", testChunksWithLeftovers),
		("testChunkString", testChunkString),
	]
}
