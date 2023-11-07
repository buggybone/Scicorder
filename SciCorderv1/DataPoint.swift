import Foundation
import Charts
import SwiftUI
import UIKit


struct DataPoint: Identifiable{
    var x: Double
    var y: Double
    var id = UUID()
}

struct PointChart: View {
    var data: [DataPoint] = []
    var fitData: [DataPoint] = []
    var xLabel = "x axis"
    var yLabel = "y axis"
    
    var body: some View {
                Chart{
                    ForEach(data) { datum in
                        PointMark(x: PlottableValue.value("x",datum.x), y: PlottableValue.value("y",datum.y))
                        .foregroundStyle(Color("Gray"))
                    }
                    ForEach(fitData) { datum in
                        LineMark(x: PlottableValue.value("x",datum.x), y: PlottableValue.value("y",datum.y))
                            .foregroundStyle(Color("Orange"))
                    }
                    .interpolationMethod(.catmullRom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxisLabel(position: .bottom, alignment: .center) {
                    Text(xLabel)
                }
                .chartYAxisLabel(position: .trailing, alignment: .center) {
                    Text(yLabel)
                }
    }
}

struct Bar: Identifiable{
    var rng: String
    var count: Int
    var id = UUID()
}

func processArray(arr: [Double]) -> [Bar]{
    var res: [Bar] = []
    let n = arr.count
    let numBins = Int(n/10)
    var mx = arr.max() ?? 0.0
    var mn = arr.min() ?? 0.0
    var rng = mx - mn
    mx = mx + 0.2*rng
    mn = mn - 0.2*rng
    rng *= 1.4
    
    var counts: [Int] = []
    for _ in 0...numBins{
        counts.append(0)
    }
    
    for i in 0...(n-1){
        let slot = Int(floor( (arr[i] - mn) / rng * (Double(numBins) - 0.001) ) )
        counts[slot] += 1
    }
    
    for i in 0...numBins {
        let rangeStr = String(format: "%.2f", mn + Double(i)/Double(numBins)*rng) + "-" + String(format: "%.2f", mn + Double(i+1)/Double(numBins)*rng)
        res.append(Bar(rng: rangeStr, count: counts[i]))
    }
    
    return res
  
}

struct Histogram: View {
    var data: [Bar] = []
    
    var body: some View {
        Chart{
            ForEach(data) { bar in
                BarMark(x: .value("x", bar.rng),
                        y: PlottableValue.value("y",bar.count))
                    .foregroundStyle(Color("Orange"))
                    .annotation(position: .top, alignment: .bottom, spacing: 0) {
                        Text("\(bar.rng)")
                            .font(.system(size: 12))
                            .rotationEffect(.degrees(90))
                    }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis(.hidden)
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Range")
        }
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("Count")
        }
        
    }
}
