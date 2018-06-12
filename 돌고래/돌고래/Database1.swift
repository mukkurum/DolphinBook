//
//  Database1.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 6. 11..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import Foundation
import SQLite

public class Database1 {
    
    private let db: Connection?
    
    private let ExpenseTable = Table("ExpenseTable")
    private let id = Expression<Int64>("id")
    private let time = Expression<Date>("time")
    private let money = Expression<Int>("money")
    private let content = Expression<String>("content")
    
    
    init(DBName : String) {
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("\(path)\(DBName).sqlite3")
        do {
            db = try Connection("\(path)\(DBName).sqlite3")
            createTableProduct()
        } catch {
            db = nil
        }
    }
    
    func createTableProduct() {
        do {
            try db!.run(ExpenseTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(time)
                table.column(money)
                table.column(content)
            })
            // incomeTable도 만들어야 함
            print("create table successfully")
        } catch {
            print("Fail to create table")
        }
    }
    
    // 지출 입력 함수
    func addExpense(time_: Date, money_: Int, content_: String) {
        do {
            let insert = ExpenseTable.insert(time <- time_, money <- money_, content <- content_)
            try db!.run(insert)
        } catch {
            print("Cannot insert to database")
            return
        }
    }
    
    // Date형을 String으로 변형
    func getStringDayInfo(from:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: from)
    }
    // 지출 출력 함수
    func loadExpense() {
        do {
            for expense in try db!.prepare(self.ExpenseTable) {
                let time_ = getStringDayInfo(from: expense[time])
                print("time: \(time_), money: \(expense[money])원, content: \(expense[content])")
                // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
        } catch {
            print("Cannot get list of product")
        }
    }
    
}
