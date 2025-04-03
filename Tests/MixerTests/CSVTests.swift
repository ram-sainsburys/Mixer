import XCTest

@testable import Mixer

class CSVTests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
    }

    func testParseRows() {
        let parsed = CSV(contentsOfFile: csvPath("CSV"))
        XCTAssertEqual(parsed?.rows.count,2)
        
        let firstRow = parsed!.rows[0]
        XCTAssertEqual(firstRow["x"],"1")
        XCTAssertEqual(firstRow["y"],"23")
        XCTAssertEqual(firstRow["z"],"4")
        
        let secondRow = parsed!.rows[1]
        XCTAssertEqual(secondRow["x"],"5")
        XCTAssertEqual(secondRow["y"],"67")
        XCTAssertEqual(secondRow["z"],"8")
    }
    
    func testParseCorrupt() {
        let parsed = CSV(contentsOfFile: csvPath("CorruptFile"))
        XCTAssertNil(parsed)
    }
    
    fileprivate func csvPath(_ fileName: String) -> String {
        guard let csvPath = Bundle.module.url(forResource: fileName, withExtension: "csv") else {
            print("Failed to find resource")
            return ""
        }
        return csvPath.path
    }
}
