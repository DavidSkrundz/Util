//
//  BitshiftableInteger+BitCount.swift
//  Util
//

import ProtocolNumbers

extension SwiftInteger {
	/// - Returns: The number of bits that are set
	public func bitCount() -> Int {
		let bitAmount = MemoryLayout<Self>.size * 8
		var bitCount = 0
		var currentMask: Self = 1
		for _ in 0..<bitAmount {
			if self & currentMask != 0 {
				bitCount += 1
			}
			currentMask ≪= 1
		}
		return bitCount
	}
}
