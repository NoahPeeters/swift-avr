//
//  OperationFactoryInit.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

extension OperationFactory {
    public func registerDefaultOperations() {
        registerDefaultWordOperations()
        registerDefaultDoubleWorldOperations()
    }

    public func registerDefaultWordOperations() {
        let operations = [
            ADC(),
            ADD(),
            AND(),
            BREQ(),
            BRNE(),
            CLI(),
            CPSE(),
            EOR(),
            IN(),
            LDX1(),
            LDX2(),
            LDX3(),
            LDY1(),
            LDI(),
            LPM1(),
            LPM2(),
            LPM3(),
            MOV(),
            MOVW(),
            OR(),
            OUT(),
            POP(),
            PUSH(),
            RET(),
            RJMP(),
            SBCI(),
            STX1(),
            SUBI()
        ]

        for operation in operations {
            register(wordOperation: operation)
        }
    }

    public func registerDefaultDoubleWorldOperations() {
        let operations = [
            CALL(),
            JMP()
        ]

        for operation in operations {
            register(doubleWordOperation: operation)
        }
    }
}
