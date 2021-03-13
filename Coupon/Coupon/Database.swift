//
//  Database.swift
//  Coupon
//
//  Created by 김지나 on 2020/12/29.
//  Copyright © 2020 김지나. All rights reserved.
//

import UIKit
import SQLite3

struct Database {
    static let shared = Database()
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
        let creatQuery = "CREATE TABLE IF NOT EXISTS coupon(id INTEGER primary key, category TEXT, shop TEXT, price TEXT, expireDate TEXT, content TEXT, contentPhoto BLOB)"
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
    func readDB(select: String, id: Int = 0) -> [Coupon] {
        var selectQuery = "SELECT * FROM coupon"
        var selectStmt: OpaquePointer? = nil
        var coupon = [Coupon]()
        
        if select != "전체" {
            selectQuery = "SELECT * FROM coupon WHERE category = '\(select)'"
        }  else if id != 0 {
            selectQuery = "SELECT * FROM coupon WHERE id = '\(id)'"
        }
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStmt, nil) == SQLITE_OK {
            while sqlite3_step(selectStmt) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(selectStmt, 0))
                let category = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
                let shop = String(describing: String(cString: sqlite3_column_text(selectStmt, 2)))
                let price = String(describing: String(cString: sqlite3_column_text(selectStmt, 3)))
                let expireDate = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(selectStmt, 4))
                let content = String(describing: String(cString: sqlite3_column_text(selectStmt, 5)))
                
                let lenght:Int = Int(sqlite3_column_bytes(selectStmt, 6))
                let contentPhoto : NSData = NSData(bytes: sqlite3_column_blob(selectStmt, 6), length: lenght)
                let contentImg = UIImage(data: contentPhoto as Data)
                coupon.append(Coupon(id: id, category: category, shop: shop, price: price, expireDate: expireDate, content: content, contentPhoto: contentImg))
            }
        } else {
            print("ERROR select statement could not be prepared")
        }
        sqlite3_finalize(selectStmt)
        return coupon
    }
    
    // insert data
    func insert(id: Int, category: String, shop: String, price: String, expireDate: Date, content: String, contentPhoto: UIImage) {
        let insertQuery = "INSERT INTO coupon(id, category, shop, price, expireDate, content, contentPhoto) VALUES(?,?,?,?,?,?,?)"
        var insertStmt:OpaquePointer? = nil
        let imgData = contentPhoto.pngData() as NSData?

        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStmt, 1, Int32(id))
            sqlite3_bind_text(insertStmt, 2, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, (shop as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 4, (price as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStmt, 5, expireDate.timeIntervalSinceReferenceDate)
            sqlite3_bind_text(insertStmt, 6, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_blob(insertStmt, 7, imgData?.bytes, Int32(imgData?.length ?? 0), nil)
            
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
    
    // 삭제
        func delete(cell: Int) {
            let deleteQuery = "DELETE FROM coupon WHERE id = \(cell)"
            var deleteStmt: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStmt, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStmt, 1, Int32(cell))
                
                if sqlite3_step(deleteStmt) == SQLITE_DONE {
                    print("success delete")
                } else {
                    print("fail delete")
                }
            } else {
                print("delete not be prepared")
            }
            
            sqlite3_finalize(deleteStmt)
        }
    
    // 수정
    func update(id: Int, item: String, revised contents: String) {
        let updateQuery = "UPDATE coupon SET \(item) = '\(contents)' WHERE id == \(id)"
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStmt, nil) == SQLITE_OK {
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                print("success update")
            } else {
                print("fail update")
            }
        } else {
            print("update could not be prepared")
        }
        
        sqlite3_finalize(updateStmt)
    }
    
    // ID 최대값
    func getID() -> Int {
            let selectIDQuery = "SELECT max(id) FROM coupon"
            var selectStmt: OpaquePointer? = nil
            var index = 0
            if sqlite3_prepare_v2(db, selectIDQuery, -1, &selectStmt, nil) == SQLITE_OK {
                while sqlite3_step(selectStmt) == SQLITE_ROW {
                    index = Int(sqlite3_column_int(selectStmt, 0))
                }
            } else {
                print("ERROR select statement could not be prepared")
            }
            sqlite3_finalize(selectStmt)
            return index
        }

}
