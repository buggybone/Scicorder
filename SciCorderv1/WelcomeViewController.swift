import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    @IBAction func newExperimentTapped(_ sender: Any) {
        performSegue(withIdentifier: "toExperimentTypeView", sender: nil)
    }
    
    @IBAction func continueExperimentTapped(_ sender: Any) {
        performSegue(withIdentifier: "toExperimentSelectView", sender: false)
    }
    
    @IBAction func deleteExperimentTapped(_ sender: Any) {
        performSegue(withIdentifier: "toExperimentSelectView", sender: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ExperimentSelectViewController {
            if let delete = sender as? Bool {
                dest.deleteMode = delete
            }
        }
    }
}
