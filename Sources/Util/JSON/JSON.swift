//
//  JSON.swift
//  Util
//

// http://www.json.org

public enum JSON {
	case string(String)
	case number(Double)
	case object([String : JSON])
	case array([JSON])
	case bool(Bool)
	case null
	
	/// Decode a JSON String
	public init(from string: String) throws {
		self = try JSON.decode(string)
	}
	
	private static func decode(_ string: String) throws -> JSON {
		var gen = string.generator()
		self.skipWhitespace(&gen)
		let json = try self.parseValue(&gen)
		self.skipWhitespace(&gen)
		if gen.hasNext { throw JSONError.InvalidJSON }
		return json
	}
	
	private static func skipWhitespace(_ gen: inout Generator<String>) {
		while " \t\n\r\r\n".contains(gen.peek() ?? ".") { gen.advance() }
	}
	
	private static func parseValue(_ gen: inout Generator<String>) throws -> JSON {
		switch gen.peek() ?? "." {
			case "{": return try self.parseObject(&gen)
			case "[": return try self.parseArray(&gen)
			case "\"": return try self.parseString(&gen)
			case "-": fallthrough
			case "0"..."9": return try self.parseNumber(&gen)
			case "t": fallthrough
			case "f": return try self.parseBool(&gen)
			case "n": return try self.parseNull(&gen)
			default: throw JSONError.InvalidJSON
		}
	}
	
	private static func parseObject(_ gen: inout Generator<String>) throws -> JSON {
		guard gen.next() == "{" else { throw JSONError.InvalidJSON }
		self.skipWhitespace(&gen)
		if gen.peek() == "}" {
			gen.advance()
			return .object([:])
		}
		let kv = try self.parseKV(&gen)
		var values = [kv.0 : kv.1]
		self.skipWhitespace(&gen)
		while let next = gen.next() {
			if next == "}" {
				return .object(values)
			} else if next == "," {
				self.skipWhitespace(&gen)
				let kv = try self.parseKV(&gen)
				values[kv.0] = kv.1
				self.skipWhitespace(&gen)
			} else { break }
		}
		throw JSONError.InvalidJSON
	}
	
	private static func parseKV(_ gen: inout Generator<String>) throws -> (String, JSON) {
		guard case JSON.string(let string) = try self.parseString(&gen) else {
			throw JSONError.InvalidJSON
		}
		self.skipWhitespace(&gen)
		guard gen.next() == ":" else { throw JSONError.InvalidJSON }
		self.skipWhitespace(&gen)
		let json = try self.parseValue(&gen)
		return (string, json)
	}
	
	private static func parseArray(_ gen: inout Generator<String>) throws -> JSON {
		guard gen.next() == "[" else { throw JSONError.InvalidJSON }
		self.skipWhitespace(&gen)
		if gen.peek() == "]" {
			gen.advance()
			return .array([])
		}
		var elements = [try self.parseValue(&gen)]
		self.skipWhitespace(&gen)
		while let next = gen.next() {
			if next == "]" {
				return .array(elements)
			} else if next == "," {
				self.skipWhitespace(&gen)
				elements.append(try self.parseValue(&gen))
				self.skipWhitespace(&gen)
			} else { break }
		}
		throw JSONError.InvalidJSON
	}
	
	private static func parseString(_ gen: inout Generator<String>) throws -> JSON {
		guard gen.next() == "\"" else { throw JSONError.InvalidJSON }
		var string = ""
		while let next = gen.next() {
			if next == "\"" {
				return .string(string)
			} else if next == "\\" {
				guard let esc = gen.next() else { throw JSONError.InvalidJSON }
				switch esc {
					case "\"": string.append("\"")
					case "\\": string.append("\\")
					case "/": string.append("/")
					case "b": string.append("\u{8}")
					case "f": string.append("\u{C}")
					case "n": string.append("\n")
					case "r": string.append("\r")
					case "t": string.append("\t")
					case "u":
						let next4 = String(gen.next(4))
						guard next4.characters.count == 4,
							let number = Int(next4, radix: 16),
							let scalar = UnicodeScalar(Int(number)) else {
								throw JSONError.InvalidJSON
						}
						string.append(Character(scalar))
					default: throw JSONError.InvalidJSON
				}
			} else {
				string.append(next)
			}
		}
		throw JSONError.InvalidJSON
	}
	
	private static func parseNumber(_ gen: inout Generator<String>) throws -> JSON {
		var numericString = ""
		if gen.peek() == "-" { numericString.append(gen.next()!) }
		if gen.peek() == "0" {
			numericString.append(gen.next()!)
		} else {
			guard let firstDigit = gen.next() else { throw JSONError.InvalidJSON }
			guard ("0"..."9").contains(firstDigit) else { throw JSONError.InvalidJSON }
			numericString.append(firstDigit)
			while let next = gen.peek() {
				if ("0"..."9").contains(next) {
					numericString.append(gen.next()!)
				} else { break }
			}
		}
		if gen.peek() == "." {
			numericString.append(gen.next()!)
			while let next = gen.peek() {
				if ("0"..."9").contains(next) {
					numericString.append(gen.next()!)
				} else { break }
			}
		}
		if gen.peek()?.lowercase == "e" {
			numericString.append(gen.next()!)
			if gen.peek() == "+" || gen.peek() == "-" {
				numericString.append(gen.next()!)
			}
			while let next = gen.peek() {
				if ("0"..."9").contains(next) {
					numericString.append(gen.next()!)
				} else { break }
			}
		}
		if let number = Double(numericString) {
			return .number(number)
		}
		throw JSONError.InvalidJSON
	}
	
	private static func parseBool(_ gen: inout Generator<String>) throws -> JSON {
		if String(gen.peek(4)) == "true" {
			gen.advanceBy(4)
			return .bool(true)
		}
		if String(gen.peek(5)) == "false" {
			gen.advanceBy(5)
			return .bool(false)
		}
		throw JSONError.InvalidJSON
	}
	
	private static func parseNull(_ gen: inout Generator<String>) throws -> JSON {
		guard String(gen.next(4)) == "null" else { throw JSONError.InvalidJSON }
		return .null
	}
}
