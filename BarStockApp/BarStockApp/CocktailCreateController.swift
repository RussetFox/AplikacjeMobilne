//
//  CocktailCreateController.swift
//  BarStockApp
//
//  Created by Student43 on 20/06/2023.
//

import UIKit
import FirebaseDatabase
class CocktailCreateController: UIViewController {

    var databaseRef: DatabaseReference!
    var passedImageName = ""
    
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productName: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database(url: "https://barstock-97b52-default-rtdb.europe-west1.firebasedatabase.app").reference()
    }
    @IBAction func createEntity(_ sender: Any) {
        createNewAlcohol(imageTitle: "", name: productName.text ?? "", description: productDesc.text)
    }
    
    func createNewAlcohol(imageTitle: String, name: String, description: String) {
        let alcoholRef = databaseRef.child("Cocktails").childByAutoId()
        
        let newAlcohol = [
            "imageTitle": passedImageName,
            "name": name,
            "description": description
        ]
        
        alcoholRef.setValue(newAlcohol)
    }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

