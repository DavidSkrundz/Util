//
//  LinuxMain.swift
//  Util
//

@testable import UtilTests
import XCTest

XCTMain([
	testCase(BitCountTests.allTests),
	testCase(ChunksTests.allTests),
	testCase(GeneratorTests.allTests),
	testCase(StringExtensionTests.allTests),
	testCase(EnumIteratorTests.allTests),
	testCase(JSONTests.allTests),
])
