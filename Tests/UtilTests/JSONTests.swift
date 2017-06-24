//
//  JSONTests.swift
//  Util
//

import Util
import XCTest

class JSONTests: XCTestCase {
	func testSimpleString() {
		let json = try! JSON(from: "\"string\"")
		XCTAssertEqual(json.toString(), "string")
	}
	
	func testUnicodeString() {
		let json = try! JSON(from: "\"🍁🇨🇦\"")
		XCTAssertEqual(json.toString(), "🍁🇨🇦")
	}
	
	func testEscapeCharacters() {
		let json = try! JSON(from: "\"\\\"\\\\\\/\\b\\f\\n\\r\\t\\u2708\"")
		XCTAssertEqual(json.toString(), "\"\\/\u{8}\u{C}\n\r\t✈")
	}
	
	func testInteger() {
		let json = try! JSON(from: "123")
		XCTAssertEqual(json.toDouble(), 123)
	}
	
	func testNegativeInteger() {
		let json = try! JSON(from: "-123")
		XCTAssertEqual(json.toDouble(), -123)
	}
	
	func testDouble() {
		let json = try! JSON(from: "1.23")
		guard case JSON.number(let jsonNumber) = json else { XCTFail(); return }
		XCTAssertEqual(jsonNumber, 1.23)
	}
	
	func testExponentDouble() {
		let json = try! JSON(from: "1.23E-2")
		XCTAssertEqual(json.toDouble(), 0.0123)
	}
	
	func testBool() {
		let json = try! JSON(from: "false")
		XCTAssertEqual(json.toBool(), false)
	}
	
	func testEmptyArray() {
		let json = try! JSON(from: "[]")
		guard case JSON.array(let jsonArray) = json else { XCTFail(); return }
		XCTAssertEqual(jsonArray.count, 0)
	}
	
	func testArrayOfOne() {
		let json = try! JSON(from: "[\"first\"]")
		guard case JSON.array(let jsonArray) = json else { XCTFail(); return }
		XCTAssertEqual(jsonArray.count, 1)
		guard case JSON.string(let first) = jsonArray[0] else { XCTFail(); return }
		XCTAssertEqual(first, "first")
	}
	
	func testArray() {
		let json = try! JSON(from: "[\"first\", 5.2, []]")
		guard case JSON.array(let jsonArray) = json else { XCTFail(); return }
		XCTAssertEqual(jsonArray.count, 3)
		guard case JSON.string(let first) = jsonArray[0] else { XCTFail(); return }
		guard case JSON.number(let second) = jsonArray[1] else { XCTFail(); return }
		guard case JSON.array(let third) = jsonArray[2] else { XCTFail(); return }
		XCTAssertEqual(first, "first")
		XCTAssertEqual(second, 5.2)
		XCTAssertEqual(third.count, 0)
	}
	
	func testEmptyObject() {
		let json = try! JSON(from: "{}")
		guard case JSON.object(let jsonObject) = json else { XCTFail(); return }
		XCTAssertEqual(jsonObject.keys.count, 0)
	}
	
	func testObject() {
		let json = try! JSON(from: "{\"key\":\"value\"}")
		guard case JSON.object(let jsonObject) = json else { XCTFail(); return }
		XCTAssertEqual(jsonObject.keys.count, 1)
		guard case JSON.string(let value) = jsonObject["key"]! else { XCTFail(); return }
		XCTAssertEqual(value, "value")
	}
	
	func testWhitespace() {
		let json = try! JSON(from: "  \t  \n {   \"key\" \t\n :\n\t\t\"value\"  } \n")
		guard case JSON.object(let jsonObject) = json else { XCTFail(); return }
		XCTAssertEqual(jsonObject.keys.count, 1)
		guard case JSON.string(let value) = jsonObject["key"]! else { XCTFail(); return }
		XCTAssertEqual(value, "value")
	}
	
	func testSerializing() {
		let json = JSON.object([
			"a" : .object([
				"g" : .object([:]),
				"h" : .string(""),
				"i" : .null,
			]),
			"b" : .array([
				.array([]),
				.bool(true),
				.number(10),
			]),
			"c" : .string("c"),
			"d" : .number(2.23),
			"e" : .bool(false),
			"f" : .null,
		])
		XCTAssertEqual(json.encode(), "{\"a\":{\"g\":{},\"h\":\"\",\"i\":null},\"b\":[[],true,10],\"c\":\"c\",\"d\":2.23,\"e\":false,\"f\":null}")
		XCTAssertEqual(json.encode(pretty: true), "{\n\t\"a\": {\n\t\t\"g\": {},\n\t\t\"h\": \"\",\n\t\t\"i\": null\n\t},\n\t\"b\": [\n\t\t[],\n\t\ttrue,\n\t\t10\n\t],\n\t\"c\": \"c\",\n\t\"d\": 2.23,\n\t\"e\": false,\n\t\"f\": null\n}")
	}
	
	static var allTests = [
		("testSimpleString", testSimpleString),
		("testUnicodeString", testUnicodeString),
		("testEscapeCharacters", testEscapeCharacters),
		("testInteger", testInteger),
		("testNegativeInteger", testNegativeInteger),
		("testDouble", testDouble),
		("testExponentDouble", testExponentDouble),
		("testBool", testBool),
		("testEmptyArray", testEmptyArray),
		("testArrayOfOne", testArrayOfOne),
		("testArray", testArray),
		("testEmptyObject", testEmptyObject),
		("testObject", testObject),
		("testSerializing", testSerializing),
	]
}
