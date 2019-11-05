//
//  TAVAudioManager.h
//  tomFFRTMP
//
//  Created by codew on 10/30/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAVAudioManagerProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface TAVAudioManager : NSObject <TAVAudioManagerProtocol>

+ (id<TAVAudioManagerProtocol>)audioManager;

@end

NS_ASSUME_NONNULL_END
