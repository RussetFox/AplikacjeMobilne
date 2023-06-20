//
//  NewAlcoholController.swift
//  BarStockApp
//
//  Created by Student43 on 20/06/2023.
//

import UIKit
import FirebaseDatabase
class NewAlcoholController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var databaseRef: DatabaseReference!
    var passedImageName = ""
    
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database(url: "https://barstock-97b52-default-rtdb.europe-west1.firebasedatabase.app").reference()
    }
    @IBAction func createEntity(_ sender: Any) {
        createNewAlcohol(imageTitle: "", name: productName.text ?? "", description: productDesc.text)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        capturePhoto()
        
    }
    func capturePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            let filename = UUID().uuidString + ".jpg"
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let fileURL = documentsDirectory.appendingPathComponent(filename)
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                do {
                    try imageData.write(to: fileURL)
                    print("Image saved at: \(fileURL)")
                    
                    let passedImageName = filename
                    
                } catch {
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
    }

    func createNewAlcohol(imageTitle: String, name: String, description: String) {
        let alcoholRef = databaseRef.child("Alcohols").childByAutoId()
        
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

