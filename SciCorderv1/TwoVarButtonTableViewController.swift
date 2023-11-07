import UIKit
import SwiftUI

class TwoVarButtonTableViewController: UIViewController {

    var exp: TwoVariableExperiment? = nil
    let tv = TwoVariableTableViewController()
    
    @IBOutlet weak var yOffsetButton: UIButton!
    @IBOutlet weak var xOffsetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(Color("Blackish"))
        xOffsetButton.titleLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)
        yOffsetButton.titleLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)
        guard let table = tv.view else{
            return
        }
        tv.exp = exp
        //table.backgroundColor = UIColor(Color("Blackish"))
        view.addSubview(table)
        table.snp.makeConstraints{
            make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(500)
        }
    }
    
    @IBAction func xOffsetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Horizontal Offset Selected", message: "Please type an horizontal offset to add to all data points.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = String(format: "%.2f", 0.0)
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        let offsetIt = UIAlertAction(title: "Add Offset", style: .default){_ in
            let os = Double(alert.textFields?[0].text ?? "0.0")
            self.tv.xOffsetTapped(os: os!)
        }
        alert.addAction(offsetIt)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func yOffsetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Vertical Offset Selected", message: "Please type a vertical offset to add to all data points.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = String(format: "%.2f", 0.0)
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        let offsetIt = UIAlertAction(title: "Add Offset", style: .default){_ in
            let os = Double(alert.textFields?[0].text ?? "0.0")
            self.tv.yOffsetTapped(os: os!)
        }
        alert.addAction(offsetIt)
        present(alert, animated: true, completion: nil)
    }


}
