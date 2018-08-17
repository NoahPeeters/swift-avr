//
//  AND.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class AND: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0010_0000_0000_0000,
                   opcBitmask: 0b1111_1100_0000_0000)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // Get the register addresses
        let (destination, source) = getDefaultParameterAddresses(fromOperation: operation)

        // Read the registers
        let valueA = cpu.read(registerIndex: destination)
        let valueB = cpu.read(registerIndex: source)

        // AND the values
        let result = valueA & valueB

        // Set status flags
        cpu.write(statusRegister: .twosComplementOverflowIndicator, value: false)
        cpu.write(statusRegister: .negativeFlag, value: (result >> 7) != 0)
        cpu.write(statusRegister: .zeroFlag, value: result == 0)

        // Write the result
        cpu.write(registerIndex: destination, value: result)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let parameters = getDefaultAssemblyParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "AND",
                                   parameters: parameters)
    }
}
