//
//  TAVAudioManager.m
//  tomFFRTMP
//
//  Created by codew on 10/30/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "TAVAudioManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>

#define MAX_FRAME_SIZE 4096
#define MAX_CHAN       2

#define MAX_SAMPLE_DUMPED 5

@interface TAVAudioManager ()

/** 声道数 */
@property (nonatomic, assign) UInt32 numOutputChannels;

/** 采样率 */
@property (nonatomic, assign) Float64 samplingRate;

/** 采样精度 */
@property (nonatomic, assign) UInt32 numBytesPerSample;

@property (nonatomic, assign) Float32 outputVolume;

@property (nonatomic, assign) BOOL playing;


//@property (readwrite, strong) NSString *audioRoute;

//@property (readwrite, copy) TAVAudioManagerOutputBlock outputBlock;
@end


@implementation TAVAudioManager

// TODO:
@synthesize outputBlock;
@synthesize audioRoute;

- (BOOL)activateAudioSession {

    return YES;
}

- (void)deactivateAudioSession {

}

- (void)pause {
    
}

- (BOOL)play {
    
    return YES;
}


+ (id<TAVAudioManagerProtocol>)audioManager
{
    static TAVAudioManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TAVAudioManager alloc] init];
        
    });
    
    return instance;
}


//@synthesize audioRoute;
//
//@synthesize outputBlock;

@end
