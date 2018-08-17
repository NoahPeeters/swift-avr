//
//  ADD.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class ADC: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0001_1100_0000_0000,
                   opcBitmask: 0b1111_1100_0000_0000)
    }

    private func tripleAdd<Input: FixedWidthInteger>(_ valueA: Input,
                                                     _ valueB: Input,
                                                     _ valueC: Input) -> (sum: Input, carry: Bool) {
        let (intermediateSum, intermediateCarry) = valueA.addingReportingOverflow(valueB)
        let (sum, carry) = intermediateSum.addingReportingOverflow(valueC)
        return (sum, carry || intermediateCarry)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // Get the register addresses
        let (destination, source) = getDefaultParameterAddresses(fromOperation: operation)

        // Read the registers
        let carryFlag = cpu.read(statusRegister: .carryFlag)
        let valueA = cpu.read(registerIndex: destination)
        let valueB = cpu.read(registerIndex: source)
        let valueC: Byte = carryFlag ? 1 : 0

        // Add the values together
        let (sum, carry) = tripleAdd(valueA, valueB, valueC)
        let (_, halfCarry) = tripleAdd(valueA << 4, valueB << 4, valueC << 4)
        let (_, overflowIndicator) = tripleAdd(valueA << 1, valueB << 1, valueC << 1)

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
        let parameters = getDefaultAssemblyParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "ADC",
                                   parameters: parameters)
    }
}
