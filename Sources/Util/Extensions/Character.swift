//
//  Character.swift
//  Util
//

extension Character {
	/// - Returns: The unicode value of `self`
	public var unicodeValue: Int {
		return Int(String(self).unicodeScalars.first!.value)
	}
	
	/// - Returns: The value of `self` as a hexadecimal digit
	public var hexValue: Int {
		switch self {
			case _ where self.isDigit:
				return self.unicodeValue - Character("0").unicodeValue
			case _ where self >= "a" && self <= "f":
				return self.unicodeValue - Character("a").unicodeValue + 10
			case _ where self >= "A" && self <= "F":
				return self.unicodeValue - Character("A").unicodeValue + 10
			default:
				fatalError("\(self) is not a hexadecimal character")
		}
	}
	
	/// - Returns: The index of `self` in the English alphabet
	public var alphabetIndex: Int {
		switch self {
			case _ where self >= "a" && self <= "z":
				return self.unicodeValue - Character("a").unicodeValue + 1
			case _ where self >= "A" && self <= "Z":
				return self.unicodeValue - Character("A").unicodeValue + 1
			default:
				fatalError("\(self) is not in the English alphabet")
		}
	}
	
	/// Whitespace characters are defined here as:
	///
	/// - `space`
	/// - `\t`
	/// - `\n`
	/// - `\r`
	/// - `\r\n`
	///
	/// - Returns: `true` iff `self` is a whitespace `Character`
	public var isWhitespace: Bool {
		return " \t\n\r\r\n".contains(self)
	}
	
	/// - Returns: `true` iff `self` is a digit from `0` to `9`
	public var isDigit: Bool {
		return self >= "0" && self <= "9"
	}
	
	/// - Returns: `true` iff `self` is in the English alphabet
	public var isLetter: Bool {
		return (self >= "a" && self <= "z") || (self >= "A" && self <= "Z")
	}
	
	/// - Returns: `true` iff `self` is a digit from `0` to `9` or `a` to `f` or
	///            `A` to `F`
	public var isHexDigit: Bool {
		return (
			self.isDigit ||
			(self >= "A" && self <= "F") ||
			(self >= "a" && self <= "f")
		)
	}
	
	/// - Returns: `true` iff `self` is a difit from `0` to `7`
	public var isOctDigit: Bool {
		return self >= "0" && self <= "7"
	}
	
	/// - Returns: The lowercase version of `self` if it exists, otherwise
	///            `self`
	public var lowercase: Character {
		return String(self).lowercased().characters.first!
	}
	
	/// - Returns: The uppercase version of `self` if it exists, otherwise
	///            `self`
	public var uppercase: Character {
		return String(self).uppercased().characters.first!
	}
}
