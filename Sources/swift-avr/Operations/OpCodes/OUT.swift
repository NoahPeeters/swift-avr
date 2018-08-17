//
//  OUT.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class OUT: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1011_1000_0000_0000,
                   opcBitmask: 0b1111_1000_0000_0000)
    }

    private func getParameters(fromOperation operation: Word) -> (ioLocation: Int, register: Int) {
        return (ioLocation: Int(operation.getValue(withBitmask: 0b0000_0110_0000_1111)),
                register:   Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000)))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (ioLocation, register) = getParameters(fromOperation: operation)

        cpu.write(ioLocation: ioLocation,
                  value: cpu.read(registerIndex: register))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (ioLocation, register) = getParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "OUT",
                                   parameters: ["$\(ioLocation)", "r\(register)"])
    }
}
