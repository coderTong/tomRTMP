//
//  TAVMovieDecoder+StaticValue.m
//  tomFFRTMP
//
//  Created by codew on 10/29/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "TAVMovieDecoder+StaticValue.h"




@implementation TAVMovieDecoder (StaticValue)

- (void)avStreamFPSTimeBaseWith:(AVStream *)st
                           pFPS:(CGFloat *)pFPS
                      pTimeBase:(CGFloat *)pTimeBase
                defaultTimeBase:(CGFloat)defaultTimeBase
//static void avStreamFPSTimeBase(AVStream *st, CGFloat defaultTimeBase, CGFloat *pFPS, CGFloat *pTimeBase)
{
    CGFloat fps, timebase;
    
    if (st->time_base.den && st->time_base.num) {
        
        timebase = av_q2d(st->time_base);
    }else if (st->codec->time_base.den && st->codec->time_base.num){
        timebase = av_q2d(st->codec->time_base);
    }else{
        timebase = defaultTimeBase;
    }
    
    
    if (st->codec->ticks_per_frame != 1) {
        
        NSLog(@"WARNING: st.codec.ticks_per_frame=%d", st->codec->ticks_per_frame);
    }
    
    if (st->avg_frame_rate.den && st->avg_frame_rate.num) {
        
        fps = av_q2d(st->avg_frame_rate);
    }else if (st->r_frame_rate.den && st->r_frame_rate.num){
        
        fps = av_q2d(st->r_frame_rate);
    }else{
        
        fps = 1.0/timebase;
    }
    
    
    if (pFPS) {
        *pFPS  = fps;
    }
    
    if (pTimeBase) {
        *pTimeBase = timebase;
    }
    
}

@end
