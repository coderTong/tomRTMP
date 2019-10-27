//
//  TAVMovieDecoder.h
//  tomFFRTMP
//
//  Created by codew on 10/27/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^TAVMovieDecoderInterruptCallback)(void);


@interface TAVMovieDecoder : NSObject

@property (nonatomic, copy) TAVMovieDecoderInterruptCallback interruptCallback;

@property (nonatomic, assign, readonly) BOOL isNetwork;


- (BOOL)openFile:(NSString *)path
           error:(NSError **)perror;
@end

NS_ASSUME_NONNULL_END
