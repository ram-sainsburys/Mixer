import XCTest
import Mixer

enum Color: String, MixerColor {
    case Blue
    
    var name: String { return rawValue }
}

class MixerTests: XCTestCase {
    
    var mixer: Mixer!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        guard let csvPath = Bundle.module.url(forResource: "Colors", withExtension: "csv") else {
            assertionFailure("Color fixture file Colors.csv is missing")
            return
        }
        
        mixer = Mixer(
            configuration: MixerConfiguration(colorDefinitionsPath: csvPath.path)
        )
    }
    
    override func tearDown() {
        mixer = nil
        super.tearDown()
    }
    
    func testConvenienceInit() {
        let convenienceMixer = Mixer(bundle: Bundle.module.self)
        XCTAssertTrue(convenienceMixer.hasColors)
    }
    
    func testConvenienceInitWithMissingFile() {
        let convenienceMixer = Mixer(bundle: Bundle())
        XCTAssertFalse(convenienceMixer.hasColors)
    }
    
    func testConvenienceInitPerformance() {
        self.measure {
            for _ in 1..<10000 {
                let _ = Mixer(bundle: Bundle(for: type(of: self)))
            }
        }
    }
    
    func testColorFor() {
        let color = mixer.colorFor(Color.Blue)
        let (red, green, blue, alpha) = extractColorValues(color)
        
        XCTAssertEqual(red, 0.0)
        XCTAssertEqual(green, 0.0)
        XCTAssertEqual(blue, 0.8)
        XCTAssertEqual(alpha, 1.0)
    }
    
    func testColorForString() {
        let color = mixer.colorFor("Red")
        let (red, green, blue, alpha) = extractColorValues(color)
        
        XCTAssertEqual(red, 0.8)
        XCTAssertEqual(green, 0.0)
        XCTAssertEqual(blue, 0.0)
        XCTAssertGreaterThanOrEqual(alpha, 0.001)
        XCTAssertLessThanOrEqual(alpha,0.9)
    }
    
    fileprivate func extractColorValues(_ color: UIColor?) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = -1.0
        var green: CGFloat = -1.0
        var blue: CGFloat = -1.0
        var alpha: CGFloat = -1.0
        
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }

    
}
