//
//  ExpenseController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 5. 25..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit
import SQLite
protocol expenseDelgate {
    func reloadData()
}

class ExpenseController: UIViewController, UITableViewDelegate, UITableViewDataSource, expenseDelgate {
    
    func getToday() -> String {
        // 오늘이 몇년 몇월인지 가져옴
        let today_ = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: today_)
    }
    func changeExpenseDate() {
        expenseDateButton.text = Database1.focus_year_month_expense.prefix(4) + "-" + Database1.focus_year_month_expense.suffix(2)
    }
    func changeLeftMoney() {
        // 이번달 총 수입 계산
        var month_income_sum = 0
        for income in Database1.IncomeList {
            let income_year_month = income[0].split(separator: "-")[0] + income[0].split(separator: "-")[1]
            if income_year_month == Database1.focus_year_month_expense { // 같은 연, 월 확인
                month_income_sum += Int(income[1])!
            }
        }
        // 이번달 총 지출 계산
        var month_expense_sum = 0 // 이번달 총 수입
        for expense in Database1.ExpenseList {
            month_expense_sum += Int(expense[1])!
        }
        let left_money = month_income_sum - month_expense_sum // 남은 돈
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let left_money_ = numberFormatter.string(from: NSNumber(value: left_money))
        moneyLeftField.text = left_money_! + " 원"
    }
    
    func reloadData() {
        changeLeftMoney()
        self.expenseTableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(Database1.ExpenseList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "expenseCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let row_ = Database1.ExpenseList[indexPath.row]
        
        let money_int = Int(row_[1])!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let money_ = numberFormatter.string(from: NSNumber(value: money_int))!
        
        cell.textLabel?.text = "\(row_[0]):     \(row_[2])"
        cell.detailTextLabel?.text = "\(money_) 원"
        
        return(cell)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Del") { (action, indexPath) in
            // 아이템을 지움
            print("\(indexPath)번째 cell을 Delete 합니다.")
            let row_ = Database1.ExpenseList[indexPath.row]
            Database1.DolphinDatabase.delExpense(index: Int64(row_[3])!)
            // ExpenseList를 새로고침해줌
            Database1.ExpenseList = self.loadExpenseTable()
            // 테이블을 새로고침 함
            self.reloadData()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Database1.focus_year_month_expense = getToday()
        Database1.ExpenseList = loadExpenseTable()
        changeExpenseDate()
        changeLeftMoney()
        createDatePicker()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPopup(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "expense_history") as! ExpensePopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        popOverVC.delegate = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func loadExpenseTable() -> Array<Array<String>> {
        return Database1.DolphinDatabase.loadExpense(focus_year_month: Database1.focus_year_month_expense)
    }
    @IBOutlet weak var expenseTableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        Database1.ExpenseList = loadExpenseTable()
        changeLeftMoney()
        self.expenseTableview.reloadData()
    }
    
    
    
    @IBOutlet weak var expenseDateButton: UITextField!
    @IBOutlet weak var moneyLeftField: UILabel!
    
    
    let datePicker = UIDatePicker()
    
    func createDatePicker() {
        // format for picker
        datePicker.datePickerMode = .date
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        expenseDateButton.inputAccessoryView = toolbar
        
        // assigning date picker to text field
        expenseDateButton.inputView = datePicker
    }
    
    @objc func donePressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        expenseDateButton.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        dateFormatter.dateFormat = "yyyyMM"
        Database1.focus_year_month_expense = dateFormatter.string(from: datePicker.date)
        Database1.ExpenseList = loadExpenseTable()
        changeLeftMoney()
        self.expenseTableview.reloadData()
    }

}

