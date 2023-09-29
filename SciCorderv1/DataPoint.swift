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
    var data = [
    DataPoint(x: 1, y: 1),
    DataPoint(x: 2, y: 2),
    DataPoint(x: 3, y: 3)
    ]
    
    var body: some View {
        Chart{
            ForEach(data) { datum in
                PointMark(x: PlottableValue.value("x",datum.x), y: PlottableValue.value("y",datum.y))
            }
        }
        .frame(width: 200, height: 200)
    }
}
