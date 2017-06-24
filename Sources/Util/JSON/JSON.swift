//
//  JSON.swift
//  Util
//

// http://www.json.org

public enum JSON {
	case object([String : JSON])
	case array([JSON])
	case string(String)
	case number(Double)
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
			guard ("1"..."9").contains(firstDigit) else { throw JSONError.InvalidJSON }
			numericString.append(firstDigit)
			while let next = gen.peek() {
				if next.isDigit {
					numericString.append(gen.next()!)
				} else { break }
			}
		}
		if gen.peek() == "." {
			numericString.append(gen.next()!)
			while let next = gen.peek() {
				if next.isDigit {
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
				if next.isDigit {
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

extension JSON {
	/// Encode to JSON
	///
	/// - Parameter pretty: Whether or not to format the output
	public func encode(pretty: Bool = false) -> String {
		return JSON.encode(self, pretty ? 0 : nil)
	}
	
	private static func encode(_ object: JSON, _ depth: Int?) -> String {
		switch object {
			case let .object(object): return self.encodeObject(object, depth)
			case let .array(array):   return self.encodeArray(array, depth)
			case let .string(string): return self.encodeString(string)
			case let .number(number): return self.encodeNumber(number)
			case let .bool(bool):     return self.encodeBool(bool)
			case     .null:           return self.encodeNull()
		}
	}
	
	private static func encodeObject(_ object: [String : JSON],
	                                 _ depth: Int?) -> String {
		if object.count == 0 { return "{}" }
		let padding = self.padding(depth)
		let newline = self.newline(depth)
		let space = self.space(depth)
		let depthPlus = depth.map { $0 + 1 }
		let paddingPlus = self.padding(depthPlus)
		let elements = object
			.map { (paddingPlus + "\"\($0.key)\"", self.encode($0.value, depthPlus)) }
			.sorted { $0.0 < $1.0 }
		let first = "\(elements.first!.0):\(space)\(elements.first!.1)"
		let reduced = elements
			.dropFirst()
			.reduce(first) { $0 + "," + newline + "\($1.0):\(space)\($1.1)" }
		return "{\(newline)\(reduced)\(newline)\(padding)}"
	}
	
	private static func encodeArray(_ array: [JSON],
	                                _ depth: Int?) -> String {
		if array.count == 0 { return "[]" }
		let padding = self.padding(depth)
		let newline = self.newline(depth)
		let depthPlus = depth.map { $0 + 1 }
		let paddingPlus = self.padding(depthPlus)
		let elements = array
			.map { paddingPlus + self.encode($0, depthPlus) }
		let reduced = elements
			.dropFirst()
			.reduce(elements.first!) { $0 + "," + newline + $1 }
		return "[\(newline)\(reduced)\(newline)\(padding)]"
	}
	
	private static func encodeString(_ string: String) -> String {
		let str =  string.characters
			.map { char -> String in
				switch char {
					case "\"":    return "\\\""
					case "\\":    return "\\\\"
					case "/":     return "\\/"
					case "\u{8}": return "\\b"
					case "\u{C}": return "\\f"
					case "\n":    return "\\n"
					case "\r":    return "\\r"
					case "\r\n":  return "\\r\\n"
					case "\t":    return "\\t"
					default:      return String(char)
				}
			}
			.reduce("", +)
		return "\"" + str + "\""
	}
	
	private static func encodeNumber(_ number: Double) -> String {
		if let int = Int(exactly: number) {
			return String(int)
		}
		return String(number)
	}
	
	private static func encodeBool(_ bool: Bool) -> String {
		return bool ? "true" : "false"
	}
	
	private static func encodeNull() -> String {
		return "null"
	}
	
	private static func padding(_ depth: Int?) -> String {
		return depth.map { String(repeating: "\t", count: $0) } ?? ""
	}
	
	private static func newline(_ depth: Int?) -> String {
		return depth.map { _ in "\n" } ?? ""
	}
	
	private static func space(_ depth: Int?) -> String {
		return depth.map { _ in " " } ?? ""
	}
}

extension JSON {
	public func dictionaryValue() -> [String : JSON]? {
		guard case let .object(object) = self else { return nil }
		return object
	}
	
	public func arrayValue() -> [JSON]? {
		guard case let .array(array) = self else { return nil }
		return array
	}
}

extension JSON {
	private func toValue() -> JSONValue? {
		switch self {
			case .object(_): return self.toDictionary()
			case .array(_):  return self.toArray()
			case .string(_): return self.toString()
			case .number(_): return self.toDouble()
			case .bool(_):   return self.toBool()
			case .null:      return nil
		}
	}
	
	public func toDictionary() -> [String : JSONValue]? {
		return self.dictionaryValue()?
			.map { ($0.key, $0.value.toValue()) }
			.reduce([String : JSONValue]()) { (d, kv) -> [String : JSONValue] in
				var dict = d
				dict[kv.0] = kv.1
				return dict
			}
	}
	
	public func toArray() -> [JSONValue?]? {
		return self.arrayValue()?.map { $0.toValue() }
	}
	
	public func toString() -> String? {
		guard case let .string(string) = self else { return nil }
		return string
	}
	
	public func toDouble() -> Double? {
		guard case let .number(double) = self else { return nil }
		return double
	}
	
	public func toBool() -> Bool? {
		guard case let .bool(bool) = self else { return nil }
		return bool
	}
}
