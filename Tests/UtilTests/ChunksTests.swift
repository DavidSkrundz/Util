//
//  ChunksTests.swift
//  Util
//

@testable import Util
import XCTest

class ChunksTests: XCTestCase {
	func testChunks() {
		let array = [0,1, 2,3, 4,5]
		XCTAssertEqual(array.chunksOf(2).count, 3)
		XCTAssertEqual(array.chunksOf(2)[0], [0,1])
		XCTAssertEqual(array.chunksOf(2)[1], [2,3])
		XCTAssertEqual(array.chunksOf(2)[2], [4,5])
	}
	
	func testChunksWithLeftovers() {
		let array = [0,1, 2,3, 4,5, 6]
		XCTAssertEqual(array.chunksOf(2).count, 4)
		XCTAssertEqual(array.chunksOf(2)[0], [0,1])
		XCTAssertEqual(array.chunksOf(2)[1], [2,3])
		XCTAssertEqual(array.chunksOf(2)[2], [4,5])
		XCTAssertEqual(array.chunksOf(2)[3], [6])
	}
	
	static var allTests = [
		("testChunks", testChunks),
		("testChunksWithLeftovers", testChunksWithLeftovers),
	]
}
