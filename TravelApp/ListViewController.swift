//
//  ListViewController.swift
//  TravelApp
//
//  Created by Alfin on 14/02/23.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
  var titleArray = [String]()
  var idArray  = [UUID]()
  var chosenTitle = ""
  var chosenTitleID: UUID?
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
    navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let managedContext = appDelegate.persistentContainer.viewContext
//    let storeURL = managedContext.persistentStoreCoordinator?.persistentStores.first?.url
//    print(storeURL)
//    if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TravelApp.sqlite").path {
//        print(path)
//    }
    }

  override func viewWillAppear(_ animated: Bool) {
    getData()
    chosenTitle = ""
    chosenTitleID = nil

      NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)

  }
  @objc func addButtonClick() {
    performSegue(withIdentifier: "toViewController", sender: nil)
  }

 @objc func getData() {
    titleArray.removeAll(keepingCapacity: false)
    idArray.removeAll(keepingCapacity: false)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
    request.returnsObjectsAsFaults = false

    do {
      let results = try context.fetch(request)

      if results.count > 0 {
        // cast it because of ANY when fetch
        for result in results as! [NSManagedObject] {
          if let title = result.value(forKey: "title") as? String {

            self.titleArray.append(title)
          }

          if let id = result.value(forKey: "id") as? UUID {
            self.idArray.append(id)
          }
        }

      }

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    } catch {
      print("Cant Fetch")
    }

  }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return titleArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = titleArray[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    chosenTitle = titleArray[indexPath.row]
    chosenTitleID = idArray[indexPath.row]
    performSegue(withIdentifier: "toViewController", sender: nil)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toViewController" {
      let destinationVC = segue.destination as! ViewController
      destinationVC.selectedTitle = chosenTitle
      destinationVC.selectedTitleID = chosenTitleID
    }
  }

}
