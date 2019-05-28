//
//  CurrencyTextField.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/18/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

protocol NumberTextFieldDelegate: class {
    func textDidChange(_ textField: NumberTextField)
}

class NumberTextField: UITextField {
    fileprivate let maxDigits = 12

    fileprivate let defaultValue: Double = 0.00

    fileprivate let currencyFormattor = NumberFormatter()

    fileprivate var previousValue : String = ""

    weak var numberDelegate: NumberTextFieldDelegate?

    lazy var amount = defaultValue

    // MARK: - init functions

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initTextField()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTextField()
    }

    func initTextField(){
        self.keyboardType = UIKeyboardType.decimalPad
        currencyFormattor.numberStyle = .decimal
        currencyFormattor.minimumFractionDigits = 2
        currencyFormattor.maximumFractionDigits = 2
        setAmount(defaultValue)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }

    // MARK: - UITextField Notifications
    @objc func textDidChange() {
        //Get the original position of the cursor
        let cursorOffset = getOriginalCursorPosition();

        let cleanNumericString : String = getCleanNumberString()
        let textFieldLength = self.text?.count

        if cleanNumericString.count > maxDigits{
            self.text = previousValue
        }
        else{
            let textFieldNumber = Double(cleanNumericString)
            if let textFieldNumber = textFieldNumber{
                let textFieldNewValue = textFieldNumber/100
                setAmount(textFieldNewValue)
            }else{
                self.text = previousValue
            }
        }
        //Set the cursor back to its original poistion
        setCursorOriginalPosition(cursorOffset, oldTextFieldLength: textFieldLength)

        numberDelegate?.textDidChange(self)
    }

    //MARK: - Custom text field functions

    func setAmount (_ amount : Double) {
        self.amount = amount
        let textFieldStringValue = currencyFormattor.string(from: NSNumber(value: amount))
        self.text = textFieldStringValue
        if let textFieldStringValue = textFieldStringValue {
            previousValue = textFieldStringValue
        }
    }

    //MARK - helper functions
    func getCleanNumberString() -> String {
        var cleanNumericString: String = ""
        let textFieldString = self.text
        if let textFieldString = textFieldString{

            //Remove $ sign
            var toArray = textFieldString.components(separatedBy: "$")
            cleanNumericString = toArray.joined(separator: "")

            //Remove periods, commas
            toArray = cleanNumericString.components(separatedBy: CharacterSet.punctuationCharacters)
            cleanNumericString = toArray.joined(separator: "")
        }

        return cleanNumericString
    }

    fileprivate func getOriginalCursorPosition() -> Int{

        var cursorOffset : Int = 0
        let startPosition : UITextPosition = self.beginningOfDocument
        if let selectedTextRange = self.selectedTextRange{
            cursorOffset = self.offset(from: startPosition, to: selectedTextRange.start)
        }
        return cursorOffset
    }

    fileprivate func setCursorOriginalPosition(_ cursorOffset: Int, oldTextFieldLength : Int?){

        let newLength = self.text?.count
        let startPosition : UITextPosition = self.beginningOfDocument
        if let oldTextFieldLength = oldTextFieldLength, let newLength = newLength, oldTextFieldLength > cursorOffset{
            let newOffset = newLength - oldTextFieldLength + cursorOffset
            let newCursorPosition = self.position(from: startPosition, offset: newOffset)
            if let newCursorPosition = newCursorPosition{
                let newSelectedRange = self.textRange(from: newCursorPosition, to: newCursorPosition)
                self.selectedTextRange = newSelectedRange
            }

        }
    }
}
