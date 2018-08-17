//
//  LDI.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class LDI: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1110_0000_0000_0000,
                   opcBitmask: 0b1111_0000_0000_0000)
    }

    private func getParameters(fromOperation operation: Word) -> (register: Int, constant: Byte) {
        return (register: Int(operation.getValue(withBitmask: 0b0000_0000_1111_0000)) + 16,
                constant: Byte(operation.getValue(withBitmask: 0b0000_1111_0000_1111)))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (register, constant) = getParameters(fromOperation: operation)

        cpu.write(registerIndex: register, value: constant)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (register, constant) = getParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LDI",
                                   parameters: ["r\(register)", constant.hex()])
    }
}
