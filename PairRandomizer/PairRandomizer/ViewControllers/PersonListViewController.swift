//
//  PersonListViewController.swift
//  PairRandomizer
//
//  Created by Christopher Alegre on 10/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {
    
    var sections: [[String]] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.delegate = self
        tableView.dataSource = self

    }
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        alertController()
    }
    
    @IBAction func randomizeGroupsButtonTapped(_ sender: Any) {
        
    }
    
    private func loadData() {
        PersonController.sharedPerson.fetchPersons { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func alertController() {
        let alertController = UIAlertController(title: "Add Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
        }
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let personName = alertController.textFields?.first?.text,
                !personName.isEmpty
                else {return}
            PersonController.sharedPerson.addPerson(name: personName) { (success) in }
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true)
    }
}

extension PersonListViewController: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let name = PersonController.sharedPerson.persons[indexPath.row].name
        cell.textLabel?.text = name
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            sections[indexPath.section].remove(at: indexPath.row)
//            guard let persons = persons.first else {return}
//            PersonController.sharedPerson.deletePerson(person: persons) { (success) in }
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
}
