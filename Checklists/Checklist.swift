//
//  Checklist.swift
//  Checklists
//
//  Created by Mario D'Ambros Filho on 21/11/16.
//  Copyright © 2016 Dambros' apps. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {

    var name : String
    var items = [ChecklistItem]()
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    let nameKey = "Name"
    let itemsKey = "Items"
    let iconNameKey = "IconName"
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        items = aDecoder.decodeObject(forKey: itemsKey) as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: iconNameKey) as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(items, forKey: itemsKey)
        aCoder.encode(iconName, forKey: iconNameKey)
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    func sortItems() {
        items.sort(by: {
            item1, item2 in
            return item1.dueDate.compare(item2.dueDate) == .orderedAscending
        })
    }
    
}
