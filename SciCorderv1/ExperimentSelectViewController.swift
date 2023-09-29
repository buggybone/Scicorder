import UIKit

class ExperimentSelectViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var oneVarExperiments: [OneVariableExperiment] = []
    var twoVarExperiments: [TwoVariableExperiment] = []
    var deleteMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchExperiments()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return oneVarExperiments.count
        } else {
            return twoVarExperiments.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "One Variable Experiments";}
        else {return "Two Variable Experiments";}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(indexPath.section == 0){
            cell.textLabel?.text = oneVarExperiments[indexPath.row].name
        } else {
            cell.textLabel?.text = twoVarExperiments[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !deleteMode {
            if indexPath.section == 0 {
                performSegue(withIdentifier: "toOneVariableExperimentView", sender: oneVarExperiments[indexPath.row])
            } else {
                performSegue(withIdentifier: "toTwoVariableExperimentView", sender: twoVarExperiments[indexPath.row])
            }
        } else {
            if indexPath.section == 0 {
                let selection = oneVarExperiments[indexPath.row]
                let alert = UIAlertController(title: "Warning: Delete Experiment", message: "Are you sure you want to delete experiment " + selection.name! + "? This action cannot be undone.", preferredStyle: .alert)
                let theAction = UIAlertAction(title: "Delete", style: .default){_ in
                    self.context.delete(selection)
                    try! self.context.save()
                    self.fetchExperiments()
                 }
                 alert.addAction(theAction)
                 present(alert, animated: true, completion: nil)
            } else {
                let selection = twoVarExperiments[indexPath.row]
                let alert = UIAlertController(title: "Warning: Delete Experiment", message: "Are you sure you want to delete experiment " + selection.name! + "? This action cannot be undone.", preferredStyle: .alert)
                let theAction = UIAlertAction(title: "Delete", style: .default){_ in
                    self.context.delete(selection)
                    try! self.context.save()
                    self.fetchExperiments()
                 }
                 alert.addAction(theAction)
                 present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fetchExperiments() -> Void {
        self.oneVarExperiments = try! context.fetch(OneVariableExperiment.fetchRequest())
        
        self.twoVarExperiments = try! context.fetch(TwoVariableExperiment.fetchRequest())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let oneVarView = segue.destination as? OneVariableExperimentViewController {
            if let exp = sender as? OneVariableExperiment {
                oneVarView.exp = exp
            }
        }
        if let twoVarView = segue.destination as? TwoVariableExperimentViewController {
            if let exp = sender as? TwoVariableExperiment {
                twoVarView.exp = exp
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */

}
