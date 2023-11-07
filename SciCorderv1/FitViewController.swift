

import UIKit
import Foundation

class FitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var exp: TwoVariableExperiment? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var fitLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var fitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        fitButton.titleLabel?.font = UIFont.init(name: "BauhausStd-Medium", size: 18)
        
        let ft = exp?.fitType ?? "--"
        var a = "--"
        var b = "--"
        if(ft != "--"){
            a = String(format: "%.3f", exp!.a)
            b = String(format: "%.3f", exp!.b)
        }
        
        fitLabel.text = "Fit Type: " + ft + "\n" + "a = " + a + "\n" + "b = " + b
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Linear: y = a + b x"
        } else if row == 1 {
            return "Power Law: y = a x^b"
        } else {
            return "Exponential: y = a exp(bx)"
        }
    }
    
    @IBAction func fitTapped(_ sender: Any) {
        let selected = picker.selectedRow(inComponent: 0)
        var x: [Double] = []
        if(exp!.xMeas != 10){
            x = exp!.xData!
        }else{
            for xval in exp!.xData!{
                x.append(xval - exp!.xData![0])
            }
        }
        let y = exp!.yData
        var fitResult: [Double] = [0,0]
        var fitType = ""
        if selected == 0 {
            fitResult = linearFit(x: x , y: y ?? [0])
            fitType = "Linear"
        } else if selected == 1 {
            fitResult = powerFit(x: x , y: y ?? [0])
            fitType = "Power Law"
        } else if selected == 2 {
            fitResult = exponentialFit(x: x , y: y ?? [0])
            fitType = "Exponential"
        }
        
        fitLabel.text = "Fit Type: " + fitType + "\na = " + String(format: "%.2f", fitResult[0]) + "\nb = " + String(format: "%.2f", fitResult[1])
        
        exp!.fitType = fitType
        exp!.a = fitResult[0]
        exp!.b = fitResult[1]
        try! self.context.save()
    }
    
    func powerFit(x: [Double], y: [Double]) -> [Double] {
        let n = x.count
        let nd = Double(n)
        var s1 = 0.0
        var s2 = 0.0
        var s3 = 0.0
        var s4 = 0.0
        
        for i in 0...(n-1){
            s1 += log(x[i])*log(y[i])
            s2 += log(x[i])
            s3 += log(y[i])
            s4 += pow(log(x[i]),2)
        }
        
        let b = (nd*s1 - s2*s3)/(nd*s4 - pow(s2,2))
        let a = (s3 - b*s2)/nd
        return [Darwin.exp(a),b]
    }
    
    func exponentialFit(x: [Double], y: [Double]) -> [Double] {
        let n = x.count
        var s1 = 0.0
        var s2 = 0.0
        var s3 = 0.0
        var s4 = 0.0
        var s5 = 0.0
        
        for i in 0...(n-1){
            s1 += x[i]*x[i]*y[i]
            s2 += y[i]*log(y[i])
            s3 += x[i]*y[i]
            s4 += x[i]*y[i]*log(y[i])
            s5 += y[i]
        }
        
        let a = (s1*s2 - s3*s4)/(s5*s1 - pow(s3,2))
        let b = (s5*s4 - s3*s2)/(s5*s1 - pow(s3,2))
        return [a, b]
    }
    
    func linearFit(x: [Double], y: [Double]) -> [Double] {
        let n = x.count
        let nd = Double(n)
        var s1 = 0.0
        var s2 = 0.0
        var s3 = 0.0
        var s4 = 0.0
        
        for i in 0...(n-1){
            s1 += y[i]
            s2 += x[i]*x[i]
            s3 += x[i]*y[i]
            s4 += x[i]
        }
        
        let a = (s1*s2-s4*s3)/(nd*s2 - s4*s4)
        let b = (nd*s3-s4*s1)/(nd*s2 - s4*s4)
        return [a,b]
    }

}
