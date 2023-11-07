
import UIKit
import SwiftUI

class TwoVariableTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exp: TwoVariableExperiment? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        self.tableView.backgroundColor = UIColor(Color("Blackish"))
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exp?.xData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let offset = exp?.xMeas == 10 ? (exp?.xData?[0] ?? 0.0) : 0.0
        let cell = UITableViewCell()
        cell.textLabel?.textColor = UIColor(Color("Gray"))
        cell.backgroundColor = UIColor(Color("Blackish"))
        cell.textLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)
        cell.textLabel?.text = "(" + String(format: "%.2f", (exp?.xData?[indexPath.row] ?? 0.0) - offset) +  " " + (exp?.xUnit ?? "units") + ", " +  String(format: "%.2f", exp?.yData?[indexPath.row] ?? 0.0) + " " + (exp?.yUnit ?? "units") + ")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Data Selected", message: "Please type the updated value for the data and hit submit, or hit delete to remove the data.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = String(format: "%.2f", self.exp?.xData?[indexPath.row] ?? 0.0)
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = String(format: "%.2f", self.exp?.yData?[indexPath.row] ?? 0.0)
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        let updateIt = UIAlertAction(title: "Submit", style: .default){_ in
            self.exp?.xData?[indexPath.row] = Double(alert.textFields?[0].text ?? "0.0") ?? 0.0
            self.exp?.yData?[indexPath.row] = Double(alert.textFields?[1].text ?? "0.0") ?? 0.0
            try! self.context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let deleteIt = UIAlertAction(title: "Delete", style: .default){_ in
            self.exp?.xData?.remove(at: indexPath.row)
            self.exp?.yData?.remove(at: indexPath.row)
            try! self.context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alert.addAction(updateIt)
        alert.addAction(deleteIt)
        present(alert, animated: true, completion: nil)
    }

    func xOffsetTapped(os: Double){
        for i in 0...(exp!.xData!.count - 1){
            exp!.xData![i] += os
        }
        try! self.context.save()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func yOffsetTapped(os: Double){
        for i in 0...(exp!.yData!.count - 1){
            exp!.yData![i] += os
        }
        try! self.context.save()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
