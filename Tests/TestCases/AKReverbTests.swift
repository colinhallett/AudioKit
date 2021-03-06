// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit

class AKReverbTests: AKTestCase {

    #if os(iOS)

    func testBypass() {
        let reverb = AKReverb(input)
        reverb.bypass()
        output = reverb
        AKTestNoEffect()
    }

    func testCathedral() {
        let effect = AKReverb(input)
        output = effect
        effect.loadFactoryPreset(.cathedral)
        AKTestMD5("7281cc33badbdeec0280dc1711bb92ce")
    }

    func testDefault() {
        output = AKReverb(input)
        AKTestMD5("b9351188e123ed02502c7a5559a1499c")
    }

    func testSmallRoom() {
        let effect = AKReverb(input)
        output = effect
        effect.loadFactoryPreset(.smallRoom)
        AKTestMD5("da887657fae100779db2f244ee142638")
    }
    #endif

}
