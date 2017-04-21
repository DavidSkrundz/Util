Util [![Swift Version](https://img.shields.io/badge/Swift-3.1-orange.svg)](https://swift.org/download/#releases) [![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg)](https://swift.org/download/#releases) [![Build Status](https://travis-ci.org/DavidSkrundz/Util.svg?branch=master)](https://travis-ci.org/DavidSkrundz/Util) [![Codebeat Status](https://codebeat.co/badges/9f7185f6-b2b9-44b9-a4b6-bc1385bc4a34)](https://codebeat.co/projects/github-com-davidskrundz-util) [![Codecov](https://codecov.io/gh/DavidSkrundz/Util/branch/master/graph/badge.svg)](https://codecov.io/gh/DavidSkrundz/Util)
====

A package full of useful classes and extensions that are not worthy of having their own package.


Classes
=======

Generator
---------
Behaves like an `Iterator`, but allows for backtracking and skipping elements


Extensions
==========

Character
---------
- `unicodeValue: Int`
- `hexValue: Int`
- `alphabetIndex: Int`
- `isDigit: Bool`
- `isLetter: Bool`
- `isHexDigit: Bool`
- `isOctDigit: Bool`
- `lowercase: Character`
- `uppercase: Character`

Indexable
---------
- `advanceIndex(Index, by: IndexDistance) -> Index`
- `reverseIndex(Index, by: IndexDistance) -> Index`

Sequence
--------
- `toArray() -> [Self.Iterator.Element]`

String
------
- `indexAt(IndexDistance) -> String.Index`
- `subscript(Range<Index>) -> String`
- `length: Int`

Collection
----------
- `generator() -> Generator<Self>`
