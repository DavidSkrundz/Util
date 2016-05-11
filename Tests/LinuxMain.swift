//
//  LinuxMain.swift
//  Util
//

@testable import UtilTests
import XCTest

XCTMain([
	testCase(BitCountTests.allTests),
	testCase(GeneratorTests.allTests),
	testCase(StringExtensionTests.allTests),
])
