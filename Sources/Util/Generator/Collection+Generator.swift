//
//  Collection+Generator.swift
//  Util
//

extension Collection {
	/// - Returns: A new `Generator<Self>` starting at `self.startIndex`
	public func generator() -> Util.Generator<Self> {
		return Util.Generator(sequence: self)
	}
}
