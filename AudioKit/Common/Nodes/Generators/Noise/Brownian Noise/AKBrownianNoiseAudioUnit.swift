//
//  AKBrownianNoiseAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKBrownianNoiseAudioUnit: AKGeneratorAudioUnitBase {

    func setParameter(_ address: AKBrownianNoiseParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: AKBrownianNoiseParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }

    var amplitude: Double = AKBrownianNoise.defaultAmplitude {
        didSet { setParameter(.amplitude, value: amplitude) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> AKDSPRef {
        return createBrownianNoiseDSP(Int32(count), sampleRate)
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let amplitude = AUParameterTree.createParameter(
            withIdentifier: "amplitude",
            name: "Amplitude",
            address: AKBrownianNoiseParameter.amplitude.rawValue,
            min: Float(AKBrownianNoise.amplitudeRange.lowerBound),
            max: Float(AKBrownianNoise.amplitudeRange.upperBound),
            unit: .generic,
            unitName: nil,
            flags: .default,
            valueStrings: nil,
            dependentParameters: nil
        )
        
        setParameterTree(AUParameterTree.createTree(withChildren: [amplitude]))
        amplitude.value = Float(AKBrownianNoise.defaultAmplitude)
    }

    public override var canProcessInPlace: Bool { return true }

}
