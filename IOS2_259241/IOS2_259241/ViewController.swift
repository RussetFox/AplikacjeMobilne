//
//  ViewController.swift
//  IOS2_259241
//
//  Created by Student43 on 15/06/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tempTextField: UITextField!
    
    @IBAction func zatwierdzButtonClicked(_ sender: Any) {
        var temperature: Double = 36.6
        if let inputTextTemp = tempTextField.text, let inputTemp = Double(inputTextTemp){
            temperature = inputTemp
        }
        if(temperature > 37.5){
            self.performSegue(withIdentifier: "WysokaTemp", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "NormalnaTemp", sender: self)
        }
    }
}

