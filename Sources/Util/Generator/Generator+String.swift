//
//  Generator+String.swift
//  Util
//

extension Generator where Container == String {
	public mutating func skipWhitespace() {
		while self.peek()?.isWhitespace ?? false {
			self.advance()
		}
	}
}
