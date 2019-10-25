//
//  Person.swift
//  PairRandomizer
//
//  Created by Christopher Alegre on 10/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import CloudKit

struct PersonKeys {
    static let typeKey = "Person"
    static let nameKey = "name"
}

class Person {
    var name: String
    let ckRecordID: CKRecord.ID
    
    init(name: String, ckRecord: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.ckRecordID = ckRecord
    }
    
    convenience init?(ckRecord: CKRecord) {
             guard let name = ckRecord[PersonKeys.nameKey] as? String
                else {return nil}
            self.init(name: name, ckRecord: ckRecord.recordID)
        }
    }

extension CKRecord {
    convenience init(person: Person) {
        self.init(recordType: PersonKeys.typeKey, recordID: person.ckRecordID)
        self.setValuesForKeys([
            PersonKeys.nameKey : person.name,
        ])
    }
}
