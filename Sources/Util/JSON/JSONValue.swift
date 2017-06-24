//
//  JSONValue.swift
//  Util
//

/// A protocol that describes types of native JSON values
public protocol JSONValue {}

extension Dictionary: JSONValue {} // where Key = String, Value is JSONValue
extension Array: JSONValue {} // where Element is JSONValue
extension String: JSONValue {}
extension Double: JSONValue {}
extension Bool: JSONValue {}
