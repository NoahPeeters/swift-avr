//
//  FixedWidthInteger+Hex.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

extension FixedWidthInteger {
    public func hex() -> String {
        return "0x\(String(self, radix: 16, uppercase: false))"
    }

    public func paddedHex() -> String {
        let characters = Self.bitWidth / 4
        let hexRepresentation = String(self, radix: 16, uppercase: false)
        let paddedHex = String(repeating: "0", count: characters - hexRepresentation.count) +
                        hexRepresentation +
                        String(repeating: " ", count: 8 - characters)

        return paddedHex.separated(every: 2, with: " ")
    }
}

extension String {
    fileprivate func separated(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
