// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation
import AudioKit

public class SDBoosterAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: SDBoosterParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: SDBoosterParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var leftGain: Double = 1.0 {
        didSet { setParameter(.leftGain, value: leftGain) }
    }

    var rightGain: Double = 1.0 {
        didSet { setParameter(.rightGain, value: rightGain) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> AKDSPRef {
        return createSDBoosterDSP(Int32(count), sampleRate)
    }

    override public init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]
        let leftGain = AUParameterTree.createParameter(withIdentifier: "leftGain",
                                                       name: "Left Boosting Amount",
                                                       address: AUParameterAddress(0),
                                                       min: 0.0, max: 2.0,
                                                       unit: .linearGain, unitName: nil,
                                                       flags: flags,
                                                       valueStrings: nil, dependentParameters: nil)
        let rightGain = AUParameterTree.createParameter(withIdentifier: "rightGain",
                                                        name: "Right Boosting Amount",
                                                        address: AUParameterAddress(1),
                                                        min: 0.0, max: 2.0,
                                                        unit: .linearGain, unitName: nil,
                                                        flags: flags,
                                                        valueStrings: nil, dependentParameters: nil)
        setParameterTree(AUParameterTree.createTree(withChildren: [leftGain, rightGain]))
        leftGain.value = 1.0
        rightGain.value = 1.0
    }

    public override var canProcessInPlace: Bool { return true; }

}
