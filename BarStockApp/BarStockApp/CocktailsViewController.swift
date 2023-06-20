//
//  CocktailsViewController.swift
//  BarStockApp
//
//  Created by Student43 on 19/06/2023.
//

import UIKit
import FirebaseDatabase

class CocktailsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var cocktailTable : UITableView!
    var cocktails: [AlcoholStruct] = []
    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cocktails"
        cocktailTable.dataSource = self

        databaseRef = Database.database(url: "https://barstock-97b52-default-rtdb.europe-west1.firebasedatabase.app").reference()

        observeAlcoholData()
    }

    func observeAlcoholData() {
        databaseRef.child("Cocktails").observe(.value) { [weak self] (snapshot) in
            guard let self = self else { return }

            self.cocktails.removeAll()

            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let dict = childSnapshot.value as? [String: Any],
                   let name = dict["name"] as? String,
                   let imageTitle = dict["imageTitle"] as? String,
                   let description = dict["description"] as? String,
                   let id = childSnapshot.key as? String {
                    let alcohol = AlcoholStruct(id: id, name: name, imageTitle: imageTitle, description: description)
                    self.cocktails.append(alcohol)
                }
            }

            self.cocktailTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alcohol = cocktails[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell", for: indexPath) as! CocktailTableViewCell
        cell.label.text = alcohol.name
        cell.iconImageView.image = UIImage(named: alcohol.imageTitle)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))

        tapGesture.numberOfTapsRequired = 1

        cell.addGestureRecognizer(tapGesture)
        cell.addGestureRecognizer(longPressGesture)

        cell.layer.cornerRadius = 15
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.height / 5
        cell.label.layer.cornerRadius = cell.label.frame.height / 5

        return cell
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if let cell = gestureRecognizer.view as? UITableViewCell,
               let indexPath = cocktailTable.indexPath(for: cell) {
                let alcohol = cocktails[indexPath.row]
                navigateToDetailView(alcohol: alcohol)
            }
        }
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            if let cell = gestureRecognizer.view as? UITableViewCell,
               let indexPath = cocktailTable.indexPath(for: cell) {
                let alcohol = cocktails[indexPath.row]
                showOptionsMenu(alcohol: alcohol)
            }
        }
    }

    func navigateToDetailView(alcohol: AlcoholStruct) {
        performSegue(withIdentifier: "CocktailInfoSegue", sender: alcohol)
    }

    func showOptionsMenu(alcohol: AlcoholStruct) {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            self.editAlcohol(alcohol)
        }

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteAlcohol(alcohol)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func editAlcohol(_ alcohol: AlcoholStruct) {
        performSegue(withIdentifier: "CocktailEditInfoSegue", sender: alcohol)
    }

    func deleteAlcohol(_ alcohol: AlcoholStruct) {

        if let index = cocktails.firstIndex(where: { $0.id == alcohol.id }) {
            cocktails.remove(at: index)
            
            cocktailTable.reloadData()
            
            let alcoholRef = databaseRef.child("Cocktails").child(alcohol.id)
            alcoholRef.removeValue { (error, _) in
                if let error = error {
                    print("Error removing cocktail from Firebase: \(error.localizedDescription)")
                } else {
                    print("Alcohol removed from Firebase successfully.")
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CocktailInfoSegue",
           let destinationVC = segue.destination as? CocktailInfoController,
           let alcohol = sender as? AlcoholStruct {
            destinationVC.selectedAlcohol = alcohol
        } else if segue.identifier == "CocktailEditInfoSegue",
                  let destinationVC = segue.destination as? CocktailEditInfoController,
                  let alcohol = sender as? AlcoholStruct {
            destinationVC.selectedAlcohol = alcohol
        }
    }

}
