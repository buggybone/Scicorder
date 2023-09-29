import UIKit

class TwoVariableSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var expNameLabel: UILabel!
    
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
        let theRows = [picker.selectedRow(inComponent: 0), picker.selectedRow(inComponent: 1)]
        
        if theRows[0] == 0 && theRows[1] == 0 {
            let alert = UIAlertController(title: "Manual Entry Selected for both X and Y", message: "Please type the name and unit of measurement for both of the manual measurements you will perform.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "X Measurement Name"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "X Measurement Units"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Y Measurement Name"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Y Measurement Units"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
                let newExperiment = TwoVariableExperiment(context: self.context)
                newExperiment.name = self.expName
                newExperiment.xMeas = Int64(0)
                newExperiment.yMeas = Int64(0)
                newExperiment.xUnit = alert.textFields![1].text
                newExperiment.yUnit = alert.textFields![3].text
                newExperiment.xMeasName = alert.textFields![0].text
                newExperiment.yMeasName = alert.textFields![2].text
                newExperiment.xData = []
                newExperiment.yData = []
                try! self.context.save()
                
                self.performSegue(withIdentifier: "toTwoVariableExperimentView", sender: newExperiment)
            }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else if theRows[0] == 0 {
            let alert = UIAlertController(title: "Manual Entry Selected for X", message: "Please type the name and unit of measurement for the manual X measurement you will perform.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "X Measurement Name"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "X Measurement Units"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
                let newExperiment = TwoVariableExperiment(context: self.context)
                newExperiment.name = self.expName
                newExperiment.xMeas = Int64(0)
                newExperiment.yMeas = Int64(theRows[1])
                newExperiment.xUnit = alert.textFields![1].text
                newExperiment.yUnit = K.measurementUnits[theRows[1]]
                newExperiment.xMeasName = alert.textFields![0].text
                newExperiment.yMeasName = K.measurementTypes[theRows[1]]
                newExperiment.xData = []
                newExperiment.yData = []
                try! self.context.save()
                
                self.performSegue(withIdentifier: "toTwoVariableExperimentView", sender: newExperiment)
            }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else if theRows[1] == 0 {
            let alert = UIAlertController(title: "Manual Entry Selected for Y", message: "Please type the name and unit of measurement for the manual Y measurement you will perform.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Y Measurement Name"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Y Measurement Units"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){_ in
                let newExperiment = TwoVariableExperiment(context: self.context)
                newExperiment.name = self.expName
                newExperiment.xMeas = Int64(theRows[0])
                newExperiment.yMeas = Int64(0)
                newExperiment.xUnit = K.measurementUnits[theRows[0]]
                newExperiment.yUnit = alert.textFields![1].text
                newExperiment.xMeasName = K.measurementTypes[theRows[0]]
                newExperiment.yMeasName = alert.textFields![0].text
                newExperiment.xData = []
                newExperiment.yData = []
                try! self.context.save()
                
                self.performSegue(withIdentifier: "toTwoVariableExperimentView", sender: newExperiment)
            }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else {
            let newExperiment = TwoVariableExperiment(context: self.context)
            newExperiment.name = self.expName
            newExperiment.xMeas = Int64(theRows[0])
            newExperiment.yMeas = Int64(theRows[1])
            newExperiment.xUnit = K.measurementUnits[theRows[0]]
            newExperiment.yUnit = K.measurementUnits[theRows[1]]
            newExperiment.xMeasName = K.measurementTypes[theRows[0]]
            newExperiment.yMeasName = K.measurementTypes[theRows[1]]
            newExperiment.xData = []
            newExperiment.yData = []
            try! self.context.save()
            
            self.performSegue(withIdentifier: "toTwoVariableExperimentView", sender: newExperiment)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let twoVarExpView = segue.destination as? TwoVariableExperimentViewController {
            if let exp = sender as? TwoVariableExperiment {
                twoVarExpView.exp = exp
            }
        }
    }


}
