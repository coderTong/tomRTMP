//
//  TAVMovieDecoder+StaticValue.h
//  tomFFRTMP
//
//  Created by codew on 10/29/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "TAVMovieDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAVMovieDecoder (StaticValue)

- (void)avStreamFPSTimeBaseWith:(AVStream *)st
                           pFPS:(CGFloat *)pFPS
                      pTimeBase:(CGFloat *)pTimeBase
                defaultTimeBase:(CGFloat)defaultTimeBase;

@end

NS_ASSUME_NONNULL_END
