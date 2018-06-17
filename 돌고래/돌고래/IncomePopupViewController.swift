//
//  IncomePopupViewController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 6. 14..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit

class IncomePopupViewController: UIViewController {

    var delegate:incomeDelgate?
    
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
    
    
    @IBOutlet weak var incomeDate: UITextField!
    @IBOutlet weak var incomeMoney: UITextField!
    @IBOutlet weak var incomeContent: UITextField!
    
    @IBAction func inomeSave(_ sender: Any) {
        // 수입 정보 미입력 시
        if (incomeDate.text?.isEmpty)! || incomeMoney.text == nil || (incomeContent.text?.isEmpty)! {
            print("textFields are empty!")
        }
            // 수입 정보 입력 시
        else {
            let dateSplit = incomeDate.text?.split(separator: "-")
            let calendar = Calendar(identifier: .gregorian)
            let date_: Date? = {
                let comps = DateComponents(calendar:calendar, year:Int(dateSplit![0]), month:Int(dateSplit![1]), day:Int(dateSplit![2]))
                return comps.date
            }()
            let input_money = Int(incomeMoney.text!)
            let input_content = incomeContent.text
            Database1.DolphinDatabase.addIncome(time_: date_!, money_: input_money!, content_: input_content!)
            
            var temp_list: Array<String> = []
            temp_list.append(incomeDate.text!)
            temp_list.append(incomeMoney.text!)
            temp_list.append(incomeContent.text!)
            Database1.IncomeList.append(temp_list)
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
        
        incomeDate.inputAccessoryView = toolbar
        
        // assigning date picker to text field
        incomeDate.inputView = datePicker
    }
    
    @objc func donePressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        incomeDate.text = dateFormatter.string(from: datePicker.date)
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
