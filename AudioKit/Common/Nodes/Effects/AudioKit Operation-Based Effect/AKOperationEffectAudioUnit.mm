// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#import "AKOperationEffectAudioUnit.h"
#import "AKOperationEffectDSPKernel.hpp"
#import "AKCustomUgenFunction.h"

#import "BufferedAudioBus.hpp"

#import <AudioKit/AudioKit-Swift.h>

@implementation AKOperationEffectAudioUnit {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    AKOperationEffectDSPKernel _kernel;
    BufferedInputBus _inputBus;
}
@synthesize parameterTree = _parameterTree;

- (void)setSporth:(NSString *)sporth {
    _kernel.setSporth((char *)[sporth UTF8String], (int)sporth.length + 1);
}

- (NSArray *)parameters {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:14];
    for (int i = 0; i < 14; i++) {
        [temp setObject:[NSNumber numberWithFloat:_kernel.parameters[i]] atIndexedSubscript:i];
    }
    return [NSArray arrayWithArray:temp];
}

- (void)setParameters:(NSArray *)parameters {
    float temporaryParameters[14] = {0};
    for (int i = 0; i < parameters.count; i++) {
        temporaryParameters[i] = [parameters[i] floatValue];
    }
    _kernel.setParameters(temporaryParameters);
}

- (void)addCustomUgen:(AKCustomUgen *)ugen {
    char *cName = (char *)[ugen.name UTF8String];
    _kernel.addCustomUgen({cName, &akCustomUgenFunction, (__bridge void *)ugen});
}

- (void)start {
    _kernel.start();
}

- (void)stop {
    _kernel.stop();
}

- (BOOL)isPlaying {
    return _kernel.started;
}

- (void)createParameters {
    standardSetup(OperationEffect)
    _parameterTree = [AUParameterTree treeWithChildren:@[]];
    parameterTreeBlock(OperationEffect)
}

AUAudioUnitOverrides(OperationEffect)
@end
