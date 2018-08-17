//
//  SBCI.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class SBCI: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0100_0000_0000_0000,
                   opcBitmask: 0b1111_0000_0000_0000)
    }

    private func tripleSUB<Input: FixedWidthInteger>(_ valueA: Input,
                                                     _ valueB: Input,
                                                     _ valueC: Input) -> (sum: Input, carry: Bool) {
        let (intermediateSum, intermediateCarry) = valueA.subtractingReportingOverflow(valueB)
        let (sum, carry) = intermediateSum.subtractingReportingOverflow(valueC)
        return (sum, carry || intermediateCarry)
    }

    private func getParameters(fromOperation operation: Word) -> (register: Int, constant: Byte) {
        return (register: Int(operation.getValue(withBitmask: 0b0000_0000_1111_0000)) + 16,
                constant: Byte(operation.getValue(withBitmask: 0b0000_1111_0000_1111)))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (register, constant) = getParameters(fromOperation: operation)
        let registerValue = cpu.read(registerIndex: register)
        let carryFlag = cpu.read(statusRegister: .carryFlag)
        let valueC: Byte = carryFlag ? 1 : 0

        let (diff, carry) = tripleSUB(registerValue, constant, valueC)
        let (_, halfCarry) = tripleSUB(registerValue << 4, constant << 4, valueC << 4)
        let (_, overflowIndicator) = tripleSUB(registerValue << 1, constant << 1, valueC << 1)

        cpu.write(statusRegister: .carryFlag, value: carry)
        cpu.write(statusRegister: .zeroFlag, value: diff == 0)
        cpu.write(statusRegister: .negativeFlag, value: (diff >> 7) == 1)
        cpu.write(statusRegister: .twosComplementOverflowIndicator, value: overflowIndicator)
        cpu.write(statusRegister: .halfCarryFlag, value: halfCarry)

        cpu.write(registerIndex: register, value: diff)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (register, constant) = getParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "SBCI",
                                   parameters: ["r\(register)", constant.hex()])
    }
}
