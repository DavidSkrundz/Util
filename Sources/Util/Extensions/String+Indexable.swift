//
//  String+Indexable.swift
//  Util
//

extension String: Collection {}

extension String {
	public typealias Indices = DefaultRandomAccessIndices<String>
	
	/// If `distance` is positive: get the `Index` which is `distance` from
	/// `self.startIndex`
	///
	/// If `distance` is negative: get the `Index` which is `distance` from
	/// `self.endIndex`
	///
	/// - Complexity: O(1)
	///
	/// - Returns: An `Index` which is `distance` ahead of `self.startIndex` or
	///            `distance` behind `self.endIndex` depending on the sign of
	///            `distance`
	public func indexAt(_ distance: String.IndexDistance) -> String.Index {
		if distance >= 0 {
			return self.advanceIndex(self.startIndex, by: distance)
		}
		return self.reverseIndex(self.endIndex, by: -distance)
	}
	
	/// - Returns: A substring of `self` with indices relative to
	///            `self.startIndex`
	public subscript(range: Range<Int>) -> String {
		return self[
			self.indexAt(range.lowerBound)..<self.indexAt(range.upperBound)
		]
	}
}
