//
//  ExpensePopupViewController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 6. 12..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit

class ExpensePopupViewController: UIViewController {

    var delegate:expenseDelgate?
    
    func getToday() -> String {
        // 오늘이 몇년 몇월인지 가져옴
        let today_ = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: today_)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        createDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 지출, 수입 입력 취소 버튼
    @IBAction func closePopup(_ sender: Any) {
        delegate?.reloadData()
        self.view.removeFromSuperview()
    }
    
    @IBOutlet weak var expenseDate: UITextField!
    @IBOutlet weak var expenseMoney: UITextField!
    @IBOutlet weak var expenseContent: UITextField!
    
    // 지출 입력 확인 버튼
    @IBAction func expenseSave(_ sender: Any) {
        // 지출 정보 미입력 시
        if (expenseDate.text?.isEmpty)! || expenseMoney.text == nil || (expenseContent.text?.isEmpty)! {
            print("textFields are empty!")
        }
        // 지출 정보 입력 시
        else {
            let dateSplit = expenseDate.text?.split(separator: "-")
            let calendar = Calendar(identifier: .gregorian)
            let date_: Date? = {
                let comps = DateComponents(calendar:calendar, year:Int(dateSplit![0]), month:Int(dateSplit![1]), day:Int(dateSplit![2]))
                return comps.date
            }()
            let input_money = Int(expenseMoney.text!)
            let input_content = expenseContent.text
            Database1.DolphinDatabase.addExpense(time_: date_!, money_: input_money!, content_: input_content!)
            
            if dateSplit![0] + dateSplit![1] == Database1.focus_year_month_expense {
                Database1.ExpenseList = Database1.DolphinDatabase.loadExpense(focus_year_month: Database1.focus_year_month_expense)
                // 날짜 순 sort
                Database1.ExpenseList = Database1.ExpenseList.sorted(by: { $0[0] < $1[0] })
            }
        }
        delegate?.reloadData()
        self.view.removeFromSuperview()
    }
    
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
        
        expenseDate.inputAccessoryView = toolbar
        
        // assigning date picker to text field
        expenseDate.inputView = datePicker
    }
    
    @objc func donePressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        expenseDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

