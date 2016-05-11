//
//  Collection+BoundedIndex.swift
//  Util
//

extension Collection {
	/// Get the `Index` which is at most `amount` ahead of `index`, but never
	/// after `self.endIndex`
	///
	/// - Complexity:
	///   - O(1) if `Self` conforms to `RandomAccessCollection`.
	///   - O(`abs(n)`) otherwise.
	///
	/// - Returns: An `Index` which is `amount` ahead of `index`, but not after
	///            `self.endIndex`
	public func advanceIndex(_ index: Self.Index,
	                         by amount: Self.IndexDistance) -> Self.Index {
		return self.index(index, offsetBy: amount, limitedBy: self.endIndex)
			?? self.endIndex
	}
	
	/// Get the `Index` which is at most `amount` behind of `index`, but never
	/// before `self.startIndex`
	///
	/// - Complexity:
	///   - O(1) if `Self` conforms to `RandomAccessCollection`.
	///   - O(`abs(n)`) otherwise.
	///
	/// - Returns: An `Index` which is `amount` behind of `index`, but not
	///            before `self.startIndex`
	public func reverseIndex(_ index: Self.Index,
	                         by amount: Self.IndexDistance) -> Self.Index {
		return self.index(index, offsetBy: -amount, limitedBy: self.startIndex)
			?? self.startIndex
	}
}
