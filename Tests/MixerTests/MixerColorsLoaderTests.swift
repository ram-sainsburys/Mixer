import XCTest

@testable import Mixer

class MixerColorsLoaderTests: XCTestCase {
    
    var fileManager: FileManager!
    
    override func setUp() {
        fileManager = FileManager.default
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCache() {
        let testPath = copyCSVFixtureToTestPath(csvPath("Colors"))
        MixerColorsLoader(path: testPath).load()
        removeCSVFixtureAtPath(testPath)
        
        let cacheLoader = MixerColorsLoader(path: testPath)
        
        let cachedResult = cacheLoader.load()
        XCTAssertEqual(cachedResult?.keys.count, 3)
        XCTAssertNotNil(cachedResult?["Blue"])
        
        cacheLoader.clear()
        
        let deletedResult = cacheLoader.load()
        XCTAssertNil(deletedResult)
    }
    
    fileprivate func copyCSVFixtureToTestPath(_ path: String) -> String {
        let newPath = path.replacingOccurrences(of: "Colors", with: "CorrectFontSizes-CacheTest")
        do {
            try fileManager.copyItem(atPath: path, toPath: newPath)
        } catch _ {
            assertionFailure("Could not copy file for cache test")
        }
        
        return newPath
    }
    
    fileprivate func removeCSVFixtureAtPath(_ path: String) {
        do {
            try fileManager.removeItem(atPath: path)
        } catch _ {
            assertionFailure("Could not remove file for cache test")
        }
    }
    
    func testWithIncorrectPath() {
        let incorrectPath = "Something/Something"
        let colors = MixerColorsLoader(path: incorrectPath).load()
        XCTAssertNil(colors)
    }
    
    func testWithCorrectCSV() {
        let loader = MixerColorsLoader(path: csvPath("Colors"))
        let colors = loader.load()
        XCTAssertEqual(colors?.keys.count, 3)
        XCTAssertNotNil(colors?["Red"])
        loader.clear()
    }

    func testWithCSVWithMissingHeader() {
        let colors = MixerColorsLoader(path: csvPath("MissingHeader")).load()
        XCTAssertNil(colors)
    }
    
    func testWithMissingRGBChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("MissingRGBChannelValues")).load()
        XCTAssertNil(colors)
    }
    
    
    func testWithMissingAlphaChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("MissingAlphaChannelValues")).load()
        XCTAssertNil(colors)
    }
    
    func testWithNonIntegerRGBChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("NonIntegerRGBChannelValues")).load()
        XCTAssertNil(colors)
    }
    
    func testWithNonFloatAlphaChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("NonFloatAlphaChannelValues")).load()
        XCTAssertNil(colors)
    }
    
    func testWithInvalidRGBChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("InvalidRGBChannelValues")).load()
        XCTAssertNil(colors)
    }
    
    func testWithInvalidAlphaChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("InvalidAlphaChannelValues")).load()
        XCTAssertNil(colors)
    }
    
    func testWithIncorrectValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("IncorrectValues")).load()
        XCTAssertNil(colors)
    }
    
    func testWithCorruptFile() {
        let colors = MixerColorsLoader(path: csvPath("CorruptFile")).load()
        XCTAssertNil(colors)
    }
    
    fileprivate func csvPath(_ fileName: String) -> String {
        guard let csvPath = Bundle.module.url(forResource: fileName, withExtension: "csv") else {
            print("Failed to find resource")
            return ""
        }
        return csvPath.path
    }
}
