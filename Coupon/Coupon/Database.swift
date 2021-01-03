//
//  Database.swift
//  Coupon
//
//  Created by 김지나 on 2020/12/29.
//  Copyright © 2020 김지나. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

struct Database {
    let dbName = "coupon.sqlite"
    var db: OpaquePointer?
    
    init() {
        db = openDB()
        createTable()
    }
    
    // db open
    func openDB() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("ERROR opening database")
            return nil
        } else {
            print("SUCCESS: \(dbName)")
            return db
        }
    }
    
    // create table
    func createTable() {
        let creatQuery = "CREATE TABLE IF NOT EXISTS coupon(category TEXT, shop TEXT, price TEXT, expireDate TEXT, content TEXT, contentPhoto BLOB)"
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, creatQuery, -1, &createStmt, nil) == SQLITE_OK {
            if sqlite3_step(createStmt) == SQLITE_DONE {
                print("SUCCESS create coupon table")
            } else {
                print("create table statement could not be prepared")
            }
            sqlite3_finalize(createStmt)
        }
    }
    
    // read db
    func readDB() -> [Coupon] {
        let selectQuery = "SELECT * FROM coupon"
        var selectStmt: OpaquePointer? = nil
        var coupon = [Coupon]()
        
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStmt, nil) == SQLITE_OK {
            while sqlite3_step(selectStmt) == SQLITE_ROW {
                let category = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
                let shop = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
                let price = String(describing: String(cString: sqlite3_column_text(selectStmt, 2)))
                let expireDate = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(selectStmt, 3))
                let content = String(describing: String(cString: sqlite3_column_text(selectStmt, 4)))
                
                let lenght:Int = Int(sqlite3_column_bytes(selectStmt, 5));
                let contentPhoto : NSData = NSData(bytes: sqlite3_column_blob(selectStmt, 5), length: lenght)
                let contentImg = UIImage(data: contentPhoto as Data)
                coupon.append(Coupon(category: category, shop: shop, price: price, expireDate: expireDate, content: content, contentPhoto: contentImg))
            }
        } else {
            print("ERROR select statement could not be prepared")
        }
        sqlite3_finalize(selectStmt)
        return coupon
    }
    
    // insert data
    func insert(category: String, shop: String, price: String, expireDate: Date, content: String, contentPhoto: UIImage) {
        let insertQuery = "INSERT INTO coupon(category, shop, price, expireDate, content, contentPhoto) VALUES(?,?,?,?,?,?)"
        var insertStmt:OpaquePointer? = nil
        let imgData = contentPhoto.pngData()
        let img64 = imgData?.base64EncodedString(options: .lineLength64Characters)
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStmt, 1, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (shop as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, (price as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStmt, 4, expireDate.timeIntervalSinceReferenceDate)
            sqlite3_bind_text(insertStmt, 5, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_blob(insertStmt, 6, img64, -1, nil)
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("SUCCESS")
            } else {
                print("ERROR could not insert")
            }
        } else {
            print("ERROR insert statement could not be prepared")
        }
        sqlite3_finalize(insertStmt)
    }
}
