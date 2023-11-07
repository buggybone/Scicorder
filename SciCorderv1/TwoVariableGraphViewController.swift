import UIKit
import SwiftUI
import Charts
import SnapKit

class TwoVariableGraphViewController: UIViewController {
    
    var exp: TwoVariableExperiment? = nil
    
    @IBOutlet weak var fitInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data: [DataPoint] = []
        let ft = (exp?.fitType ?? "")
        let fitted = ft != ""
        var fitData: [DataPoint] = []
        
        for (i, _) in exp!.xData!.enumerated(){
            if(exp!.xMeas != 10){
                data.append(DataPoint(x: exp!.xData![i], y: exp!.yData![i]))
            }else{
                data.append(DataPoint(x: exp!.xData![i]-exp!.xData![0], y: exp!.yData![i]))
            }
            
        }
        
        if(!fitted){
            fitInfo.isHidden = true
        }
        
        if(fitted){
            let a = exp!.a
            let b = exp!.b
            
            var fitStr = "Fit Type "
            if(ft == "Linear"){
                fitStr += "Linear: y = a + b x\n"
            }
            else if(ft == "Power Law"){
                fitStr += "Power Law: y = a x^b\n"
            }
            else if(ft == "Exponential"){
                fitStr += "Exponential: y = a exp(bx)\n"
            }
            fitStr += "a = " + String(format: "%.2f", a) + ", b = " + String(format: "%.2f", b) + "\n"
            
            var RMSE = 0.0
            for (i, _) in exp!.xData!.enumerated(){
                var x = 0.0
                if(exp!.xMeas != 10){
                    x = exp!.xData![i]
                }else{
                    x = exp!.xData![i]-exp!.xData![0]
                }
                let y = getPrediction(ft: ft, x: x, a: a, b: b)
                fitData.append(DataPoint(x: x, y: y))
                RMSE += pow(y - exp!.yData![i],2)
            }
            RMSE /= Double(exp!.xData!.count)
            RMSE = pow(RMSE,0.5)
            fitStr += "RMSE = " + String(format: "%.2f", RMSE)
            fitInfo.text = fitStr
        }
        
        
        
        let theChart = PointChart(data: data, fitData: fitData, xLabel: (exp?.xMeasName ?? "") + " (" + (exp?.xUnit ?? "") + ")", yLabel: (exp?.yMeasName ?? "") + " (" + (exp?.yUnit ?? "") + ")" )
        let chartController = UIHostingController(rootView: theChart)
        guard let graph = chartController.view else{
            return
        }
        graph.backgroundColor = UIColor(Color("Blackish"))
        view.addSubview(graph)
        graph.snp.makeConstraints{
            make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(500)
        }
    }
    
    func getPrediction(ft: String, x: Double, a: Double, b: Double) -> Double {
        if ft == "Linear" {
            return a + b * x
        } else if ft == "Power Law" {
            return a*pow(x, b)
        } else if ft == "Exponential" {
            return a*Darwin.exp(b*x)
        }
        return 0.0
    }

    
}
