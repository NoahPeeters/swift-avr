//
//  BREQ.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class BREQ: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1111_0000_0000_0001,
                   opcBitmask: 0b1111_1100_0000_0111)
    }

    private func getDestination(forOperation operation: Word) -> Int {
        return Int(operation.getValue(withBitmask: 0b0000_0011_1111_1000).twoComplement(bitWidth: 7))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        if cpu.read(statusRegister: .zeroFlag) {
            cpu.programCounter += getDestination(forOperation: operation)
        }
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "BREQ",
                                   parameters: [String(getDestination(forOperation: operation))])
    }
}
