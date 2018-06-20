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
    static let DolphinDatabase:Database1 = Database1(DBName: "db_dolphin1")
    static var focus_year_month_expense: String = ""
    static var ExpenseList: Array<Array<String>> = [] // 포커스 되어있는 달의 지출
    static var IncomeList: Array<Array<String>> = [] // 전체 수입

    private let db: Connection?
    
    private let ExpenseTable = Table("ExpenseTable")
    private let IncomeTable = Table("IncomeTable")
    private let id = Expression<Int64>("id")
    private let time = Expression<Date>("time")
    private let money = Expression<Int>("money")
    private let content = Expression<String>("content")
    
    // 디비 생성
    init(DBName : String) {
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        print("\(path)\(DBName).sqlite3")
        do {
            db = try Connection("\(path)\(DBName).sqlite3")
            createTableProduct()
        } catch {
            db = nil
        }
    }
    
    // 테이블 생성 함수
    func createTableProduct() {
        do {
            // 지출 테이블
            try db!.run(ExpenseTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(time)
                table.column(money)
                table.column(content)
            })
            // 수입 테이블
            try db!.run(IncomeTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(time)
                table.column(money)
                table.column(content)
            })
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
    // 수입 입력 함수
    func addIncome(time_: Date, money_: Int, content_: String) {
        do {
            let insert = IncomeTable.insert(time <- time_, money <- money_, content <- content_)
            try db!.run(insert)
        } catch {
            print("Cannot insert to database")
            return
        }
    }
    
    // 지출 삭제 함수
    func delExpense(index: Int64) {
        do {
            let selected_row = ExpenseTable.filter(id == index)
            try db!.run(selected_row.delete())
        } catch {
            print("Cannot delete row")
            return
        }
    }
    
    
    
    // Date형을 String으로 변형
    func getStringDayInfo(from:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: from)
    }
    // 지출 로드 함수 (선택된 달의 지출만 로드)
    func loadExpense(focus_year_month: String) -> Array<Array<String>> {
        var expense_list: Array<Array<String>> = []
        do {
            for expense in try db!.prepare(self.ExpenseTable) {
                let time_ = getStringDayInfo(from: expense[time])
                let expense_year_month = time_.split(separator: "-")[0] + time_.split(separator: "-")[1]
                if expense_year_month == focus_year_month {
                    var temp_list: Array<String> = []
                    print("time: \(time_), money: \(expense[money])원, content: \(expense[content])")
                    temp_list.append(time_)
                    temp_list.append(String(expense[money]))
                    temp_list.append(expense[content])
                    temp_list.append(String(expense[id]))
                    expense_list.append(temp_list)
                }
            }
        } catch {
            print("Cannot get list of product")
        }
        // 날짜 순 sort
        expense_list = expense_list.sorted(by: { $0[0] < $1[0] })
        return expense_list
        
    
    }
    // 수입 출력 함수
    /*func loadIncome() {
        do {
            print("========== 수입 상황 ==========")
            for income in try db!.prepare(self.IncomeTable) {
                let time_ = getStringDayInfo(from: income[time])
                print("time: \(time_), money: \(income[money])원, content: \(income[content])")
            }
        } catch {
            print("Cannot get list of product")
        }
    }*/
    func loadIncome() -> Array<Array<String>> {
        var income_list: Array<Array<String>> = []
        do {
            for income in try db!.prepare(self.IncomeTable) {
                var temp_list: Array<String> = []
                let time_ = getStringDayInfo(from: income[time])
                print("time: \(time_), money: \(income[money])원, content: \(income[content])")
                temp_list.append(time_)
                temp_list.append(String(income[money]))
                temp_list.append(income[content])
                income_list.append(temp_list)
            }
        } catch {
            print("Cannot get list of product")
        }
        // 날짜 순 sort
        income_list = income_list.sorted(by: { $0[0] < $1[0] })
        return income_list
    }
}
