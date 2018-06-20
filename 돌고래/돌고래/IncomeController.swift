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

    func reloadData() {
        self.incomeTableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(Database1.IncomeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        
        let row_ = Database1.IncomeList[indexPath.row]

        let money_int = Int(row_[1])!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let money_ = numberFormatter.string(from: NSNumber(value: money_int))!
        
        cell.textLabel?.text = "\(row_[0]):     \(row_[2])"
        cell.detailTextLabel?.text = "\(money_) 원"
        return(cell)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         Database1.IncomeList = loadIncomeTable()
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
        return Database1.DolphinDatabase.loadIncome()
    }
    @IBOutlet weak var incomeTableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        Database1.IncomeList = loadIncomeTable()
        self.incomeTableview.reloadData()
    }
    
}

