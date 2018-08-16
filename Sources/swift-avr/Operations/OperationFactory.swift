//
//  OperationFactory.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public protocol SingleBitWidthOperationFactoryProtocol {
    associatedtype BitWidth: BinaryInteger

    func register(operation: OpCodeType<BitWidth>)
    func execute(onCPU cpu: VirtualCPU, operation: BitWidth) -> Bool
}

public class SingleBitWidthOperationFactory<BitWidth: BinaryInteger>: SingleBitWidthOperationFactoryProtocol {
    private var opCodes: [OpCodeType<BitWidth>] = []

    public init() {}

    public func register(operation: OpCodeType<BitWidth>) {
        opCodes.append(operation)
    }

    public func execute(onCPU cpu: VirtualCPU, operation: BitWidth) -> Bool {
        for opCode in opCodes {
            if opCode.match(operation: operation) {
                opCode.execute(onCPU: cpu, operation: operation)
                return true
            }
        }

        return false
    }
}
