//
//  EnumIterator.swift
//  Util
//

public func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
	var index = 0
	return AnyIterator {
		let next = withUnsafeBytes(of: &index) { $0.load(as: T.self) }
		if next.hashValue != index { return nil }
		index += 1
		return next
	}
}
