// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

/// 8 delay line stereo FDN reverb, with feedback matrix based upon physical
/// modeling scattering junction of 8 lossless waveguides of equal
/// characteristic impedance.
///
open class AKCostelloReverb: AKNode, AKToggleable, AKComponent, AKInput {
    public typealias AKAudioUnitType = AKCostelloReverbAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(effect: "rvsc")

    // MARK: - Properties
    public private(set) var internalAU: AKAudioUnitType?

    /// Lower and upper bounds for Feedback
    public static let feedbackRange: ClosedRange<Double> = 0.0 ... 1.0

    /// Lower and upper bounds for Cutoff Frequency
    public static let cutoffFrequencyRange: ClosedRange<Double> = 12.0 ... 20_000.0

    /// Initial value for Feedback
    public static let defaultFeedback: Double = 0.6

    /// Initial value for Cutoff Frequency
    public static let defaultCutoffFrequency: Double = 4_000.0

    /// Feedback level in the range 0 to 1. 0.6 gives a good small 'live' room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable.
    @objc open var feedback: Double = defaultFeedback {
        willSet {
            let clampedValue = AKCostelloReverb.feedbackRange.clamp(newValue)
            guard feedback != clampedValue else { return }
            internalAU?.feedback.value = AUValue(clampedValue)
        }
    }

    /// Low-pass cutoff frequency.
    @objc open var cutoffFrequency: Double = defaultCutoffFrequency {
        willSet {
            let clampedValue = AKCostelloReverb.cutoffFrequencyRange.clamp(newValue)
            guard cutoffFrequency != clampedValue else { return }
            internalAU?.cutoffFrequency.value = AUValue(clampedValue)
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    @objc open var isStarted: Bool {
        return internalAU?.isStarted ?? false
    }

    // MARK: - Initialization

    /// Initialize this reverb node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - feedback: Feedback level in the range 0 to 1. 0.6 gives a good small 'live' room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable.
    ///   - cutoffFrequency: Low-pass cutoff frequency.
    ///
    public init(
        _ input: AKNode? = nil,
        feedback: Double = defaultFeedback,
        cutoffFrequency: Double = defaultCutoffFrequency
        ) {
        super.init(avAudioNode: AVAudioNode())

        _Self.register()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit
            self.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
            input?.connect(to: self)

            self.feedback = feedback
            self.cutoffFrequency = cutoffFrequency
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
