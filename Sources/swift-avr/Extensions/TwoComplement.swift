//
//  TwoComplement.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

private func fillTwoComplement<TargetType: FixedWidthInteger>(originalTwoComplement: TargetType,
                                                              bitWidth: Byte) -> TargetType {
    let isNegative = originalTwoComplement >> (bitWidth - 1) != 0
    let targetComplement = isNegative ? (TargetType.max << bitWidth) | originalTwoComplement : originalTwoComplement

    return targetComplement
}

extension UInt16 {
    public func twoComplement(bitWidth: Byte) -> Int16 {
        return Int16(bitPattern: fillTwoComplement(originalTwoComplement: self, bitWidth: bitWidth))
    }
}
