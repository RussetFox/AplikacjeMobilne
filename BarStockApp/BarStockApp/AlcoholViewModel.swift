//
//  AlcoholViewFile.swift
//  BarStockApp
//
//  Created by Student43 on 20/06/2023.
//

import Foundation
import FirebaseFirestore

class AlcoholViewModel : ObservableObject{
    @Published var alcohols = [AlcoholStruct]()
    private var db = Firestore.firestore()
    func fetchAlcoholData() {
        let db = Firestore.firestore()
        db.collection("Alcohols").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching alcohols: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No snapshot available")
                return
            }
            
            self.alcohols = snapshot.documents.compactMap { document -> AlcoholStruct? in
                let data = document.data()
                let name = data["name"] as? String ?? ""
                let imageTitle = data["imageTitle"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                return AlcoholStruct(name: name, imageTitle: imageTitle, description: description)
            }
        }
    }
    
}
