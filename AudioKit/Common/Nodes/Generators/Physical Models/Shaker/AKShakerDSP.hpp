// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#pragma once

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(AUParameterAddress, AKShakerParameter) {
    AKShakerParameterType,
    AKShakerParameterAmplitude,
};

#import "AKLinearParameterRamp.hpp"  // have to put this here to get it included in umbrella header

#ifndef __cplusplus

AKDSPRef createShakerDSP(void);

void triggerTypeShakerDSP(AKDSPRef dsp, AUValue type, AUValue amplitude);

#else

class AKShakerDSP : public AKDSPBase {
private:
    struct InternalData;
    std::unique_ptr<InternalData> data;

public:

    AKShakerDSP();

    ~AKShakerDSP();

    /// Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, float value, bool immediate) override;

    /// Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address) override;

    void init(int channelCount, double sampleRate) override;

    void trigger() override;

    void triggerTypeAmplitude(AUValue freq, AUValue amp);

    void deinit() override;

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;

    void handleMIDIEvent(AUMIDIEvent const& midiEvent) override;
};

#endif


