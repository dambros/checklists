//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mario D'Ambros Filho on 21/11/16.
//  Copyright © 2016 Dambros' apps. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    fileprivate let textKey = "Text"
    fileprivate let checkedKey = "Checked"
    fileprivate let dueDateKey = "DueDate"
    fileprivate let shouldRemindKey = "ShouldRemind"
    fileprivate let itemIDKey = "ItemID"
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject    (forKey: textKey) as! String
        checked = aDecoder.decodeBool(forKey: checkedKey)
        dueDate = aDecoder.decodeObject(forKey: dueDateKey) as! Date
        shouldRemind = aDecoder.decodeBool(forKey: shouldRemindKey)
        itemID = aDecoder.decodeInteger(forKey: itemIDKey)
        
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: textKey)
        aCoder.encode(checked, forKey: checkedKey)
        aCoder.encode(dueDate, forKey: dueDateKey)
        aCoder.encode(shouldRemind, forKey: shouldRemindKey)
        aCoder.encode(itemID, forKey: itemIDKey)
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {

            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
