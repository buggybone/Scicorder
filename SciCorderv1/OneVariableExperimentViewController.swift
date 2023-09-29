//
//  OneVariableExperimentViewController.swift
//  SciCorderv1
//
//  Created by Isabelle Winnick on 8/15/23.
//

import UIKit
import CoreMotion
import Foundation

class OneVariableExperimentViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let motion = CMMotionManager()
    let altimeter = CMAltimeter()
    var press = 0.0
    var meas = 0
    var unit = ""
    var zero = 0.0
    var exp: OneVariableExperiment? = nil

    
    @IBOutlet weak var expNameLabel: UILabel!
    @IBOutlet weak var measTypeLabel: UILabel!
    @IBOutlet weak var measValLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expNameLabel.text = exp!.name ?? "Default"
        unit = exp!.unit ?? "Default"
        meas = Int(exp!.meas)
        measValLabel.text = "--  " + unit
        measTypeLabel.text = exp!.measName ?? "Default"
        
        
        if (meas == 1 || meas == 2 || meas == 3 || meas == 4) && self.motion.isAccelerometerAvailable{
            self.motion.accelerometerUpdateInterval = 1.0 / 10.0
            self.motion.startAccelerometerUpdates()
        }
        if (meas == 5 || meas == 6 || meas == 7 || meas == 8) && self.motion.isMagnetometerAvailable{
            self.motion.magnetometerUpdateInterval = 1.0 / 10.0
            self.motion.startMagnetometerUpdates()
        }
        if (meas == 9) && CMAltimeter.isRelativeAltitudeAvailable(){
            if CMAltimeter.isRelativeAltitudeAvailable() {
                   altimeter.startRelativeAltitudeUpdates(to: OperationQueue.current!, withHandler: { data, error in
                       self.press = Double(truncating: (data?.pressure)!)
                   })
            }
        }
    }
    


    @IBAction func measureTapped(_ sender: Any) {
        if meas == 0 {
            let alert = UIAlertController(title: "Manual Entry Measurement", message: "Please type the value that was measured.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Measurement Value"
            }
            let theAction = UIAlertAction(title: "Proceed", style: .default){(action) in
                let value = Double(alert.textFields![0].text ?? "0.0")
                self.measValLabel.text = (alert.textFields![0].text ?? "0.0") + "  " + self.unit
                self.exp!.data?.append(value ?? 0.0)
                try! self.context.save()
            }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else {
            let value = measure(measIndex: meas) - zero
            measValLabel.text = String(format: "%.2f", value) + "  " + unit
            exp?.data?.append(value)
            try! self.context.save()
        }
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
    
    @IBAction func zeroTapped(_ sender: Any) {
        if meas == 0 {
            let alert = UIAlertController(title: "Manual Entry Measurement", message: "Zeroing measurements not supported for manual measurements.", preferredStyle: .alert)
            let theAction = UIAlertAction(title: "Okay", style: .default){(action) in }
            alert.addAction(theAction)
            present(alert, animated: true, completion: nil)
        } else {
            measValLabel.text = "0.0" + "  " + unit
            zero = measure(measIndex: meas)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? OneVariableTableViewController{
            if let exp = sender as? OneVariableExperiment{
                dest.exp = exp
            }
        }
    }
    
}
