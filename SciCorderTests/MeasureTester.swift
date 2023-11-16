
import XCTest
@testable import SciCorder

final class MeasureTester: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMeasureMethodValuesReturned() throws {
        let controller = TwoVariableExperimentViewController()
        for i in 0...(K.measurementTypes.count-1){
            XCTAssertNotNil(controller.measure(measIndex: i))
        }
    }
    
    

}
