//
//  TAVMovieDecoder.h
//  tomFFRTMP
//
//  Created by codew on 10/27/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/pixdesc.h"
#include "libavutil/avutil.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^TAVMovieDecoderInterruptCallback)(void);


@interface TAVMovieDecoder : NSObject

@property (nonatomic, copy) TAVMovieDecoderInterruptCallback interruptCallback;

@property (nonatomic, assign, readonly) BOOL isNetwork;


@property (readonly, assign, nonatomic) CGFloat fps;
@property (nonatomic, assign) NSUInteger frameWidth;
@property (nonatomic, assign) NSUInteger frameHeight;

- (BOOL)openFile:(NSString *)path
           error:(NSError **)perror;


@end

NS_ASSUME_NONNULL_END
