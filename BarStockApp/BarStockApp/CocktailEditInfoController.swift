//
//  CocktailEditInfoController.swift
//  BarStockApp
//
//  Created by Student43 on 20/06/2023.
//

import UIKit
import FirebaseDatabase

class CocktailEditInfoController: UIViewController {

    var databaseRef: DatabaseReference!
    @IBOutlet weak var alcName: UITextView!
    @IBOutlet weak var alcDesc: UITextView!
    @IBOutlet weak var alcImage: UIImageView!
    var selectedAlcohol: AlcoholStruct?
    override func viewDidLoad() {
        databaseRef = Database.database(url: "https://barstock-97b52-default-rtdb.europe-west1.firebasedatabase.app").reference()
        alcDesc.text = selectedAlcohol?.description
        alcName.text = selectedAlcohol?.name
        alcImage.image = UIImage(named: selectedAlcohol?.imageTitle ?? "noPhotoProvided")
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
//
    @IBAction func saveChanges(_ sender: Any) {
        guard let selectedAlcohol = selectedAlcohol,
              let newName = alcName.text,
              let newDescription = alcDesc.text else {
            return
        }

        let newImageTitle = selectedAlcohol.imageTitle

        editAlcoholInfo(selectedAlcohol: selectedAlcohol, newName: newName, newImageTitle: newImageTitle, newDescription: newDescription)
    }
    func editAlcoholInfo(selectedAlcohol: AlcoholStruct, newName: String, newImageTitle: String?, newDescription: String) {
        let alcoholRef = databaseRef.child("Cocktails").child(selectedAlcohol.id)

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
