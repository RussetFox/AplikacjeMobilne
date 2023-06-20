//
//  ViewController.swift
//  IOS1_259241
//
//  Created by Student43 on 01/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipAmmount: UITextField!
    @IBOutlet weak var tipPercentage: UITextField!
    
    @IBOutlet weak var priceFinal: UITextField!
    @IBOutlet weak var tipFinal: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calculateButton(_ sender: Any) {
        guard let tipAmmountText = tipAmmount.text,
              let tipPercentageText = tipPercentage.text,
              let tipAmmountNumber = Double(tipAmmountText),
              let tipPercentageNumber = Double(tipPercentageText)
        else{
            tipFinal.text = "Blad wprowadzania"
            return
        }
        let finalTip = tipAmmountNumber * tipPercentageNumber * 0.01
        let finalReceipt = tipAmmountNumber + finalTip
        tipFinal.text=String(finalTip) + " PLN"
        priceFinal.text = String(finalReceipt) + " PLN"
    }
    
}

