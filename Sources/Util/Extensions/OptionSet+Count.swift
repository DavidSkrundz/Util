//
//  OptionSet+Count.swift
//  Util
//

import ProtocolNumbers

extension OptionSet where RawValue: SwiftInteger {
	public var count: Int {
		return self.rawValue.bitCount()
	}
	
	public var isEmpty: Bool {
		return self.count == 0
	}
}
