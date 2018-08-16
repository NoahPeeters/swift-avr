//
//  AssemblyInstruction.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public struct AssemblyInstruction {
    public let operationCode: String
    public let name: String
    public let parameters: [String]

    public var description: String {
        let parameters = self.parameters.joined(separator: ", ")
        return "\(operationCode)\t\t\(name)\t\(parameters)"
    }
}
