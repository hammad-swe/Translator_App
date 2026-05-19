//
//  HistoryViewController.swift
//  Translator_App
//
//  Created by Hammad Ali on 19/05/2026.
//

import UIKit

class HistoryViewController: UIViewController {
    
    
    
    @IBOutlet weak var searchFireld: UITextField!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier:HistoryTableViewCell.identifier)
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }


    

}

extension HistoryViewController:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        return cell
    }
    
}
