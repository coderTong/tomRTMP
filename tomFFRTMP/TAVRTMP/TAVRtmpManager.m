//
//  TAVRtmpManager.m
//  tomFFRTMP
//
//  Created by codew on 10/27/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "TAVRtmpManager.h"
#import "TAVMovieDecoder.h"

#define WTARTWEAKSELF(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface TAVRtmpManager ()

@property (nonatomic, strong) NSString * videoPath;
@property (nonatomic, strong) UIView * renderView;

@property (nonatomic, strong) TAVMovieDecoder * movieDecoder;

@property (nonatomic, assign) BOOL interrupted;
@end


@implementation TAVRtmpManager

- (instancetype)initWithRenderView:(UIView *)renderView videoPath:(NSString *)videoPath
{
    self = [super init];
    
    self.renderView = renderView;
    self.videoPath = videoPath;
    
    _movieDecoder = [[TAVMovieDecoder alloc] init];
    WTARTWEAKSELF(weakSelf);
    _movieDecoder.interruptCallback = ^BOOL{
        
        return [weakSelf interruptDecoder];
    };
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSError *error = nil;
        [weakSelf.movieDecoder openFile:videoPath error:&error];
                    
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [weakSelf setMovieDecoder:weakSelf.movieDecoder withError:error];
        });
    });
    
    
    return self;
}

- (BOOL)interruptDecoder
{
    return _interrupted;
}

#pragma mark - private

- (void) setMovieDecoder: (TAVMovieDecoder *) decoder
               withError: (NSError *) error
{
//    LoggerStream(2, @"setMovieDecoder");
//            
//    if (!error && decoder) {
//        
//        _decoder        = decoder;
//        _dispatchQueue  = dispatch_queue_create("KxMovie", DISPATCH_QUEUE_SERIAL);
//        _videoFrames    = [NSMutableArray array];
//        _audioFrames    = [NSMutableArray array];
//        
//        if (_decoder.subtitleStreamsCount) {
//            _subtitles = [NSMutableArray array];
//        }
//    
//        if (_decoder.isNetwork) {
//            
//            _minBufferedDuration = NETWORK_MIN_BUFFERED_DURATION;
//            _maxBufferedDuration = NETWORK_MAX_BUFFERED_DURATION;
//            
//        } else {
//            
//            _minBufferedDuration = LOCAL_MIN_BUFFERED_DURATION;
//            _maxBufferedDuration = LOCAL_MAX_BUFFERED_DURATION;
//        }
//        
//        if (!_decoder.validVideo)
//            _minBufferedDuration *= 10.0; // increase for audio
//                
//        // allow to tweak some parameters at runtime
//        if (_parameters.count) {
//            
//            id val;
//            
//            val = [_parameters valueForKey: KxMovieParameterMinBufferedDuration];
//            if ([val isKindOfClass:[NSNumber class]])
//                _minBufferedDuration = [val floatValue];
//            
//            val = [_parameters valueForKey: KxMovieParameterMaxBufferedDuration];
//            if ([val isKindOfClass:[NSNumber class]])
//                _maxBufferedDuration = [val floatValue];
//            
//            val = [_parameters valueForKey: KxMovieParameterDisableDeinterlacing];
//            if ([val isKindOfClass:[NSNumber class]])
//                _decoder.disableDeinterlacing = [val boolValue];
//            
//            if (_maxBufferedDuration < _minBufferedDuration)
//                _maxBufferedDuration = _minBufferedDuration * 2;
//        }
//        
//        LoggerStream(2, @"buffered limit: %.1f - %.1f", _minBufferedDuration, _maxBufferedDuration);
//        
//        if (self.isViewLoaded) {
//            
//            [self setupPresentView];
//            
//            _progressLabel.hidden   = NO;
//            _progressSlider.hidden  = NO;
//            _leftLabel.hidden       = NO;
//            _infoButton.hidden      = NO;
//            
//            if (_activityIndicatorView.isAnimating) {
//                
//                [_activityIndicatorView stopAnimating];
//                // if (self.view.window)
//                [self restorePlay];
//            }
//        }
//        
//    } else {
//        
//         if (self.isViewLoaded && self.view.window) {
//        
//             [_activityIndicatorView stopAnimating];
//             if (!_interrupted)
//                 [self handleDecoderMovieError: error];
//         }
//    }
}
@end
