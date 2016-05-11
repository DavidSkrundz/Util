//
//  Generator.swift
//  Util
//

/// A `Generator` behaves like an `Iterator`, but allows for backtracking and
/// skipping elements
///
/// - Author: David Skrundz
public struct Generator<Container: Collection> {
	fileprivate let collection: Container
	fileprivate var currentIndex: Container.Index
	
	/// Create a new `Generator` starting at `sequence.startIndex`
	public init(sequence: Container) {
		self.collection = sequence
		self.currentIndex = self.collection.startIndex
	}
	
	/// Get the remaining items as an `Array`
	///
	/// - Note: Does not advance the index
	///
	/// - Returns: An `Array` of the remaining items
	public func remainingItems() -> [Container.SubSequence.Iterator.Element] {
		return self
			.collection[self.currentIndex..<self.collection.endIndex]
			.toArray()
	}
}

// MARK: - Computed Properties
extension Generator {
	/// - Retutns: `true` iff `self.reverse()` would have no effect
	public var atStart: Bool {
		return self.currentIndex == self.collection.startIndex
	}
	
	/// - Returns: `true` iff `self.advance()` would have no effect
	public var atEnd: Bool {
		return self.currentIndex == self.collection.endIndex
	}
	
	/// - Returns: `true` iff `self.peek()` and `self.next()` would return
	///            non-`nil`
	public var hasNext: Bool {
		return !self.atEnd
	}
}

// MARK: - IteratorProtocol
extension Generator: IteratorProtocol {
	public typealias Element = Container.Iterator.Element
	
	/// Get the next element and advance the index
	///
	/// - Returns: The next element in the `Sequence`
	public mutating func next() -> Element? {
		guard self.hasNext else { return nil }
		defer {
			self.currentIndex = self.collection.index(after: self.currentIndex)
		}
		return self.collection[self.currentIndex]
	}
}

// MARK: - Sequence
extension Generator: Sequence {}

// MARK: - Forward Looking
extension Generator {
	/// Get the next element without advancing the index
	///
	/// - Returns: The next element in the `Sequence`
	public func peek() -> Element? {
		guard self.hasNext else { return nil }
		return self.collection[self.currentIndex]
	}
	
	/// Get the next `amount` of elements and advance the index by `amount`
	///
	/// - Returns: A `SubSequence` of the next `amount` of elements or less if
	///            less exist
	public mutating func next(_ amount: Container.IndexDistance)
	                               -> [Container.SubSequence.Iterator.Element] {
		let startIndex = self.currentIndex
		self.currentIndex = self.collection.advanceIndex(self.currentIndex,
		                                                 by: amount)
		return self.collection[startIndex..<self.currentIndex].toArray()
	}
	
	/// Get the next `amount` of elements without advancing the index by
	/// `amount`
	///
	/// - Returns: A `SubSequence` of the next `amount` of elements or less if
	///            less exist
	public func peek(_ amount: Container.IndexDistance)
	                               -> [Container.SubSequence.Iterator.Element] {
		let endIndex = self.collection.advanceIndex(self.currentIndex,
		                                            by: amount)
		return self.collection[self.currentIndex..<endIndex].toArray()
	}
}

// MARK: - Backwards Looking
extension Generator {
	/// Get the previous element and reverse the index
	///
	/// - Returns: The previous element in the `Sequence`
	public mutating func previous() -> Element? {
		guard !self.atStart else { return nil }
		self.currentIndex = self.collection.advanceIndex(self.currentIndex,
		                                                 by: -1)
		return self.collection[self.currentIndex]
	}
	
	/// Get the previous element without reversing the index
	///
	/// - Returns: The previous element in the `Sequence`
	public func peekPrevious() -> Element? {
		guard !self.atStart else { return nil }
		let previousIndex = self.collection.reverseIndex(self.currentIndex,
		                                                 by: 1)
		return self.collection[previousIndex]
	}
	
	/// Get the previous `amount` of elements and reverse the index by `amount`
	///
	/// - Returns: A `SubSequence` of the previous `amount` of elements or less
	///            if less exist
	public mutating func previous(_ amount: Container.IndexDistance)
	                               -> [Container.SubSequence.Iterator.Element] {
		let endIndex = self.currentIndex
		self.currentIndex = self.collection.reverseIndex(self.currentIndex,
		                                                 by: amount)
		return self.collection[self.currentIndex..<endIndex].reversed()
	}
	
	/// Get the previous `amount` of elements without reversing the index by
	/// `amount`
	///
	/// - Returns: A `SubSequence` of the previous `amount` of elements or less
	///            if less exist
	public func peekPrevious(_ amount: Container.IndexDistance)
	                               -> [Container.SubSequence.Iterator.Element] {
		let startIndex = self.collection.reverseIndex(self.currentIndex,
		                                              by: amount)
		return self.collection[startIndex..<self.currentIndex].reversed()
	}
}

// MARK: - Move Index
extension Generator {
	/// Advance the index by `amount`
	public mutating func advanceBy(_ amount: Container.IndexDistance) {
		self.currentIndex = self.collection.advanceIndex(self.currentIndex,
		                                                 by: amount)
	}
	
	/// Reverse the index by `amount`
	public mutating func reverseBy(_ amount: Container.IndexDistance) {
		self.currentIndex = self.collection.reverseIndex(self.currentIndex,
		                                                 by: amount)
	}
	
	/// Moves the `Generator` index forward by one. Will never go past
	/// `EndIndex`
	public mutating func advance() {
		self.advanceBy(1)
	}
	
	/// Moves the `Generator` index backward by one. Will never go past
	/// `StartIndex`
	public mutating func reverse() {
		self.reverseBy(1)
	}
}
