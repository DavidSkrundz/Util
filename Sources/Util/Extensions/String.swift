//
//  String.swift
//  Util
//

extension String {
	/// - Returns: The length of `self` (in `Character`s)
	public var length: Int {
		return self.characters.count
	}
	
	/// - Returns: `true` if `self` ends with the given substring
	public func endsWith(_ substring: String) -> Bool {
		guard self.length >= substring.length else { return false }
		let index = self.reverseIndex(self.endIndex, by: substring.length)
		return self[index..<self.endIndex] == substring
	}
	
	/// - Returns: `true` if `self` starts with the given substring
	public func startsWith(_ substring: String) -> Bool {
		guard self.length >= substring.length else { return false }
		let index = self.advanceIndex(self.startIndex, by: substring.length)
		return self[self.startIndex..<index] == substring
	}
}
