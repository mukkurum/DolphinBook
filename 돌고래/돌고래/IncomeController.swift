//
//  IncomeController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 5. 25..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit
import SQLite
protocol incomeDelgate {
    func reloadData()
}
class IncomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, incomeDelgate {

    func getToday() -> String {
        // 오늘이 몇년 몇월인지 가져옴
        let today_ = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: today_)
    }
    // 날짜를 바꿔줌
    func changeIncomeDate() {
        incomeDateButton.text = Database1.focus_year_month_income.prefix(4) + "-" + Database1.focus_year_month_income.suffix(2)
    }
    // 이번달 수입을 바꿔줌
    func changeIncomeMonth() {
        // 이번달 총 수입 계산
        var month_income_sum = 0
        for income in Database1.IncomeList {
            let income_year_month = income[0].split(separator: "-")[0] + income[0].split(separator: "-")[1]
            if income_year_month == Database1.focus_year_month_income { // 같은 연, 월 확인
                month_income_sum += Int(income[1])!
            }
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let month_income_sum_ = numberFormatter.string(from: NSNumber(value: month_income_sum))
        incomeMonthField.text = month_income_sum_! + " 원"
    }
    
    func reloadData() {
        changeIncomeMonth()
        self.incomeTableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(Database1.IncomeListMonth.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        
        let row_ = Database1.IncomeListMonth[indexPath.row]

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
            let row_ = Database1.IncomeListMonth[indexPath.row]
            Database1.DolphinDatabase.delIncome(index: Int64(row_[3])!)
            // IncomeListMonth와 IncomeList를 새로고침해줌
            Database1.IncomeListMonth = self.loadIncomeTable()
            Database1.IncomeList = Database1.DolphinDatabase.loadIncome()
            // 테이블을 새로고침 함
            self.reloadData()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database1.focus_year_month_income = getToday()
        Database1.IncomeListMonth = loadIncomeTable()
        changeIncomeDate()
        changeIncomeMonth()
        createDatePicker()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showPopup(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "income_history") as! IncomePopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        popOverVC.delegate = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    func loadIncomeTable() -> Array<Array<String>> {
        return Database1.DolphinDatabase.loadIncomeMonth(focus_year_month: Database1.focus_year_month_income)
    }
    @IBOutlet weak var incomeTableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        Database1.IncomeListMonth = loadIncomeTable()
        self.incomeTableview.reloadData()
    }
    
    
    
    @IBOutlet weak var incomeDateButton: UITextField!
    @IBOutlet weak var incomeMonthField: UILabel!
    
    
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
        
        incomeDateButton.inputAccessoryView = toolbar
        
        // assigning date picker to text field
        incomeDateButton.inputView = datePicker
    }
    
    @objc func donePressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        incomeDateButton.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        dateFormatter.dateFormat = "yyyyMM"
        Database1.focus_year_month_income = dateFormatter.string(from: datePicker.date)
        Database1.IncomeListMonth = loadIncomeTable()
        changeIncomeMonth()
        self.incomeTableview.reloadData()
    }
    
    
}

