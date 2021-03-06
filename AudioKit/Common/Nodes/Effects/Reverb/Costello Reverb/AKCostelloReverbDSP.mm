// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#include "AKCostelloReverbDSP.hpp"
#include "AKLinearParameterRamp.hpp"

extern "C" AKDSPRef createCostelloReverbDSP() {
    return new AKCostelloReverbDSP();
}

struct AKCostelloReverbDSP::InternalData {
    sp_revsc *revsc;
    AKLinearParameterRamp feedbackRamp;
    AKLinearParameterRamp cutoffFrequencyRamp;
};

AKCostelloReverbDSP::AKCostelloReverbDSP() : data(new InternalData) {
    parameters[AKCostelloReverbParameterFeedback] = &data->feedbackRamp;
    parameters[AKCostelloReverbParameterCutoffFrequency] = &data->cutoffFrequencyRamp;
}

void AKCostelloReverbDSP::init(int channelCount, double sampleRate) {
    AKSoundpipeDSPBase::init(channelCount, sampleRate);
    sp_revsc_create(&data->revsc);
    sp_revsc_init(sp, data->revsc);
}

void AKCostelloReverbDSP::deinit() {
    AKSoundpipeDSPBase::deinit();
    sp_revsc_destroy(&data->revsc);
}

void AKCostelloReverbDSP::reset() {
    AKSoundpipeDSPBase::reset();
    if (!isInitialized) return;
    sp_revsc_init(sp, data->revsc);
}

void AKCostelloReverbDSP::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {

    for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
        int frameOffset = int(frameIndex + bufferOffset);

        // do ramping every 8 samples
        if ((frameOffset & 0x7) == 0) {
            data->feedbackRamp.advanceTo(now + frameOffset);
            data->cutoffFrequencyRamp.advanceTo(now + frameOffset);
        }

        data->revsc->feedback = data->feedbackRamp.getValue();
        data->revsc->lpfreq = data->cutoffFrequencyRamp.getValue();

        float *tmpin[2];
        float *tmpout[2];
        for (int channel = 0; channel < channelCount; ++channel) {
            float *in  = (float *)inputBufferLists[0]->mBuffers[channel].mData  + frameOffset;
            float *out = (float *)outputBufferLists[0]->mBuffers[channel].mData + frameOffset;
            if (channel < 2) {
                tmpin[channel] = in;
                tmpout[channel] = out;
            }
            if (!isStarted) {
                *out = *in;
                continue;
            }
            
        }
        if (isStarted) {
            sp_revsc_compute(sp, data->revsc, tmpin[0], tmpin[1], tmpout[0], tmpout[1]);
        }
    }
}
