//
//  DolphinController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 6. 11..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit

class DolphinController: UIViewController {
    
    func getToday() -> String {
        // 오늘이 몇년 몇월인지 가져옴
        let today_ = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: today_)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        changeDolphinImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var dolphinImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    
    func loadExpenseTable() -> Array<Array<String>> {
        return Database1.DolphinDatabase.loadExpense(focus_year_month: getToday())
    }
    func loadIncomeTable() -> Array<Array<String>> {
        return Database1.DolphinDatabase.loadIncome()
    }
    
    
    // 돌고래 사진 바꿔주는 함수
    func changeDolphinImage() {
        // 지출, 수입 data 전역변수 로드
        Database1.ExpenseList = loadExpenseTable()
        Database1.IncomeList = loadIncomeTable()
        
        // 기본 돌고래 이미지
        dolphinImageView.image = UIImage(named: "dolphin_pre")
        
        // 오늘이 몇년 몇월인지 가져옴
        let today_ = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        let today_year_month = dateFormatter.string(from: today_)
        
        // 이번달 총 수입 계산
        var month_income_sum = 0
        for income in Database1.IncomeList {
            let income_year_month = income[0].split(separator: "-")[0] + income[0].split(separator: "-")[1]
            if income_year_month == today_year_month { // 같은 연, 월 확인
                month_income_sum += Int(income[1])!
            }
        }
        // 이번달 수입이 없을 경우
        if month_income_sum == 0 {
            messageImageView.image = UIImage(named: "message_pre")
        }
        // 이번달 수입이 있을 경우
        else {
            // 이번달 총 지출 계산
            var month_expense_sum = 0 // 이번달 총 수입
            for expense in Database1.ExpenseList {
                month_expense_sum += Int(expense[1])!
            }
            let left_money = month_income_sum - month_expense_sum // 남은 돈
            let left_money_per = (left_money*100 / month_income_sum) // 남은 돈 %로 표현
            
            print("\(left_money)원")
            print("\(left_money_per)%")
            
            // 남은 돈을 다 쓰거나 마이너스 일 때
            if left_money <= 0 {
                messageImageView.image = UIImage(named: "message_06")
                dolphinImageView.image = UIImage(named: "dolphin_05")
            }
            // 돈이 90% 이상 남은경우
            else if left_money_per >= 90 {
                messageImageView.image = UIImage(named: "message_01")
                dolphinImageView.image = UIImage(named: "dolphin_01")
            }
            else {
                // 오늘이 몇일인지 가져옴
                dateFormatter.dateFormat = "dd"
                let today_day = Int(dateFormatter.string(from: today_))!
                
                let avg_left_money = month_income_sum - (month_income_sum * today_day)/30 // 권장 남은 돈
                let avg_left_money_per = (avg_left_money*100 / month_income_sum)  // 권장 남은 돈 %로 표시
                let dif_left_money_per = left_money_per - avg_left_money_per // (남은 돈 %) - (권장 남은돈 %)
                
                if today_day <= 10 { // 월초 (1~10)
                    if dif_left_money_per >= 15 {
                        messageImageView.image = UIImage(named: "message_01")
                        dolphinImageView.image = UIImage(named: "dolphin_01")
                    }
                    else if dif_left_money_per >= 5 {
                        messageImageView.image = UIImage(named: "message_02")
                        dolphinImageView.image = UIImage(named: "dolphin_02")
                    }
                    else if dif_left_money_per >= -5 {
                        messageImageView.image = UIImage(named: "message_03")
                        dolphinImageView.image = UIImage(named: "dolphin_03")
                    }
                    else {
                        messageImageView.image = UIImage(named: "message_04")
                        dolphinImageView.image = UIImage(named: "dolphin_04")
                    }
                }
                else if today_day <= 20 { // 월중 (11~20)
                    if dif_left_money_per >= 15 {
                        messageImageView.image = UIImage(named: "message_01")
                        dolphinImageView.image = UIImage(named: "dolphin_01")
                    }
                    else if dif_left_money_per >= 5 {
                        messageImageView.image = UIImage(named: "message_02")
                        dolphinImageView.image = UIImage(named: "dolphin_02")
                    }
                    else if dif_left_money_per >= -5 {
                        messageImageView.image = UIImage(named: "message_03")
                        dolphinImageView.image = UIImage(named: "dolphin_03")
                    }
                    else if dif_left_money_per >= -15 {
                        messageImageView.image = UIImage(named: "message_04")
                        dolphinImageView.image = UIImage(named: "dolphin_04")
                    }
                    else {
                        messageImageView.image = UIImage(named: "message_05")
                        dolphinImageView.image = UIImage(named: "dolphin_05")
                    }
                } else { // 월말 (21~31)
                    if dif_left_money_per >= 15 {
                        messageImageView.image = UIImage(named: "message_01")
                        dolphinImageView.image = UIImage(named: "dolphin_01")
                    }
                    else if dif_left_money_per >= 5 {
                        messageImageView.image = UIImage(named: "message_02")
                        dolphinImageView.image = UIImage(named: "dolphin_02")
                    }
                    else if dif_left_money_per >= -5 {
                        messageImageView.image = UIImage(named: "message_04")
                        dolphinImageView.image = UIImage(named: "dolphin_04")
                    }
                    else {
                        messageImageView.image = UIImage(named: "message_05")
                        dolphinImageView.image = UIImage(named: "dolphin_05")
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        changeDolphinImage()
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
