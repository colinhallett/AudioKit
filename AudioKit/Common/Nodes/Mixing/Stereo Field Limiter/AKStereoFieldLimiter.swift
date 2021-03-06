// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

/// Stereo StereoFieldLimiter
///
open class AKStereoFieldLimiter: AKNode, AKToggleable, AKComponent, AKInput {
    public typealias AKAudioUnitType = AKStereoFieldLimiterAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(effect: "sflm")

    // MARK: - Properties

    public private(set) var internalAU: AKAudioUnitType?

    /// Limiting Factor
    @objc open var amount: Double = 1 {
        willSet {
            let clampedValue = (0.0 ... 1.0).clamp(newValue)
            guard amount != clampedValue else { return }
            internalAU?.amount.value = AUValue(clampedValue)
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    @objc open var isStarted: Bool {
        return self.internalAU?.isStarted ?? false
    }

    // MARK: - Initialization

    /// Initialize this booster node
    ///
    /// - Parameters:
    ///   - input: AKNode whose output will be amplified
    ///   - amount: limit factor (Default: 1, Minimum: 0)
    ///
    public init(_ input: AKNode? = nil, amount: Double = 1) {
        super.init(avAudioNode: AVAudioNode())

        _Self.register()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit
            self.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
            input?.connect(to: self)

            self.amount = amount
        }
    }

    // MARK: - Control

    /// Function to start, play, or activate the node, all do the same thing
    @objc open func start() {
        internalAU?.start()
    }

    /// Function to stop or bypass the node, both are equivalent
    @objc open func stop() {
        internalAU?.stop()
    }
}
