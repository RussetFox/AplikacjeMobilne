//
//  CockailInfoController.swift
//  BarStockApp
//
//  Created by Student43 on 20/06/2023.
//

import UIKit

class CocktailInfoController: UIViewController {
    
    var selectedAlcohol: AlcoholStruct?

        @IBOutlet weak var alcDesc: UITextView!
        @IBOutlet weak var alcName: UILabel!
        @IBOutlet weak var alcImage: UIImageView!
        override func viewDidLoad() {
            alcDesc.text = selectedAlcohol?.description
            alcName.text = selectedAlcohol?.name
            alcImage.image = UIImage(named: selectedAlcohol?.imageTitle ?? "noPhotoProvided")
            super.viewDidLoad()
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
