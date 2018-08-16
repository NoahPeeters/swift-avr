//
//  FixedWidthInteger+Bitmask.swift
//  swift-avr
//
//  Created by Noah Peeters on 16.08.18.
//

import Foundation

extension FixedWidthInteger {
    public func getValue(withBitmask bitmask: Self) -> Self {
        var result: Self = 0

        for offset in (0..<Self.bitWidth).reversed() where (bitmask >> offset) & 1 == 1 {
            result <<= 1
            result ^= (self >> offset) & 1
        }

        return result
    }
}
