// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#pragma once

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(AUParameterAddress, AKEqualizerFilterParameter) {
    AKEqualizerFilterParameterCenterFrequency,
    AKEqualizerFilterParameterBandwidth,
    AKEqualizerFilterParameterGain,
};

#ifndef __cplusplus

AKDSPRef createEqualizerFilterDSP(void);

#else

#import "AKSoundpipeDSPBase.hpp"

class AKEqualizerFilterDSP : public AKSoundpipeDSPBase {
private:
    struct InternalData;
    std::unique_ptr<InternalData> data;
 
public:
    AKEqualizerFilterDSP();

    void init(int channelCount, double sampleRate) override;

    void deinit() override;

    void reset() override;

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
};

#endif
