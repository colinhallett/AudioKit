// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

public class AKPannerAudioUnit: AKAudioUnitBase {

    private(set) var pan: AUParameter!

    public override func createDSP() -> AKDSPRef {
        return createPannerDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        pan = AUParameter(
            identifier: "pan",
            name: "Panning. A value of -1 is hard left, and a value of 1 is hard right, and 0 is center.",
            address: AKPannerParameter.pan.rawValue,
            range: AKPanner.panRange,
            unit: .generic,
            flags: .default)

        parameterTree = AUParameterTree.createTree(withChildren: [pan])

        pan.value = AUValue(AKPanner.defaultPan)
    }
}
