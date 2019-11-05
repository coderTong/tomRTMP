//
//  TAVAudioManagerProtocol.h
//  tomFFRTMP
//
//  Created by codew on 10/30/19.
//  Copyright © 2019 itmoy. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

typedef void (^TAVAudioManagerOutputBlock)(float *data, UInt32 numFrames, UInt32 numChannels);

@protocol TAVAudioManagerProtocol <NSObject>

/** 声道数 */
@property (nonatomic, assign, readonly) UInt32 numOutputChannels;
/** 采样率 */
@property (nonatomic, assign, readonly) Float64 samplingRate;
/** 采样精度 */
@property (nonatomic, assign, readonly) UInt32 numBytesPerSample;

@property (nonatomic, assign, readonly) Float32 outputVolume;
@property (nonatomic, assign, readonly) BOOL playing;


@property (nonatomic, strong) NSString *audioRoute;
@property (nonatomic, copy) TAVAudioManagerOutputBlock outputBlock;

- (BOOL)activateAudioSession;
- (void)deactivateAudioSession;
- (BOOL)play;
- (void)pause;

@end
