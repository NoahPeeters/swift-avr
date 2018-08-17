//
//  RET.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 17.08.18.
//

import Foundation

public class RET: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0101_0000_1000,
                   opcBitmask: 0b1111_1111_1111_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let lower = Int(cpu.popFromStack())
        let upper = Int(cpu.popFromStack())
        let target = (lower << 8) + upper

        cpu.programCounter = target
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(), name: "RET", parameters: [])
    }
}
