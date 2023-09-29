import UIKit
import Foundation
import CoreMotion

class TwoVariableExperimentViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let motion = CMMotionManager()
    let altimeter = CMAltimeter()
    var press = 0.0
    var meas = [0,0]
    var exp: TwoVariableExperiment? = nil
    
    @IBOutlet weak var expNameLabel: UILabel!
    
    @IBOutlet weak var xMeasTypeLabel: UILabel!
    @IBOutlet weak var xMeasValLabel: UILabel!
    var xName = ""
    var xUnit = ""
    var zerox = 0.0
    
    @IBOutlet weak var yMeasTypeLabel: UILabel!
    @IBOutlet weak var yMeasValLabel: UILabel!
    var yName = ""
    var yUnit = ""
    var zeroy = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xName = exp?.xMeasName ?? "Default"
        yName = exp?.yMeasName ?? "Default"
        xUnit = exp?.xUnit ?? "Default"
        yUnit  = exp?.yUnit ?? "Default"
        meas[0] = Int(exp?.xMeas ?? 0)
        meas[1] = Int(exp?.yMeas ?? 0)
        expNameLabel.text = exp?.name ?? "Default"
        
        xMeasTypeLabel.text = xName
        xMeasValLabel.text = "--  " + xUnit
        yMeasTypeLabel.text = yName
        yMeasValLabel.text = "--  " + yUnit
        if (meas[0] == 1 || meas[0] == 2 || meas[0] == 3 || meas[0] == 4 || meas[1] == 1 || meas[1] == 2 || meas[1] == 3 || meas[1] == 4) && self.motion.isAccelerometerAvailable{
            self.motion.accelerometerUpdateInterval = 1.0 / 10.0
            self.motion.startAccelerometerUpdates()
        }
        if (meas[0] == 5 || meas[0] == 6 || meas[0] == 7 || meas[0] == 8 || meas[1] == 5 || meas[1] == 6 || meas[1] == 7 || meas[1] == 8) && self.motion.isMagnetometerAvailable{
            self.motion.magnetometerUpdateInterval = 1.0 / 10.0
            self.motion.startMagnetometerUpdates()
        }
        if (meas[0] == 9 || meas[1] == 9) && CMAltimeter.isRelativeAltitudeAvailable(){
            if CMAltimeter.isRelativeAltitudeAvailable() {
                   altimeter.startRelativeAltitudeUpdates(to: OperationQueue.current!, withHandler: { data, error in
                       self.press = Double(truncating: (data?.pressure)!)
                   })
               }
        }
    }
    
    @IBAction func measureTapped(_ sender: Any) {
        var valx: Double = 0.0
        var valy: Double = 0.0
        if meas[0] == 0 && meas[1] == 0{
            let alertx = UIAlertController(title: "Manual Entry Measurement: X", message: "Please type the X value that was measured.", preferredStyle: .alert)
            alertx.addTextField { (textField) in
                textField.placeholder = " X Measurement Value"
            }
            let theActionx = UIAlertAction(title: "Proceed", style: .default){(action) in
                valx = Double(alertx.textFields![0].text ?? "0.0")!
                self.xMeasValLabel.text = (alertx.textFields![0].text ?? "0.0") + "  " + self.xUnit
                let alerty = UIAlertController(title: "Manual Entry Measurement: Y", message: "Please type the Y value that was measured.", preferredStyle: .alert)
                alerty.addTextField { (textField) in
                    textField.placeholder = " Y Measurement Value"
                }
                let theActiony = UIAlertAction(title: "Proceed", style: .default){(action) in
                    valy = Double(alerty.textFields![0].text ?? "0.0")!
                    self.yMeasValLabel.text = (alerty.textFields![0].text ?? "0.0") + "  " + self.yUnit
                }
                alerty.addAction(theActiony)
                self.present(alerty, animated: true, completion: nil)
            }
            alertx.addAction(theActionx)
            present(alertx, animated: true, completion: nil)
        } else if meas[0] == 0 && meas[1] != 0 {
            valy = measure(measIndex: meas[1]) - zeroy
            yMeasValLabel.text = String(format: "%.2f", valy) + "  " + yUnit
            let alertx = UIAlertController(title: "Manual Entry Measurement: X", message: "Please type the X value that was measured.", preferredStyle: .alert)
            alertx.addTextField { (textField) in
                textField.placeholder = "X Measurement Value"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){(action) in
                valx = Double(alertx.textFields![0].text ?? "0.0")!
                self.xMeasValLabel.text = (alertx.textFields![0].text ?? "0.0") + "  " + self.xUnit
            }
            alertx.addAction(theAction)
            present(alertx, animated: true, completion: nil)
        } else if meas[0] != 0 && meas[1] == 0 {
            valx = measure(measIndex: meas[0]) - zerox
            xMeasValLabel.text = String(format: "%.2f", valx) + "  " + xUnit
            let alerty = UIAlertController(title: "Manual Entry Measurement: Y", message: "Please type the Y value that was measured.", preferredStyle: .alert)
            alerty.addTextField { (textField) in
                textField.placeholder = "Y Measurement Value"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){(action) in
                valy = Double(alerty.textFields![0].text ?? "0.0")!
                self.yMeasValLabel.text = (alerty.textFields![0].text ?? "0.0") + "  " + self.yUnit
            }
            alerty.addAction(theAction)
            present(alerty, animated: true, completion: nil)
        } else {
            valx = measure(measIndex: meas[0]) - zerox
            valy = measure(measIndex: meas[1]) - zeroy
            xMeasValLabel.text = String(format: "%.2f", valx - zerox) + "  " + xUnit
            yMeasValLabel.text = String(format: "%.2f", valy - zeroy) + "  " + yUnit
        }
        print(valx)
        print(valy)
        exp?.xData?.append(valx)
        exp?.yData?.append(valy)
        print(exp?.xData)
        print(exp?.yData)
        try! self.context.save()
    }
    
    @IBAction func tableTapped(_ sender: Any) {
        performSegue(withIdentifier: "toTableView", sender: exp)
    }
    
    @IBAction func graphTapped(_ sender: Any) {
        performSegue(withIdentifier: "toGraphView", sender: exp)
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func measure(measIndex: Int) -> Double {
        if (measIndex == 1 || measIndex == 2 || measIndex == 3 || measIndex == 4) {
            if let data = self.motion.accelerometerData {
                switch measIndex {
                case 1:
                     return 9.81*data.acceleration.x
                case 2:
                     return 9.81*data.acceleration.y
                case 3:
                     return 9.81*data.acceleration.z
                case 4:
                    let magnitude = 9.81*sqrt(pow(data.acceleration.x,2) + pow(data.acceleration.y,2) + pow(data.acceleration.z,2))
                    return magnitude
                default:
                    return 0.0
                }
            }
        }
        if (measIndex == 5 || measIndex == 6 || measIndex == 7 || measIndex == 8) {
            if let data = self.motion.magnetometerData {
                switch measIndex {
                case 5:
                    return data.magneticField.x
                case 6:
                    return data.magneticField.y
                case 7:
                    return data.magneticField.z
                case 8:
                    let magnitude = sqrt(pow(data.magneticField.x,2) + pow(data.magneticField.y,2) + pow(data.magneticField.z,2))
                    return magnitude
                default:
                    return 0.0
                }
            }
        } else if (measIndex == 9) {
            return press
        }
        return 0.0
    }
    
    
    @IBAction func zeroXTapped(_ sender: Any) {
        if meas[0] == 0 {
            let alert = UIAlertController(title: "Manual Entry Measurement", message: "Zeroing measurements not supported for manual measurements.", preferredStyle: .alert)
            let theAction = UIAlertAction(title: "Okay", style: .default){(action) in }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else {
            xMeasValLabel.text = "0.0" + "  " + xUnit
            zerox = measure(measIndex: meas[0])
        }
    }
        
    @IBAction func zeroYTapped(_ sender: Any) {
        if meas[1] == 0 {
            let alert = UIAlertController(title: "Manual Entry Measurement", message: "Zeroing measurements not supported for manual measurements.", preferredStyle: .alert)
            let theAction = UIAlertAction(title: "Okay", style: .default){(action) in }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else {
            yMeasValLabel.text = "0.0" + "  " + yUnit
            zeroy = measure(measIndex: meas[1])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TwoVariableTableViewController {
            if let exp = sender as? TwoVariableExperiment{
                dest.exp = exp
            }
        }
        if let dest = segue.destination as? TwoVariableGraphViewController{
            if let exp = sender as? TwoVariableExperiment{
                dest.exp = exp
            }
        }
    }


}
