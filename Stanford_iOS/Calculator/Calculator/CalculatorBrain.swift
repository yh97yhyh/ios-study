//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by MZ01-KYONGH on 2021/11/12.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Opertaion> = [
        "π": Opertaion.Constant(Double.pi),
        "e": Opertaion.Constant(M_E),
        "±": Opertaion.UnaryOperation({ -$0 }),
        "√": Opertaion.UnaryOperation(sqrt),
        "cos": Opertaion.UnaryOperation(cos),
        "x": Opertaion.BinaryOperation({ $0 * $1 }),
        "÷": Opertaion.BinaryOperation({ $0 / $1 }),
        "+": Opertaion.BinaryOperation({ $0 + $1 }),
        "-": Opertaion.BinaryOperation({ $0 - $1 }),
        "=": Opertaion.Equals
    ]
    
    private enum Opertaion {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals: executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
    }
    
    var result: Double { // read only property
        get {
            return accumulator
        }
    }
    
}
