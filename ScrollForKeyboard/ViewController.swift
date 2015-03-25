//
//  ViewController.swift
//  ScrollForKeyboard
//
//  Created by R. Tony Goold on 2015-03-24.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // We need a way of referring to our scroll view so we can resize it when the
    // keyboard shows or hides
    @IBOutlet var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Observe keyboard show/hide events
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }

    // A special function called when an object is deleted
    deinit {
        // If an object observes notifications, it needs to stop observing notifications
        // when it is deleted, or else crashes might happen.
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func keyboardDidShow(notification: NSNotification) {
        var frameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        if let frame = frameValue?.CGRectValue() {
            // Set a bottom "inset" on the scroll that acts like padding, so we can
            // scroll what's hidden under the keyboard
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.size.height, right: 0)
        }
    }

    func keyboardDidHide(notification: NSNotification) {
        // When the keyboard hides, we can get rid of the inset
        self.scrollView.contentInset = UIEdgeInsetsZero
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // This is called whenever the user types in the field.
        //   textField: The text field being typed in (helpful to distinguish when you have a bunch)
        //   range: The portion of text that is selected and will be replaced
        //   string: The text the user is entering (usually one character for keyboard, but can also be a paste)

        // We don't place any restrictions on the e-mail field, which has tag == 2
        if textField.tag == 2 {
            return true;
        }

        // The meaning of "length" isn't simple when it comes to international text!
        // Our simplified measurement:
        // 1. Take the length of what's already in the text field.
        var length = textField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        // 2. Subtract the length of the current selection, which will be deleted.
        length -= range.length
        // 3. Add the length of the text being inserted.
        length += string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

        // Restrict the length to 12 or less for username and password
        return length <= 12
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // This is called whenever the user taps the Return key.

        if textField.tag == 1 {
            // The first text field (username) activates the second (email)
            self.view.viewWithTag(2)?.becomeFirstResponder()
        }
        else if textField.tag == 2 {
            // The second text field (email) activates the third (password)
            self.view.viewWithTag(3)?.becomeFirstResponder()
        }
        else if textField.tag == 3 {
            // Return in the password text field acts as if "Create Account" was tapped
            joinPressed(textField)
        }
        else {
            println("You forgot to set a tag on the text fields in the storyboard!")
        }

        // Generally, it doesn't matter what you return here. The docs say
        // “if the text field should implement its default behavior for the return button”
        // but there is no default behaviour.
        return true
    }

    @IBAction func joinPressed(sender: AnyObject?) {
        // The "sender" parameter will be either the text field where return was tapped or the
        // "Create Account" button. You could gather statistics on this to measure the
        // effectiveness of an account creation page.

        // Here's how you would distinguish which class "sender" is:
        if let textField = sender as? UITextField {
            println("Submitting via return in text field")
        }
        else if let button = sender as? UIButton {
            println("Submitting via button")
        }
        else {
            println("You've got something unexpected hooked up to the joinPressed: action!")
        }

        // Don't forget to dismiss the keyboard! This will find the appropriate text field
        // and call resignFirstResponder() on it.
        self.view.endEditing(true)
    }
}

