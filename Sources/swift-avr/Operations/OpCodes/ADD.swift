//
//  ADD.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class ADD: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0000_1100_0000_0000,
                   opcBitmask: 0b1111_1100_0000_0000)
    }

    private func getParameterAddresses(fromOperation operation: Word) -> (destination: Int, source: Int) {
        return (destination: Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000)),
                source:      Int(operation.getValue(withBitmask: 0b0000_0010_0000_1111)))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // Get the register addresses
        let (destination, source) = getParameterAddresses(fromOperation: operation)

        // Read the registers
        let valueA = cpu.read(registerIndex: destination)
        let valueB = cpu.read(registerIndex: source)

        // Add the values together
        let (sum, carry) = valueA.addingReportingOverflow(valueB)
        let (_, halfCarry) = (valueA << 4).addingReportingOverflow(valueB << 4)
        let (_, overflowIndicator) = (valueA << 1).addingReportingOverflow(valueB << 1)

        // Set status flags
        cpu.write(statusRegister: .carryFlag, value: carry)
        cpu.write(statusRegister: .zeroFlag, value: sum == 0)
        cpu.write(statusRegister: .negativeFlag, value: (sum >> 7) == 1)
        cpu.write(statusRegister: .twosComplementOverflowIndicator, value: overflowIndicator)
        cpu.write(statusRegister: .halfCarryFlag, value: halfCarry)

        // Write the result
        cpu.write(registerIndex: destination, value: sum)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (destination, source) = getParameterAddresses(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "ADD",
                                   parameters: [destination.hex(), source.hex()])
    }
}
