//
//  DataModel.swift
//  Checklists
//
//  Created by Mario D'Ambros Filho on 23/11/16.
//  Copyright © 2016 Dambros' apps. All rights reserved.
//

import Foundation

class DataModel {
    let checklistIndexKey = "ChecklistIndex"
    let firstTimeKey = "FirstTime"
    static let checklistItemID = "ChecklistItemID"
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: checklistIndexKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: checklistIndexKey)
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    let documentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    var dataFilePath: URL {
        return documentsDirectory.appendingPathComponent("Checklists.plist")
    }
    
    fileprivate let checkListItemsID = "Checklists"
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: checkListItemsID)
        archiver.finishEncoding()
        data.write(to: dataFilePath, atomically: true)
    }
    
    func loadChecklists() {
        if let data = try? Data(contentsOf: dataFilePath) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: checkListItemsID) as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
    
    func registerDefaults() {
        let dictionary: [String : Any] = [checklistIndexKey: -1,
                                          firstTimeKey: true,
                                          checkListItemsID: 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: firstTimeKey)
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: firstTimeKey)
            userDefaults.synchronize()
        }
        
    }
    
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
        for list in lists {
            list.sortItems()
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: checklistItemID)
        userDefaults.set(itemID + 1, forKey: checklistItemID)
        userDefaults.synchronize()
        return itemID
    }

}
