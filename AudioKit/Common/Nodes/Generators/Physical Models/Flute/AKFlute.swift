// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

/// STK Flute
///
open class AKFlute: AKNode, AKToggleable, AKComponent {
    public typealias AKAudioUnitType = AKFluteAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(generator: "flut")
    // MARK: - Properties

    public private(set) var internalAU: AKAudioUnitType?

    /// Variable frequency. Values less than the initial frequency will be doubled until it is greater than that.
    @objc open var frequency: Double = 110 {
        willSet {
            let clampedValue = (0.0 ... 20_000.0).clamp(newValue)
            guard frequency != clampedValue else { return }
            internalAU?.frequency.value = AUValue(clampedValue)
        }
    }

    /// Amplitude
    @objc open var amplitude: Double = 0.5 {
        willSet {
            let clampedValue = (0.0 ... 10.0).clamp(newValue)
            guard amplitude != clampedValue else { return }
            internalAU?.amplitude.value = AUValue(clampedValue)
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    @objc open var isStarted: Bool {
        return internalAU?.isStarted ?? false
    }

    // MARK: - Initialization
    
    /// Initialize the STK Flute model
    ///
    /// - Parameters:
    ///   - frequency: Variable frequency. Values less than the initial frequency will be doubled until it is
    ///                greater than that.
    ///   - amplitude: Amplitude
    ///
    public init(
        frequency: Double = 440,
        amplitude: Double = 0.5
    ) {
        super.init(avAudioNode: AVAudioNode())

        _Self.register()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit
            self.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType

            self.frequency = frequency
            self.amplitude = amplitude
        }
    }

    /// Trigger the sound with current parameters
    ///
    open func trigger() {
        internalAU?.start()
        internalAU?.trigger()
    }

    /// Trigger the sound with a set of parameters
    ///
    /// - Parameters:
    ///   - frequency: Frequency in Hz
    ///   - amplitude amplitude: Volume
    ///
    open func trigger(frequency: Double, amplitude: Double = 1) {
        self.frequency = frequency
        self.amplitude = amplitude
        internalAU?.start()
        internalAU?.triggerFrequency(Float(frequency), amplitude: Float(amplitude))
    }

    /// Function to start, play, or activate the node, all do the same thing
    @objc open func start() {
        internalAU?.start()
    }

    /// Function to stop or bypass the node, both are equivalent
    @objc open func stop() {
        internalAU?.stop()
    }
}
