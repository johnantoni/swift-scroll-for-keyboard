//
//  ViewController.swift
//  ScrollForKeyboard
//
//  Created by R. Tony Goold on 2015-03-24.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // This is called whenever the user types in the field.
        //   textField: The text field being typed in (helpful to distinguish when you have a bunch)
        //   range: The portion of text that is selected and will be replaced
        //   string: The text the user is entering (usually one character for keyboard, but can also be a paste)
        println("Replacing range \(range.location) + \(range.length) with \(string)")

        // Return false if you want to ignore what the user typed/pasted.
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // This is called whenever the user taps the Return key.
        println("Return tapped")

        // Generally, it doesn't matter what you return here. The docs say
        // “if the text field should implement its default behavior for the return button”
        // but there is no default behaviour.
        return true
    }
}

