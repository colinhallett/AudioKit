// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#pragma once

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#if !TARGET_OS_TV
#import <CoreAudioKit/CoreAudioKit.h>
#endif

//! Project version number for AudioKit.
FOUNDATION_EXPORT double AudioKitVersionNumber;

//! Project version string for AudioKit.
FOUNDATION_EXPORT const unsigned char AudioKitVersionString[];

#import "AKDSPBase.hpp"
#import "AKSoundpipeDSPBase.hpp"
#import "DSPKernel.hpp"
#import "AKDSPKernel.hpp"
#import "AKSoundpipeKernel.hpp"
#import "AKBankDSPKernel.hpp"
#import "AKFilterSynthDSPKernel.hpp"
#import "ExceptionCatcher.h"

// Analysis
#import "AKAmplitudeTrackerAudioUnit.h"
#import "AKFrequencyTrackerAudioUnit.h"
#if !TARGET_OS_TV
#import "AKMicrophoneTrackerEngine.h"
#endif

// Effects
#import "AKOperationEffectAudioUnit.h"
#import "AKSporthStack.h"

// Effects / Delay
#import "AKVariableDelayDSP.hpp"
#import "AKStereoDelayDSP.hpp"

// Effects / Distortion
#import "AKBitCrusherDSP.hpp"
#import "AKClipperDSP.hpp"
#import "AKTanhDistortionDSP.hpp"

// Effects / Dynamics
#import "AKDynamicRangeCompressorDSP.hpp"

// Effects / Envelopes
#import "AKAmplitudeEnvelopeDSP.hpp"
#import "AKTremoloDSP.hpp"

// Effects / Filters
#import "AKAutoWahDSP.hpp"
#import "AKBandPassButterworthFilterDSP.hpp"
#import "AKBandRejectButterworthFilterDSP.hpp"
#import "AKDCBlockDSP.hpp"
#import "AKEqualizerFilterDSP.hpp"
#import "AKFormantFilterDSP.hpp"
#import "AKHighPassButterworthFilterDSP.hpp"
#import "AKHighShelfParametricEqualizerFilterDSP.hpp"
#import "AKKorgLowPassFilterDSP.hpp"
#import "AKLowPassButterworthFilterDSP.hpp"
#import "AKLowShelfParametricEqualizerFilterDSP.hpp"
#import "AKModalResonanceFilterDSP.hpp"
#import "AKMoogLadderDSP.hpp"
#import "AKPeakingParametricEqualizerFilterDSP.hpp"
#import "AKResonantFilterDSP.hpp"
#import "AKRolandTB303FilterDSP.hpp"
#import "AKStringResonatorDSP.hpp"
#import "AKThreePoleLowpassFilterDSP.hpp"
#import "AKToneComplementFilterDSP.hpp"
#import "AKToneFilterDSP.hpp"

// Effects / Guitar Processors
#import "AKDynaRageCompressorDSP.hpp"
#import "AKRhinoGuitarProcessorDSP.hpp"

// Effects / Modulation
#import "AKModulatedDelay_Typedefs.h"
#import "AKModulatedDelay.hpp"
#import "AKModulatedDelayDSP.hpp"
#import "AKPhaserDSP.hpp"

// Effects / Pitch Shifter
#import "AKPitchShifterDSP.hpp"

// Effects / Reverb
#import "AKChowningReverbDSP.hpp"
#import "AKCombFilterReverbDSP.hpp"
#import "AKConvolutionDSP.hpp"
#import "AKCostelloReverbDSP.hpp"
#import "AKFlatFrequencyResponseReverbDSP.hpp"
#import "AKZitaReverbDSP.hpp"

// Generators
#import "AKOperationGeneratorAudioUnit.h"

// Generators / Noise
#import "AKBrownianNoiseDSP.hpp"
#import "AKPinkNoiseDSP.hpp"
#import "AKWhiteNoiseDSP.hpp"

// Generators / Oscillators
#import "AKFMOscillatorDSP.hpp"
#import "AKMorphingOscillatorDSP.hpp"
#import "AKOscillatorDSP.hpp"
#import "AKPhaseDistortionOscillatorDSP.hpp"
#import "AKPWMOscillatorDSP.hpp"

// Generators / Physical Models
#import "AKClarinetDSP.hpp"
#import "AKDripDSP.hpp"
#import "AKFluteDSP.hpp"
#import "AKMandolinAudioUnit.h"
#import "AKMetalBarDSP.hpp"
#import "AKRhodesPianoDSP.hpp"
#import "AKPluckedStringDSP.hpp"
#import "AKShakerDSP.hpp"
#import "AKTubularBellsDSP.hpp"
#import "AKVocalTractDSP.hpp"

// Generators / Polysynths
#import "AKFMOscillatorBankAudioUnit.h"
#import "AKMorphingOscillatorBankAudioUnit.h"
#import "AKOscillatorBankAudioUnit.h"
#import "AKPhaseDistortionOscillatorBankAudioUnit.h"
#import "AKPWMOscillatorBankAudioUnit.h"
#import "AKSynthDSP.hpp"

// Generators / Filter Polysynths
#import "AKFMOscillatorFilterSynthAudioUnit.h"
#import "AKMorphingOscillatorFilterSynthAudioUnit.h"
#import "AKOscillatorFilterSynthAudioUnit.h"
#import "AKPhaseDistortionOscillatorFilterSynthAudioUnit.h"
#import "AKPWMOscillatorFilterSynthAudioUnit.h"

// Mixing
#import "AKAutoPannerDSP.hpp"
#import "AKBalancerDSP.hpp"
#import "AKBoosterDSP.hpp"
#import "AKFaderDSP.hpp"
#import "AKPannerDSP.hpp"
#import "AKStereoFieldLimiterDSP.hpp"

// Playback
#import "AKPhaseLockedVocoderDSP.hpp"
#import "AKWaveTableAudioUnit.h"
#import "AKDiskStreamerAudioUnit.h"
#import "AKPresetManager.h"
#import "AKSampler_Typedefs.h"
#import "AKCoreSampler.hpp"
#import "AKCoreSynth.hpp"
#import "AKSamplerDSP.hpp"

#if !TARGET_OS_TV
#import "AKCallbackInstrumentAudioUnit.h"
#endif

// Testing
#import "AKTesterAudioUnit.h"

// EZAudio
#import "EZAudio.h"

// Taps
#import "AKRenderTap.h"
#import "AKLazyTap.h"
#import "AKTimelineTap.h"

// Utilities
#import "TPCircularBuffer.h"
#import "TPCircularBuffer+Unit.h"
#import "TPCircularBuffer+AudioBufferList.h"
#import "ParameterRamper.hpp"
#import "BufferedAudioBus.hpp"
#import "AKTimeline.h"

// Sequencer
#import "AKSamplerMetronome.h"
#if !TARGET_OS_TV
#import "AKSequencerEngineDSP.hpp"
#endif

// Swift/ObjC/C/C++ Inter-operability
#import "AKInterop.hpp"

// Automation
#import "AKParameterAutomation.h"
