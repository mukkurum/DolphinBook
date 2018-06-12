//
//  DolphinController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 6. 11..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit

class DolphinController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 데이터 베이스 생성
        let database = Database1(DBName: "db_test1")
        
        
        //@@@@@@@@@@ 지출 입력 시작 @@@@@@@@@@
        let calendar = Calendar(identifier: .gregorian)
        let date_: Date? = {
            let comps = DateComponents(calendar:calendar, year:2018, month:6, day:1)
            return comps.date
        }()
        
        database.addExpense(time_: date_!, money_: 10000, content_: "구공탄")
        //@@@@@@@@@@ 지출 입력 끝 @@@@@@@@@@
        
        //@@@@@@@@@@ 지출 출력 시작 @@@@@@@@@@
        database.loadExpense()
        //@@@@@@@@@@ 지출 출력 끝 @@@@@@@@@@
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
