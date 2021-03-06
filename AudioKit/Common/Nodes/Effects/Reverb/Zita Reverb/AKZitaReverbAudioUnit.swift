// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

public class AKZitaReverbAudioUnit: AKAudioUnitBase {

    private(set) var predelay: AUParameter!

    private(set) var crossoverFrequency: AUParameter!

    private(set) var lowReleaseTime: AUParameter!

    private(set) var midReleaseTime: AUParameter!

    private(set) var dampingFrequency: AUParameter!

    private(set) var equalizerFrequency1: AUParameter!

    private(set) var equalizerLevel1: AUParameter!

    private(set) var equalizerFrequency2: AUParameter!

    private(set) var equalizerLevel2: AUParameter!

    private(set) var dryWetMix: AUParameter!

    public override func createDSP() -> AKDSPRef {
        return createZitaReverbDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        predelay = AUParameter(
            identifier: "predelay",
            name: "Delay in ms before reverberation begins.",
            address: AKZitaReverbParameter.predelay.rawValue,
            range: AKZitaReverb.predelayRange,
            unit: .generic,
            flags: .default)
        crossoverFrequency = AUParameter(
            identifier: "crossoverFrequency",
            name: "Crossover frequency separating low and middle frequencies (Hz).",
            address: AKZitaReverbParameter.crossoverFrequency.rawValue,
            range: AKZitaReverb.crossoverFrequencyRange,
            unit: .hertz,
            flags: .default)
        lowReleaseTime = AUParameter(
            identifier: "lowReleaseTime",
            name: "Time (in seconds) to decay 60db in low-frequency band.",
            address: AKZitaReverbParameter.lowReleaseTime.rawValue,
            range: AKZitaReverb.lowReleaseTimeRange,
            unit: .seconds,
            flags: .default)
        midReleaseTime = AUParameter(
            identifier: "midReleaseTime",
            name: "Time (in seconds) to decay 60db in mid-frequency band.",
            address: AKZitaReverbParameter.midReleaseTime.rawValue,
            range: AKZitaReverb.midReleaseTimeRange,
            unit: .seconds,
            flags: .default)
        dampingFrequency = AUParameter(
            identifier: "dampingFrequency",
            name: "Frequency (Hz) at which the high-frequency T60 is half the middle-band's T60.",
            address: AKZitaReverbParameter.dampingFrequency.rawValue,
            range: AKZitaReverb.dampingFrequencyRange,
            unit: .hertz,
            flags: .default)
        equalizerFrequency1 = AUParameter(
            identifier: "equalizerFrequency1",
            name: "Center frequency of second-order Regalia Mitra peaking equalizer section 1.",
            address: AKZitaReverbParameter.equalizerFrequency1.rawValue,
            range: AKZitaReverb.equalizerFrequency1Range,
            unit: .hertz,
            flags: .default)
        equalizerLevel1 = AUParameter(
            identifier: "equalizerLevel1",
            name: "Peak level in dB of second-order Regalia-Mitra peaking equalizer section 1",
            address: AKZitaReverbParameter.equalizerLevel1.rawValue,
            range: AKZitaReverb.equalizerLevel1Range,
            unit: .generic,
            flags: .default)
        equalizerFrequency2 = AUParameter(
            identifier: "equalizerFrequency2",
            name: "Center frequency of second-order Regalia Mitra peaking equalizer section 2.",
            address: AKZitaReverbParameter.equalizerFrequency2.rawValue,
            range: AKZitaReverb.equalizerFrequency2Range,
            unit: .hertz,
            flags: .default)
        equalizerLevel2 = AUParameter(
            identifier: "equalizerLevel2",
            name: "Peak level in dB of second-order Regalia-Mitra peaking equalizer section 2",
            address: AKZitaReverbParameter.equalizerLevel2.rawValue,
            range: AKZitaReverb.equalizerLevel2Range,
            unit: .generic,
            flags: .default)
        dryWetMix = AUParameter(
            identifier: "dryWetMix",
            name: "0 = all dry, 1 = all wet",
            address: AKZitaReverbParameter.dryWetMix.rawValue,
            range: AKZitaReverb.dryWetMixRange,
            unit: .generic,
            flags: .default)

        parameterTree = AUParameterTree.createTree(withChildren: [predelay,
                                                                  crossoverFrequency,
                                                                  lowReleaseTime,
                                                                  midReleaseTime,
                                                                  dampingFrequency,
                                                                  equalizerFrequency1,
                                                                  equalizerLevel1,
                                                                  equalizerFrequency2,
                                                                  equalizerLevel2,
                                                                  dryWetMix])

        predelay.value = AUValue(AKZitaReverb.defaultPredelay)
        crossoverFrequency.value = AUValue(AKZitaReverb.defaultCrossoverFrequency)
        lowReleaseTime.value = AUValue(AKZitaReverb.defaultLowReleaseTime)
        midReleaseTime.value = AUValue(AKZitaReverb.defaultMidReleaseTime)
        dampingFrequency.value = AUValue(AKZitaReverb.defaultDampingFrequency)
        equalizerFrequency1.value = AUValue(AKZitaReverb.defaultEqualizerFrequency1)
        equalizerLevel1.value = AUValue(AKZitaReverb.defaultEqualizerLevel1)
        equalizerFrequency2.value = AUValue(AKZitaReverb.defaultEqualizerFrequency2)
        equalizerLevel2.value = AUValue(AKZitaReverb.defaultEqualizerLevel2)
        dryWetMix.value = AUValue(AKZitaReverb.defaultDryWetMix)
    }
}
