// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit

class AKLowPassButterworthFilterTests: AKTestCase {

    func testCutoffFrequency() {
        output = AKLowPassButterworthFilter(input, cutoffFrequency: 500)
        AKTestMD5("24d38626ef741d83e9cdfc00a8a22aa3")
    }

    func testDefault() {
        output = AKLowPassButterworthFilter(input)
        AKTestMD5("062814922f4b6d38e106b9be5ab1d019")
    }

}
