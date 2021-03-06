// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit

class AKRhinoGuitarProcessorTests: AKTestCase {

    func testDefault() {
        output = AKRhinoGuitarProcessor(input)
        AKTestMD5("5a0a09660ce124b9fc2d7bb7090fd630")
    }

    func testDistortion() {
        output = AKRhinoGuitarProcessor(input, distortion: 3)
        AKTestMD5("597bcc216f933f6b168e6013e0c52675")
    }

    func testHighGain() {
        output = AKRhinoGuitarProcessor(input, highGain: 0.55)
        AKTestMD5("87900b5fad7fcbe2729d5826d012fc3c")
    }

    func testLowGain() {
        output = AKRhinoGuitarProcessor(input, lowGain: 0.66)
        AKTestMD5("613e9723b684628fd11e9356e9dc90bb")
    }

    func testMidGain() {
        output = AKRhinoGuitarProcessor(input, midGain: 0.44)
        AKTestMD5("6ad619875029395035207487ac9b340b")
    }

    func testPostGain() {
        output = AKRhinoGuitarProcessor(input, postGain: 2.2)
        AKTestMD5("2936e5f03b9d864edc4f1fde4a6d078c")
    }

    func testPreGain() {
        output = AKRhinoGuitarProcessor(input, preGain: 2.2)
        AKTestMD5("906770d6b1463fafe8ea23e51e6c9050")
    }

}
