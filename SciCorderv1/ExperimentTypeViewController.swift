

import UIKit

class ExperimentTypeViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func singleTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Single Variable Experiment Selected", message: "Please make a name of your experiment.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Experiment Name"
        }
        let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
            let name = alert.textFields![0].text
            self.performSegue(withIdentifier: "toOneVariableSelectView", sender: name)
        }
        alert.addAction(theAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doubleTapped(_ sender: Any) {
       let alert = UIAlertController(title: "Two Variable Experiment Selected", message: "Please make a name of your experiment.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Experiment Name"
        }
        let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
            let name = alert.textFields![0].text
            self.performSegue(withIdentifier: "toTwoVariableSelectView", sender: name)
        }
        alert.addAction(theAction)
        present(alert, animated: true, completion: nil)
        performSegue(withIdentifier: "toTwoVariableSelectView", sender: nil)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let oneVarSelectVC = segue.destination as? OneVariableSelectViewController {
            if let name = sender as? String{
                print(name)
                oneVarSelectVC.expName = name
            }
        }
        if let twoVarSelectVC = segue.destination as? TwoVariableSelectViewController {
            if let name = sender as? String{
                twoVarSelectVC.expName = name
            }
        }
    }
    

}
