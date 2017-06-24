//
//  String+Collection.swift
//  Util
//

extension String: RandomAccessCollection {}

extension String {
	public func map<T>(_ transform: (Character) throws -> T) rethrows -> [T] {
		return try self.characters.map(transform)
	}
	
	public func chunks(of size: Int) -> [[Character]] {
		return self.characters.chunks(of: size)
	}
}
