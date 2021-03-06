// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#import "AKOscillatorBankAudioUnit.h"
#import "AKOscillatorBankDSPKernel.hpp"

#import "BufferedAudioBus.hpp"

#import <AudioKit/AudioKit-Swift.h>

@implementation AKOscillatorBankAudioUnit {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    AKOscillatorBankDSPKernel _kernel;
    BufferedOutputBus _outputBusBuffer;
}
@synthesize parameterTree = _parameterTree;

- (void)setupWaveform:(int)size {
    _kernel.setupWaveform((uint32_t)size);
}
- (void)setWaveformValue:(float)value atIndex:(UInt32)index; {
    _kernel.setWaveformValue(index, value);
}

- (void)reset {
    _kernel.reset();
}

- (void)createParameters {
    
    standardGeneratorSetup(OscillatorBank)
    
    [self setKernelPtr:&_kernel];
    
    // Create the parameter tree.
    _parameterTree = [AUParameterTree treeWithChildren:[self standardParameters]];
    
    parameterTreeBlock(OscillatorBank)
}

AUAudioUnitGeneratorOverrides(OscillatorBank)


@end
