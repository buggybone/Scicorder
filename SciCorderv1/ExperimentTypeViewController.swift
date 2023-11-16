

import UIKit
import CoreData

class ExperimentTypeViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var experimentNames: [String] = []
    
    @IBOutlet weak var createOneButton: UIButton!
    @IBOutlet weak var createTwoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createOneButton.titleLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)
        createTwoButton.titleLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func singleTapped(_ sender: Any) {
        collectExpName(type: 1)
        /*let alert = UIAlertController(title: "Single Variable Experiment Selected", message: "Please make a name of your experiment.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Experiment Name"
        }
        let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
            let name = alert.textFields![0].text
            self.performSegue(withIdentifier: "toOneVariableSelectView", sender: name)
        }
        alert.addAction(theAction)
        present(alert, animated: true, completion: nil)*/
    }
    
    @IBAction func doubleTapped(_ sender: Any) {
        collectExpName(type: 2)
       /*let alert = UIAlertController(title: "Two Variable Experiment Selected", message: "Please make a name of your experiment.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Experiment Name"
        }
        let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
            let name = alert.textFields![0].text
            if(!self.nameAlreadyThere(name: name ?? "")){
                self.performSegue(withIdentifier: "toTwoVariableSelectView", sender: name)
            }else{
                let alert2 = UIAlertController(title: "Name Conflict", message: "Name matches a previously created experiment. Either delete that experiment or use a different name.", preferredStyle: .alert)
                let action2 = UIAlertAction(title: "Okay", style: .default){_ in }
                alert2.addAction(action2)
                self.present(alert2, animated: true, completion: nil)
            }
        }
        alert.addAction(theAction)
        present(alert, animated: true, completion: nil)
        performSegue(withIdentifier: "toTwoVariableSelectView", sender: nil)*/
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
    
    func nameAlreadyThere(name : String) -> Bool {
        let req1 = OneVariableExperiment.fetchRequest() as NSFetchRequest<OneVariableExperiment>
        let pred1 = NSPredicate(format: "name == %@", name)
        req1.predicate = pred1
        let oneVarExperiments = try! context.fetch(req1)
        //print("Checking one var results...")
        //print(oneVarExperiments[0].name ?? "no return")
        
        let req2 = TwoVariableExperiment.fetchRequest() as NSFetchRequest<TwoVariableExperiment>
        let pred2 = NSPredicate(format: "name == %@", name)
        req2.predicate = pred2
        let twoVarExperiments = try! context.fetch(req2)
        //print("Checking two var results...")
        //print(twoVarExperiments[0].name ?? "no return")
        
        let result = (oneVarExperiments.count != 0) || (twoVarExperiments.count != 0)
        //print(result)
        return result
    }
    
    func collectExpName(type: Int){
        let alert: UIAlertController
        if(type == 1){
            alert = UIAlertController(title: "One Variable Experiment Selected", message: "Please make a name of your experiment.", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Two Variable Experiment Selected", message: "Please make a name of your experiment.", preferredStyle: .alert)
        }
        
        alert.addTextField { (textField) in
             textField.placeholder = "Experiment Name"
        }
        let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
            let name = alert.textFields![0].text
            if(!self.nameAlreadyThere(name: name ?? "")){
                if(type == 1){
                    self.performSegue(withIdentifier: "toOneVariableSelectView", sender: name)
                } else {
                    self.performSegue(withIdentifier: "toTwoVariableSelectView", sender: name)
                }
             }else{
                 let alert2 = UIAlertController(title: "Name Conflict", message: "Name matches a previously created experiment. Either delete that experiment or use a different name.", preferredStyle: .alert)
                 let action2 = UIAlertAction(title: "Okay", style: .default){_ in }
                 alert2.addAction(action2)
                 self.present(alert2, animated: true, completion: nil)
             }
         }
         alert.addAction(theAction)
         present(alert, animated: true, completion: nil)
         //performSegue(withIdentifier: "toTwoVariableSelectView", sender: nil)
    }
    
}
