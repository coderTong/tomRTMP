//
//  TAV_Constants.h
//  tomFFRTMP
//
//  Created by codew on 10/27/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#ifndef TAV_Constants_h
#define TAV_Constants_h

typedef enum {
    
    TAVMovieErrorNone,
    TAVMovieErrorOpenFile,
    TAVMovieErrorStreamInfoNotFound,
    TAVMovieErrorStreamNotFound,
    TAVMovieErrorCodecNotFound,
    TAVMovieErrorOpenCodec,
    TAVMovieErrorAllocateFrame,
    TAVMovieErroSetupScaler,
    TAVMovieErroReSampler,
    TAVMovieErroUnsupported,
    
} TAVMovieError;

typedef enum {
    
    TAVMovieFrameTypeAudio,
    TAVMovieFrameTypeVideo,
    TAVMovieFrameTypeArtwork,
    TAVMovieFrameTypeSubtitle,
    
} TAVMovieFrameType;

typedef enum {
        
    TAVVideoFrameFormatRGB,
    TAVVideoFrameFormatYUV,
    
} TAVVideoFrameFormat;

#endif /* TAV_Constants_h */
