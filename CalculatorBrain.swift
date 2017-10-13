//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Usman Hasan on 10/6/17.
//  Copyright © 2017 Hasan Corporation. All rights reserved.
//

import Foundation

func salesTax(operand: Double) -> Double {
    let tax = 0.0825
    let calcTax = operand * tax
    let total = operand + calcTax
    return total
}

func percentOff(op1: Double, op2: Double) -> Double {
    let percentOff = op2 * 0.01
    let discount = op1 * percentOff;
    let finalPrice = op1 - discount
    return finalPrice
}

struct CalculatorBrain{
    
    private var accumulator: Double?
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> =
        [
            "π": Operation.constant(Double.pi),
            "📱": Operation.unaryOperation(salesTax),
            "%": Operation.binaryOperation(percentOff),
            "e": Operation.constant(M_E),
            "√": Operation.unaryOperation(sqrt),
            "cos": Operation.unaryOperation(cos),
            "±": Operation.unaryOperation({ -$0 }),
            "×": Operation.binaryOperation({ $0 * $1 }),
            "÷": Operation.binaryOperation({ $0 / $1 }),
            "+": Operation.binaryOperation({ $0 + $1 }),
            "−": Operation.binaryOperation({ $0 - $1 }),
            "=": Operation.equals,
            "AC": Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let f):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                accumulator = 0
            }
            
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private  struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result: Double?{
        get{
            return accumulator
        }
    }
    
}
