//
//  ViewController.swift
//  Calculator
//
//  Created by Alvaro Espitia on 7/8/17.
//  Copyright © 2017 AE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var displaySequence: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    
    private var brain = calculatorBrain()
    
    @IBAction func clear(_ sender: UIButton) {
        displayValue = 0
        brain.clearContents()
        
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
       
        if brain.lastDescription != nil {
            if brain.resultIsPending {
                displaySequence.text = brain.lastDescription! + "..."
            } else {
                displaySequence.text = brain.lastDescription! + "="
            }
        }
    }
}

