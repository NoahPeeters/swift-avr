//
//  IN.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 17.08.18.
//

import Foundation

//swiftlint:disable:next type_name
public class IN: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1011_0000_0000_0000,
                   opcBitmask: 0b1111_1000_0000_0000)
    }

    private func getParameters(fromOperation operation: Word) -> (register: Int, ioLocation: Int) {
        return (register: Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000)),
                ioLocation: Int(operation.getValue(withBitmask: 0b0000_0110_0000_1111)))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (register, ioLocation) = getParameters(fromOperation: operation)

        cpu.write(registerIndex: register, value: cpu.read(ioLocation: ioLocation))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (register, ioLocation) = getParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "IN",
                                   parameters: ["r\(register)", "$\(ioLocation)"])
    }
}
