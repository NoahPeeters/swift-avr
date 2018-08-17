//
//  OperationFactory.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public protocol SingleBitWidthOperationFactoryProtocol {
    associatedtype BitWidth: FixedWidthInteger

    func register(operation: OpCodeType<BitWidth>)
    func matchingOpCodeType(forOperation operation: BitWidth) -> OpCodeType<BitWidth>?
}

public class SingleBitWidthOperationFactory<BitWidth: FixedWidthInteger>: SingleBitWidthOperationFactoryProtocol {
    private var opCodes: [OpCodeType<BitWidth>] = []

    public init() {}

    public func register(operation: OpCodeType<BitWidth>) {
        opCodes.append(operation)
    }

    public func matchingOpCodeType(forOperation operation: BitWidth) -> OpCodeType<BitWidth>? {
        return opCodes.first { $0.match(operation: operation) }
    }
}

public class OperationFactory {
    private let wordFactory: SingleBitWidthOperationFactory<Word>
    private let doubleWordFactory: SingleBitWidthOperationFactory<DoubleWord>

    public init(wordFactory: SingleBitWidthOperationFactory<Word>,
                doubleWordFactory: SingleBitWidthOperationFactory<DoubleWord>) {
        self.wordFactory = wordFactory
        self.doubleWordFactory = doubleWordFactory
    }

    public convenience init() {
        self.init(wordFactory: SingleBitWidthOperationFactory<Word>(),
                  doubleWordFactory: SingleBitWidthOperationFactory<DoubleWord>())
    }

    public func register(wordOperation: OpCodeType<Word>) {
        wordFactory.register(operation: wordOperation)
    }

    public func register(doubleWordOperation: OpCodeType<DoubleWord>) {
        doubleWordFactory.register(operation: doubleWordOperation)
    }

    public func scheduleExecution(inMemory memory: ProgramMemory, atLocation address: Int) -> ScheduledExecution? {
        let wordOpCode = memory.read(wordAt: address)
        if let wordOperation = wordFactory.matchingOpCodeType(forOperation: wordOpCode) {
            return ScheduledExecution(
                operationLength: 1,
                executionOperation: { cpu in
                    wordOperation.execute(onCPU: cpu, operation: wordOpCode)
                },
                assemblyFetcher: {
                    wordOperation.generateAssembly(fromOperation: wordOpCode)
                })
        }

        let doubleWordOpCode = memory.read(doubleWordAt: address)
        if let doubleWordOperation = doubleWordFactory.matchingOpCodeType(forOperation: doubleWordOpCode) {
            return ScheduledExecution(
                operationLength: 2,
                executionOperation: { cpu in
                    doubleWordOperation.execute(onCPU: cpu, operation: doubleWordOpCode)
                }, assemblyFetcher: {
                    doubleWordOperation.generateAssembly(fromOperation: doubleWordOpCode)
                })
        }

        return nil
    }
}

public struct ScheduledExecution {
    public let operationLength: Int
    public let executionOperation: (VirtualCPU) -> Void
    public let assemblyFetcher: () -> AssemblyInstruction
}
