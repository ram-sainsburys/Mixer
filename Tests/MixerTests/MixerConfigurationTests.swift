import XCTest
import Mixer

class MixerConfigurationTests: XCTestCase {

    func testSizeDefinitionsPath() {
        let configuration = MixerConfiguration(colorDefinitionsPath: "PATH")
        XCTAssertEqual(configuration.colorDefinitionsPath,"PATH")
    }

}
