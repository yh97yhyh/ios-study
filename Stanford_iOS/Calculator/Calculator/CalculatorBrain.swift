//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by MZ01-KYONGH on 2021/11/12.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()

    func setOperand(_ operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
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
        internalProgram.append(symbol as AnyObject)
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
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    typealias PropertyList = AnyObject // documenting
    var program: PropertyList {
        get {
            return internalProgram as AnyObject
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    var result: Double { // read only property
        get {
            return accumulator
        }
    }
    
}
