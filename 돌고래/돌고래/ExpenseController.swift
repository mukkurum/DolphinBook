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
    
    func reloadData() {
        self.expenseTableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(Database1.ExpenseList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")

        let row_ = Database1.ExpenseList[indexPath.row]
        cell.textLabel?.text = "\(row_[0]): \(row_[1])원, \(row_[2])"
        
        return(cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Database1.ExpenseList = loadExpenseTable()
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
        return Database1.DolphinDatabase.loadExpense()
    }
    @IBOutlet weak var expenseTableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        Database1.ExpenseList = loadExpenseTable()
        self.expenseTableview.reloadData()
    }

}

