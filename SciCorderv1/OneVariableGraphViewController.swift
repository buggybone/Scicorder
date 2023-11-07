import UIKit
import SwiftUI
import Charts

class OneVariableGraphViewController: UIViewController {
    
    var exp: OneVariableExperiment? = nil
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = exp?.data ?? [0.0]
        
        let binnedData: [Bar] = processArray(arr: data)
        
        let mean = data.reduce(0.0,+)/Double(data.count)
        var sStdDev = 0.0
        for (i,_) in data.enumerated(){
            sStdDev += pow(data[i] - mean, 2)
        }
        sStdDev /= (Double(data.count) - 1.0)
        sStdDev = pow(sStdDev, 0.5)
        
        let labelStr = "Mean = \(String(format: "%.2f", mean))\n" + "Standard Deviation = \(String(format: "%.2f", sStdDev))"
        summaryLabel.text = labelStr
        
        let theChart = Histogram(data: binnedData)
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

}
