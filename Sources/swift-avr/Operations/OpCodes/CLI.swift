//
//  CLI.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class CLI: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0100_1111_1000,
                   opcBitmask: 0b1111_1111_1111_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        cpu.write(statusRegister: .globalInterruptFlag, value: false)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(), name: "CLI", parameters: [])
    }
}
