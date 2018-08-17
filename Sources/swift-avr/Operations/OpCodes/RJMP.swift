//
//  RJMP.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class RJMP: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1100_0000_0000_0000,
                   opcBitmask: 0b1111_0000_0000_0000)
    }

    private func getTargetAddress(fromOperation operation: Word) -> Int {
        let int12TwoComplement = operation.getValue(withBitmask: 0b0000_1111_1111_1111)
        let int16TwoComplement = int12TwoComplement.twoComplement(bitWidth: 12)

        return Int(int16TwoComplement)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        cpu.programCounter += getTargetAddress(fromOperation: operation)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let target = getTargetAddress(fromOperation: operation) * 2
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "RJMP",
                                   parameters: [String(target)])
    }
}
