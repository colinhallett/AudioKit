// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#include "AKFMOscillatorDSP.hpp"
#include "AKLinearParameterRamp.hpp"
#include <vector>

extern "C" AKDSPRef createFMOscillatorDSP() {
    return new AKFMOscillatorDSP();
}

struct AKFMOscillatorDSP::InternalData {
    sp_fosc *fosc;
    sp_ftbl *ftbl;
    std::vector<float> waveform;
    AKLinearParameterRamp baseFrequencyRamp;
    AKLinearParameterRamp carrierMultiplierRamp;
    AKLinearParameterRamp modulatingMultiplierRamp;
    AKLinearParameterRamp modulationIndexRamp;
    AKLinearParameterRamp amplitudeRamp;
};

AKFMOscillatorDSP::AKFMOscillatorDSP() : data(new InternalData) {
    parameters[AKFMOscillatorParameterBaseFrequency] = &data->baseFrequencyRamp;
    parameters[AKFMOscillatorParameterCarrierMultiplier] = &data->carrierMultiplierRamp;
    parameters[AKFMOscillatorParameterModulatingMultiplier] = &data->modulatingMultiplierRamp;
    parameters[AKFMOscillatorParameterModulationIndex] = &data->modulationIndexRamp;
    parameters[AKFMOscillatorParameterAmplitude] = &data->amplitudeRamp;
}

void AKFMOscillatorDSP::setWavetable(const float* table, size_t length, int index) {
    data->waveform = std::vector<float>(table, table + length);
    reset();
}

void AKFMOscillatorDSP::init(int channelCount, double sampleRate) {
    AKSoundpipeDSPBase::init(channelCount, sampleRate);
    sp_ftbl_create(sp, &data->ftbl, data->waveform.size());
    std::copy(data->waveform.cbegin(), data->waveform.cend(), data->ftbl->tbl);
    sp_fosc_create(&data->fosc);
    sp_fosc_init(sp, data->fosc, data->ftbl);
}

void AKFMOscillatorDSP::deinit() {
    AKSoundpipeDSPBase::deinit();
    sp_fosc_destroy(&data->fosc);
    sp_ftbl_destroy(&data->ftbl);
}

void AKFMOscillatorDSP::reset() {
    AKSoundpipeDSPBase::reset();
    if (!isInitialized) return;
    sp_fosc_init(sp, data->fosc, data->ftbl);
}

void AKFMOscillatorDSP::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
        int frameOffset = int(frameIndex + bufferOffset);

        // do ramping every 8 samples
        if ((frameOffset & 0x7) == 0) {
            data->baseFrequencyRamp.advanceTo(now + frameOffset);
            data->carrierMultiplierRamp.advanceTo(now + frameOffset);
            data->modulatingMultiplierRamp.advanceTo(now + frameOffset);
            data->modulationIndexRamp.advanceTo(now + frameOffset);
            data->amplitudeRamp.advanceTo(now + frameOffset);
        }

        data->fosc->freq = data->baseFrequencyRamp.getValue();
        data->fosc->car = data->carrierMultiplierRamp.getValue();
        data->fosc->mod = data->modulatingMultiplierRamp.getValue();
        data->fosc->indx = data->modulationIndexRamp.getValue();
        data->fosc->amp = data->amplitudeRamp.getValue();

        float temp = 0;
        for (int channel = 0; channel < channelCount; ++channel) {
            float *out = (float *)outputBufferLists[0]->mBuffers[channel].mData + frameOffset;

            if (isStarted) {
                if (channel == 0) {
                    sp_fosc_compute(sp, data->fosc, nil, &temp);
                }
                *out = temp;
            } else {
                *out = 0.0;
            }
        }
    }
}
