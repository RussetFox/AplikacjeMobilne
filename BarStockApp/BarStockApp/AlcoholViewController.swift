import UIKit
import FirebaseDatabase

class AlcoholViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var alcoholTable: UITableView!

    var alcohols: [AlcoholStruct] = []
    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alcohols"
        alcoholTable.dataSource = self

        databaseRef = Database.database(url: "https://barstock-97b52-default-rtdb.europe-west1.firebasedatabase.app").reference()

        observeAlcoholData()
    }

    func observeAlcoholData() {

        databaseRef.child("Alcohols").observe(.value) { [weak self] (snapshot) in
            guard let self = self else { return }

            self.alcohols.removeAll()

            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let dict = childSnapshot.value as? [String: Any],
                   let name = dict["name"] as? String,
                   let imageTitle = dict["imageTitle"] as? String,
                   let description = dict["description"] as? String,
                   let id = childSnapshot.key as? String {
                    let alcohol = AlcoholStruct(id: id, name: name, imageTitle: imageTitle, description: description)
                    self.alcohols.append(alcohol)
                }
            }

            self.alcoholTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alcohols.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alcohol = alcohols[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlcoholCell", for: indexPath) as! TableViewCell
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
               let indexPath = alcoholTable.indexPath(for: cell) {
                let alcohol = alcohols[indexPath.row]
                navigateToDetailView(alcohol: alcohol)
            }
        }
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            if let cell = gestureRecognizer.view as? UITableViewCell,
               let indexPath = alcoholTable.indexPath(for: cell) {
                let alcohol = alcohols[indexPath.row]
                showOptionsMenu(alcohol: alcohol)
            }
        }
    }

    func navigateToDetailView(alcohol: AlcoholStruct) {
        performSegue(withIdentifier: "AlcoholInfoSegue", sender: alcohol)
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
        performSegue(withIdentifier: "AlcoholEditInfoSegue", sender: alcohol)
    }

    func deleteAlcohol(_ alcohol: AlcoholStruct) {

        if let index = alcohols.firstIndex(where: { $0.id == alcohol.id }) {
            alcohols.remove(at: index)
            
            alcoholTable.reloadData()
            
            let alcoholRef = databaseRef.child("Alcohols").child(alcohol.id)
            alcoholRef.removeValue { (error, _) in
                if let error = error {
                    print("Error removing alcohol from Firebase: \(error.localizedDescription)")
                } else {
                    print("Alcohol removed from Firebase successfully.")
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlcoholInfoSegue",
           let destinationVC = segue.destination as? AlcoholInfoViewController,
           let alcohol = sender as? AlcoholStruct {
            destinationVC.selectedAlcohol = alcohol
        } else if segue.identifier == "AlcoholEditInfoSegue",
                  let destinationVC = segue.destination as? AlcoholEditInfoController,
                  let alcohol = sender as? AlcoholStruct {
            destinationVC.alcohol = alcohol
        }
    }
}
