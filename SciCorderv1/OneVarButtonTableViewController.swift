import UIKit
import SwiftUI

class OneVarButtonTableViewController: UIViewController {

    var exp: OneVariableExperiment? = nil
    let tv = OneVariableTableViewController()
    @IBOutlet weak var offsetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offsetButton.titleLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)
        guard let table = tv.view else{
            return
        }
        tv.exp = exp
        table.backgroundColor = UIColor(Color("Blackish"))
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
    @IBAction func offsetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Offset Selected", message: "Please type an offset to add to all data points.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = String(format: "%.2f", 0.0)
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        let offsetIt = UIAlertAction(title: "Add Offset", style: .default){_ in
            let os = Double(alert.textFields?[0].text ?? "0.0")
            self.tv.offsetTapped(os: os!)
        }
        alert.addAction(offsetIt)
        present(alert, animated: true, completion: nil)
    }
    



}
