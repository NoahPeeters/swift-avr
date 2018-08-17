//
//  ST.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 17.08.18.
//

import Foundation

public class STX1: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0010_0000_1100,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // TODO Implement ST
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "ST",
                                   parameters: [])
    }
}
