//
//  OperationCode.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class OpCodeType<BitWidth: FixedWidthInteger> {
    private let identifier: BitWidth
    private let identifierBitmask: BitWidth

    public init(identifier: BitWidth, opcBitmask: BitWidth) {
        self.identifier = identifier
        self.identifierBitmask = opcBitmask
    }

    public func match(operation: BitWidth) -> Bool {
        return (operation & identifierBitmask) == identifier
    }

    open func execute(onCPU cpu: VirtualCPU, operation: BitWidth) {
        // Dummy implementation
    }

    open func generateAssembly(fromOperation operation: BitWidth) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.hex(), name: "", parameters: [])
    }
}

extension OpCodeType where BitWidth == Word {
    public func getDefaultParameterAddresses(fromOperation operation: Word) -> (destination: Int, source: Int) {
        return (destination: Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000)),
                source:      Int(operation.getValue(withBitmask: 0b0000_0010_0000_1111)))
    }

    public func getDefaultAssemblyParameters(fromOperation operation: Word) -> [String] {
        let (destination, source) = getDefaultParameterAddresses(fromOperation: operation)
        return ["r\(destination)", "r\(source)"]
    }
}
