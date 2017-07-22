//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alvaro Espitia on 7/9/17.
//  Copyright © 2017 AE. All rights reserved.
//

import Foundation

struct calculatorBrain {
    
    //Variables
    private var accumulator: Double?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
   
    var result: Double? {
        get {
            return accumulator
        }
    }

    var resultIsPending = false
    private var description: String? = ""
    var lastDescription: String? = ""
    
    //Dictionaries
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)-> Double)
        case binaryOperation((Double,Double)-> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π"   : Operation.constant(Double.pi),
        
        "eˣ"  : Operation.unaryOperation({ pow(M_E,$0)}),
        "√"   : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sen" : Operation.unaryOperation(sin),
        "±"   : Operation.unaryOperation({ -$0 }),
        "%"   : Operation.unaryOperation({ $0/100 }),
        
        "×"   : Operation.binaryOperation({$0 * $1}),
        "÷"   : Operation.binaryOperation({ $0 / $1 }),
        "+"   : Operation.binaryOperation({ $0 + $1 }),
        "-"   : Operation.binaryOperation({ $0 - $1 }),
        "yˣ"   : Operation.binaryOperation({ pow($0,$1) }),
        
        "="   : Operation.equals
        
    ]
    
    //Functions
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .constant(let value):
                accumulator = value
               
                if resultIsPending{
                    description?.append(symbol)
                } else {
                    description = symbol
                }
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending {
                        description = "\(symbol)(\(description!))"
                    }
                    accumulator = function(accumulator!)
                }
                
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    description?.append(symbol)
                
                if !resultIsPending {resultIsPending = true}
                }
                
            case .equals:
                performPendingOperation()
                
            }
        }
        lastDescription=description
    }
    
    private mutating func performPendingOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if resultIsPending != true {
            description = ""
        }
        if operand.truncatingRemainder(dividingBy: 1) == 0 {
            let format = NumberFormatter()
            format.maximumFractionDigits = 0
            description?.append(format.string(for: operand)!)
            
        } else {
            description?.append(String(operand))
        }
    }
    
    
    // Clears everything and restart the calculator to its initial values
    mutating func clearContents() {
        accumulator = nil
        pendingBinaryOperation = nil
        description = ""
        lastDescription = ""
        resultIsPending = false
    }
    
    
    
 }

