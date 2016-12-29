//
//  Sequence.swift
//  Util
//

extension Sequence {
	/// Converts the `Sequence` to an `Array<Element>`
	public func toArray() -> [Self.Iterator.Element] {
		return self.map { $0 }
	}
}

extension Collection where IndexDistance == Int {
	public func chunksOf(_ size: Int) -> [[Self.SubSequence.Iterator.Element]] {
		return stride(from: 0, to: self.count, by: size).map {
			let startIndex = self.advanceIndex(self.startIndex, by: $0)
			let endIndex = self.advanceIndex(startIndex, by: size)
			return Array(self[startIndex..<endIndex])
		}
	}
}
