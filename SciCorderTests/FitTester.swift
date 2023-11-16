import XCTest
@testable import SciCorder

final class FitTester: XCTestCase {
    var fitController = FitViewController()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLinear1() throws {
        let params = fitController.linearFit(x: [0,1,2,3,4,5], y: [0,1,2,3,4,5,6])
        XCTAssertTrue(params[0] == 0.0)
        XCTAssertTrue(params[1] == 1.0)
    }
    
    func testLinear2() throws {
        let params = fitController.linearFit(x: [0,1,2,3,4,5], y: [30,25,20,15,10,5])
        XCTAssertTrue(params[0] == 30.0)
        XCTAssertTrue(params[1] == -5.0)
    }
    
    func testLinear3() throws {
        let params = fitController.linearFit(x: [0,1,2,3], y: [0,1,4,9])
        XCTAssertTrue(params[0] == -1.0)
        XCTAssertTrue(params[1] == 3.0)
    }
    
    func testPower1() throws {
        var x: [Double] = []
        var y: [Double] = []
        for i in 0...5 {
            x.append(Double(i+1))
            y.append(3*pow(Double(i+1),2))
        }
        let params = fitController.powerFit(x: x, y: y)
        XCTAssertEqual(params[0], 3.0, accuracy: 0.01)
        XCTAssertEqual(params[1], 2.0, accuracy: 0.01)
    }
    
    func testPower2() throws {
        var x: [Double] = []
        var y: [Double] = []
        for i in 0...5 {
            x.append(Double(i+1))
            y.append(7.0*pow(Double(i+1),-2))
        }
        let params = fitController.powerFit(x: x, y: y)
        XCTAssertEqual(params[0], 7.0, accuracy: 0.01)
        XCTAssertEqual(params[1], -2.0, accuracy: 0.01)
    }
    
    func testExponential1() throws {
        var x: [Double] = []
        var y: [Double] = []
        for i in 0...5 {
            x.append(Double(i+1)/2)
            y.append(3*exp(0.1*Double(i+1)/2))
        }
        let params = fitController.powerFit(x: x, y: y)
        XCTAssertEqual(params[0], 3.0, accuracy: 0.01)
        XCTAssertEqual(params[1], 0.1, accuracy: 0.01)
    }

}
