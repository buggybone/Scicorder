import UIKit

class OneVariableSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var expNameLabel: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var types: [String] = []
    var expName: String = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        types = K.measurementTypes
        expNameLabel.text = expName
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        let theRow = picker.selectedRow(inComponent: 0)
        
        if theRow == 0 {
            let alert = UIAlertController(title: "Manual Entry Selected", message: "Please type the name and unit of measurement of the manual measurement you will perform.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Measurement Name"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Measurement Units"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
                let newExperiment = OneVariableExperiment(context: self.context)
                newExperiment.name = self.expName
                newExperiment.data = []
                newExperiment.meas = Int64(0)
                newExperiment.measName = alert.textFields![0].text
                newExperiment.unit = alert.textFields![1].text
                try! self.context.save()
                self.performSegue(withIdentifier: "toOneVariableExperimentView", sender: newExperiment)
            }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else {
            let newExperiment = OneVariableExperiment(context: self.context)
            newExperiment.name = self.expName
            newExperiment.data = []
            newExperiment.measName = K.measurementTypes[theRow]
            newExperiment.meas = Int64(theRow)
            newExperiment.unit = K.measurementUnits[theRow]
            try! self.context.save()
            performSegue(withIdentifier: "toOneVariableExperimentView", sender: newExperiment)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let oneVarExpView = segue.destination as? OneVariableExperimentViewController{
            if let exp = sender as?  OneVariableExperiment{
                oneVarExpView.exp = exp
            }
        }
    }

}
