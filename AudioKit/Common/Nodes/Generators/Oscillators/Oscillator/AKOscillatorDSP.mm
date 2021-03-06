// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#include "AKOscillatorDSP.hpp"
#include "AKLinearParameterRamp.hpp"
#include <vector>

extern "C" AKDSPRef createOscillatorDSP() {
    return new AKOscillatorDSP();
}

struct AKOscillatorDSP::InternalData {
    sp_osc *osc;
    sp_ftbl *ftbl;
    std::vector<float> waveform;
    AKLinearParameterRamp frequencyRamp;
    AKLinearParameterRamp amplitudeRamp;
    AKLinearParameterRamp detuningOffsetRamp;
    AKLinearParameterRamp detuningMultiplierRamp;
};

AKOscillatorDSP::AKOscillatorDSP() : data(new InternalData) {
    parameters[AKOscillatorParameterFrequency] = &data->frequencyRamp;
    parameters[AKOscillatorParameterAmplitude] = &data->amplitudeRamp;
    parameters[AKOscillatorParameterDetuningOffset] = &data->detuningOffsetRamp;
    parameters[AKOscillatorParameterDetuningMultiplier] = &data->detuningMultiplierRamp;
}

void AKOscillatorDSP::setWavetable(const float* table, size_t length, int index) {
    data->waveform = std::vector<float>(table, table + length);
    reset();
}

void AKOscillatorDSP::init(int channelCount, double sampleRate) {
    AKSoundpipeDSPBase::init(channelCount, sampleRate);
    sp_ftbl_create(sp, &data->ftbl, data->waveform.size());
    std::copy(data->waveform.cbegin(), data->waveform.cend(), data->ftbl->tbl);
    sp_osc_create(&data->osc);
    sp_osc_init(sp, data->osc, data->ftbl, 0);
}

void AKOscillatorDSP::deinit() {
    AKSoundpipeDSPBase::deinit();
    sp_osc_destroy(&data->osc);
    sp_ftbl_destroy(&data->ftbl);
}

void AKOscillatorDSP::reset() {
    AKSoundpipeDSPBase::reset();
    if (!isInitialized) return;
    sp_osc_init(sp, data->osc, data->ftbl, 0);
}

void AKOscillatorDSP::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
        int frameOffset = int(frameIndex + bufferOffset);

        // do ramping every 8 samples
        if ((frameOffset & 0x7) == 0) {
            data->frequencyRamp.advanceTo(now + frameOffset);
            data->amplitudeRamp.advanceTo(now + frameOffset);
            data->detuningOffsetRamp.advanceTo(now + frameOffset);
            data->detuningMultiplierRamp.advanceTo(now + frameOffset);
        }

        data->osc->freq = data->frequencyRamp.getValue() * data->detuningMultiplierRamp.getValue() + data->detuningOffsetRamp.getValue();
        data->osc->amp = data->amplitudeRamp.getValue();

        float temp = 0;
        for (int channel = 0; channel < channelCount; ++channel) {
            float *out = (float *)outputBufferLists[0]->mBuffers[channel].mData + frameOffset;

            if (isStarted) {
                if (channel == 0) {
                    sp_osc_compute(sp, data->osc, nil, &temp);
                }
                *out = temp;
            } else {
                *out = 0.0;
            }
        }
    }
}
