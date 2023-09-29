import UIKit

class OneVariableTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exp: OneVariableExperiment? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exp?.data?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(format: "%.2f", exp?.data?[indexPath.row] ?? 0.0) + " " + (exp?.unit ?? "units")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Data Selected", message: "Please type the updated value for the data and hit submit, or hit delete to remove the data.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = String(format: "%.2f", self.exp?.data?[indexPath.row] ?? 0.0)
        }
        let updateIt = UIAlertAction(title: "Submit", style: .default){_ in
            self.exp?.data?[indexPath.row] = Double(alert.textFields?[0].text ?? "0.0") ?? 0.0
            try! self.context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let deleteIt = UIAlertAction(title: "Delete", style: .default){_ in
            self.exp?.data?.remove(at: indexPath.row)
            try! self.context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alert.addAction(updateIt)
        alert.addAction(deleteIt)
        present(alert, animated: true, completion: nil)
    }
    
    


    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}