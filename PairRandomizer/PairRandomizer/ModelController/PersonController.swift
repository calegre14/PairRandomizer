//
//  PersonController.swift
//  PairRandomizer
//
//  Created by Christopher Alegre on 10/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import CloudKit

class PersonController {
    static let sharedPerson = PersonController()
    
    var persons: [Person] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func addPerson(name: String, completion: @escaping (Bool) -> Void) {
        let newPerson = Person(name: name)
        
        save(person: newPerson) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
    
    func deletePerson(person: Person, completion: @escaping (_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [person.ckRecordID])
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard person.ckRecordID == recordIDs?.first else {
                print("Unexpected record was set to delete")
                completion(false)
                return
            }
            print("Deleted \(person.ckRecordID) from CloudKit successfully.")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    
    func save(person: Person, completion: @escaping (Bool) -> ()) {
        let personRecord = CKRecord(person: person)
        
        publicDB.save(personRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let savePerson = Person(ckRecord: record)
                else {completion(false); return}
            
            self.persons.append(savePerson)
            completion(true)
        }
    }
    
    func fetchPersons(completion: @escaping (Bool) -> ()) {
        
        let predicate = NSPredicate(value: true)
        let ckQuery = CKQuery(recordType: PersonKeys.typeKey, predicate: predicate)
        publicDB.perform(ckQuery, inZoneWith: nil) { (foundPersons, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let records = foundPersons else {
                completion(false)
                return
            }
            let persons = records.compactMap({ Person(ckRecord: $0) })
            self.persons = persons
            completion(true)
        }
    }
}
