//
//  ExpenseController.swift
//  돌고래
//
//  Created by Kim JungYeon on 2018. 5. 25..
//  Copyright © 2018년 김 정연. All rights reserved.
//

import UIKit
import SQLite

class ExpenseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var list: Array<Array<String>> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")

        let row_ = list[indexPath.row]
        cell.textLabel?.text = "time: \(row_[0]), money: \(row_[1])원, content: \(row_[2])"
        
        return(cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        list = loadExpenseTable()
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
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func loadExpenseTable() -> Array<Array<String>> {
        // 데이터베이스 가져오기
        let database = Database1(DBName: "db_dolphin1")
        return database.loadExpense()
    }
    @IBOutlet weak var expenseTableview: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        self.expenseTableview.reloadData()
    }
    
}

