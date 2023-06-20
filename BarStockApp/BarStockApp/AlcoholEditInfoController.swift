//
//  AlcoholEditInfoController.swift
//  BarStockApp
//
//  Created by Student43 on 20/06/2023.
//

import UIKit
import FirebaseDatabase

class AlcoholEditInfoController: UIViewController {
    var databaseRef: DatabaseReference!
    @IBOutlet weak var alcName: UITextField!
    @IBOutlet weak var alcDesc: UITextView!
    @IBOutlet weak var alcImage: UIImageView!
    var alcohol: AlcoholStruct?
    override func viewDidLoad() {
        databaseRef = Database.database(url: "https://barstock-97b52-default-rtdb.europe-west1.firebasedatabase.app").reference()
        alcDesc.text = alcohol?.description
        alcName.text = alcohol?.name
        alcImage.image = UIImage(named: alcohol?.imageTitle ?? "noPhotoProvided")
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
//
    @IBAction func saveChanges(_ sender: Any) {
        guard let alcohol = alcohol,
              let newName = alcName.text,
              let newDescription = alcDesc.text else {
            return
        }

        let newImageTitle = alcohol.imageTitle

        editAlcoholInfo(alcohol: alcohol, newName: newName, newImageTitle: newImageTitle, newDescription: newDescription)
    }
    func editAlcoholInfo(alcohol: AlcoholStruct, newName: String, newImageTitle: String?, newDescription: String) {
        let alcoholRef = databaseRef.child("Alcohols").child(alcohol.id)

        alcoholRef.child("name").setValue(newName)

        alcoholRef.child("imageTitle").setValue(newImageTitle)

        alcoholRef.child("description").setValue(newDescription)
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
