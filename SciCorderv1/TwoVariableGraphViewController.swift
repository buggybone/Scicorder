import UIKit
import SwiftUI
import Charts

class TwoVariableGraphViewController: UIViewController {
    
    var exp: TwoVariableExperiment? = nil
    
    @IBOutlet weak var myChart: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data: [DataPoint] = []
        for (i, _) in exp!.xData!.enumerated(){
            data.append(DataPoint(x: exp!.xData![i], y: exp!.yData![i]))
        }
        
        let chartController = UIHostingController(rootView: PointChart(data: data))
         myChart.addSubview(chartController.view)
        /*let chartView = PointChart()
        let hostingViewController = UIHostingController(rootView: chartView)
        addChild(hostingViewController)*/
        
        /*if let hostView = hostingViewController.view {
            view.addSubview(hostView)
            NSLayoutConstraint.activate([
                hostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostView.topAnchor.constraint(equalTo: view.topAnchor),
                hostView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }*/
    }
       /* let cont = UIHostingController(rootView: PointChart())
        myChart.addSubview(cont.view)
        if let hostView = cont.view {
                        view.addSubview(hostView)
                        NSLayoutConstraint.activate([
                            hostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                            hostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                            hostView.topAnchor.constraint(equalTo: view.topAnchor),
                            hostView.heightAnchor.constraint(equalToConstant: 300)
                        ])
                    }8/
       /* myChart.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: myChart!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: myChart!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: myChart!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: myChart!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)*/
    
    }*/
    
    
    

    
}
