//
//  TAVMovieDecoder.m
//  tomFFRTMP
//
//  Created by codew on 10/27/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "TAVMovieDecoder.h"
#import <Accelerate/Accelerate.h>
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/pixdesc.h"
#include "libavutil/avutil.h"


#import "TAV_Constants.h"

@interface TAVMovieDecoder ()
{
    AVFormatContext     *_formatCtx;
    AVFrame             *_videoFrame;
    AVFrame             *_audioFrame;
    
    AVCodecContext      *_videoCodecCtx;
    AVCodecContext      *_audioCodecCtx;
    AVCodecContext      *_subtitleCodecCtx;
    
    struct SwsContext   *_swsContext;
    AVPicture           _picture;
    
    void                *_swrBuffer;
    SwrContext          *_swrContext;

}

@property (nonatomic, assign) BOOL isNetwork;
@property (nonatomic, assign) BOOL pictureValid;

@property (nonatomic, strong) NSString * path;

@property (nonatomic, strong) NSArray *videoStreams;
@property (nonatomic, strong) NSArray *audioStreams;
@property (nonatomic, strong) NSArray *subtitleStreams;

@property (nonatomic, assign) NSInteger videoStream;
@property (nonatomic, assign) NSInteger audioStream;
@property (nonatomic, assign) NSInteger subtitleStream;

@property (nonatomic, assign) NSUInteger swrBufferSize;

@property (nonatomic, assign) NSUInteger artworkStream;


@end


static int interrupt_callback(void *ctx);

@implementation TAVMovieDecoder

- (BOOL)openFile:(NSString *)path
           error:(NSError **)perror
{
    
    NSAssert(path, @"nil path");
    NSAssert(!_formatCtx, @"already open");
    
    _isNetwork = [self isNetworkPath:path];
    
    static BOOL needNetworkInit = YES;
    if (needNetworkInit && _isNetwork) {
        
        needNetworkInit = NO;
        avformat_network_init();
    }
    
    _path = path;
    
    
    TAVMovieError errCode = [self  openInput:path];
            
    if (errCode != !TAVMovieErrorNone) {
        
        [self closeFile];
        
        NSLog(@"errCode : %d", errCode);
        
        return NO;
    }
    
    if (errCode == TAVMovieErrorNone) {
        
        
    }
    
    return YES;
}


- (BOOL)isNetworkPath:(NSString *)path
{
    NSRange r = [path rangeOfString:@":"];
    if (r.location == NSNotFound)
        return NO;
    NSString *scheme = [path substringToIndex:r.length];
    if ([scheme isEqualToString:@"file"])
        return NO;
    return YES;
}



#pragma mark - private
- (TAVMovieError)openInput:(NSString *) path
{
    AVFormatContext *formatCtx = NULL;
    
    if (_interruptCallback) {
        
        formatCtx = avformat_alloc_context();
        if (!formatCtx) {
            return TAVMovieErrorOpenFile;
        }
        
        AVIOInterruptCB cb = {interrupt_callback, (__bridge void *)(self)};
        formatCtx->interrupt_callback = cb;formatCtx->interrupt_callback = cb;
    }
    
    
    if (avformat_open_input(&formatCtx, [path cStringUsingEncoding: NSUTF8StringEncoding], NULL, NULL) < 0) {
        
        if (formatCtx) {
            avformat_free_context(formatCtx);
        }
        return TAVMovieErrorOpenFile;
    }
    
    if (avformat_find_stream_info(formatCtx, NULL) < 0) {
        
        avformat_close_input(&formatCtx);
        
        return TAVMovieErrorStreamInfoNotFound;
    }
    
    av_dump_format(formatCtx, 0, [path.lastPathComponent cStringUsingEncoding: NSUTF8StringEncoding], false);
    
    _formatCtx = formatCtx;
    
    return TAVMovieErrorNone;
}

- (BOOL) interruptDecoder
{
    if (_interruptCallback)
        return _interruptCallback();
    return NO;
}

- (NSMutableArray *)collectStreams:(AVFormatContext *)formatCtx codecType:(enum AVMediaType)codecType
{
    NSMutableArray * arrayM = [NSMutableArray array];
    for (int i = 0; i < formatCtx->nb_streams; ++i) {
        
        if (codecType == formatCtx->streams[i]->codec->codec_type) {
            
            [arrayM addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    return arrayM;
}

#pragma mark - open
/**
//////////////////////////////////////////////////////////////////////////////

open start

//////////////////////////////////////////////////////////////////////////////
*/

- (TAVMovieError)openVideoStream
{
    TAVMovieError errCode = TAVMovieErrorStreamNotFound;
    _videoStream = -1;
    _audioStream = -1;
    _videoStreams = [self collectStreams:_formatCtx codecType:AVMEDIA_TYPE_VIDEO];
    
    NSUInteger iStream;
    for (NSNumber *n in _videoStreams) {
        
        iStream = n.integerValue;
        
        if (0 == (_formatCtx->streams[iStream]->disposition & AV_DISPOSITION_ATTACHED_PIC)  ) {
            
            errCode = [self openVideoStream:iStream];
            if (errCode == TAVMovieErrorNone) {
                break;
            }
            
        }else{
            
            _artworkStream = iStream;
        }
                
    }
    
    
    return errCode;
}


- (TAVMovieError)openVideoStream:(NSInteger)videoStream
{
    
    AVCodecContext *codecCtx = _formatCtx->streams[videoStream]->codec;
    AVCodec *codec = avcodec_find_decoder(codecCtx->codec_id);
    
    if (!codec) {
        return TAVMovieErrorCodecNotFound;
    }
    
    if (avcodec_open2(codecCtx, codec, NULL) < 0) {
        
        return TAVMovieErrorOpenCodec;
    }
    _videoFrame = av_frame_alloc();
    
    
    if (!_videoFrame) {
        
        avcodec_close(codecCtx);
        return TAVMovieErrorAllocateFrame;
    }
    
    _videoStream = videoStream;
    _videoCodecCtx - codecCtx;
    
    AVStream *st = _formatCtx->streams[_videoStream];
    
    
    /**
     
     */.....
    
    
    
    
    return TAVMovieErrorNone;
}
/**
//////////////////////////////////////////////////////////////////////////////

open end

//////////////////////////////////////////////////////////////////////////////
*/





#pragma mark - close
/**
 //////////////////////////////////////////////////////////////////////////////
 
 closs
 
 //////////////////////////////////////////////////////////////////////////////
 */


- (void)closeFile
{
    [self closeAudioStream];
    [self closeVideoStream];
    [self closeSubtitleStream];
    
    _videoStreams = nil;
    _audioStreams = nil;
    _subtitleStreams = nil;
    
    if (_formatCtx) {
        
        _formatCtx->interrupt_callback.opaque = NULL;
        _formatCtx->interrupt_callback.callback = NULL;
        
        avformat_close_input(&_formatCtx);
        _formatCtx = NULL;
    }
}

- (void)closeVideoStream
{
    _videoStream = -1;
    
    [self closeScaler];
    
    if (_videoFrame) {
        
        av_free(_videoFrame);
        _videoFrame = NULL;
    }
    
    if (_videoCodecCtx) {
        
        avcodec_close(_videoCodecCtx);
        _videoCodecCtx = NULL;
    }
    
}
- (void)closeAudioStream
{
    _audioStream = -1;
    
    if (_swrBuffer) {
        
        free(_swrBuffer);
        _swrBuffer = NULL;
        _swrBufferSize = 0;
    }
    
    if (_swrContext) {
        
        swr_free(&_swrContext);
        _swsContext = NULL;
    }
    
    if (_audioFrame) {
        
        av_free(_audioFrame);
        _audioFrame = NULL;
    }
    
    
    if (_audioCodecCtx) {
        
        avcodec_close(_audioCodecCtx);
        _audioCodecCtx = NULL;
    }
    
}

- (void)closeSubtitleStream
{
    _subtitleStream = -1;
    
    if (_subtitleCodecCtx) {
        
        avcodec_close(_subtitleCodecCtx);
        _subtitleCodecCtx = NULL;
    }
    
}


- (void)closeScaler
{
    if (_swsContext) {
        
        sws_freeContext(_swsContext);
        _swsContext = NULL;
    }
    
    if (_pictureValid) {
        
        avpicture_free(&_picture);
        
        _pictureValid = NO;
    }
}


- (void) dealloc
{
//    LoggerStream(2, @"%@ dealloc", self);
    [self closeFile];
}

@end


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

static int interrupt_callback(void *ctx)
{
    if (!ctx)
        return 0;
    __unsafe_unretained TAVMovieDecoder *p = (__bridge TAVMovieDecoder *)ctx;
    const BOOL r = [p interruptDecoder];
    if (r) NSLog(@"DEBUG: INTERRUPT_CALLBACK!");//LoggerStream(1, @"DEBUG: INTERRUPT_CALLBACK!");
    return r;
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
