//
//  Package.swift
//  Util
//

import PackageDescription

let package = Package(
	name: "Util",
	dependencies: [
		.Package(url: "https://github.com/DavidSkrundz/ProtocolNumbers.git", majorVersion: 1, minor: 0),
	]
)

let staticLibrary = Product(
	name: "Util",
	type: .Library(.Static),
	modules: ["Util"]
)
let dynamicLibrary = Product(
	name: "Util",
	type: .Library(.Dynamic),
	modules: ["Util"]
)

products.append(staticLibrary)
products.append(dynamicLibrary)
