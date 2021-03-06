//
//  CALL.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class CALL: OpCodeType<DoubleWord> {
    public init() {
        super.init(identifier: 0b1001_0100_0000_1110_0000_0000_0000_0000,
                   opcBitmask: 0b1111_1110_0000_1110_0000_0000_0000_0000)
    }

    private func getTargetAddress(fromOperation operation: DoubleWord) -> Int {
        return Int(operation.getValue(withBitmask: 0b0000_0001_1111_0001_1111_1111_1111_1111))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: DoubleWord) {
        let target = getTargetAddress(fromOperation: operation)

        cpu.pushOntoStack(Byte(cpu.programCounter))
        cpu.pushOntoStack(Byte(cpu.programCounter >> 8))
        cpu.programCounter = target
    }

    public override func generateAssembly(fromOperation operation: DoubleWord) -> AssemblyInstruction {
        let target = getTargetAddress(fromOperation: operation) * 2
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "CALL",
                                   parameters: [target.hex()])
    }
}
