//
//  AVSpeechSynthesizer+Additions.h
//  AppTools
//
//  Created by 韩琼 on 16/4/20.
//  Copyright © 2016年 Amaze. All rights reserved.
//

#include <AVFoundation/AVFoundation.h>

@interface AVSpeechSynthesizer(Additions)

+ (instancetype)sharedInstance;

+ (void)stop;

+ (void)pause;

+ (void)resume;

// rate(0.5)[0 ~ 1], pitch(0.3)[0 ~ 1]
+ (void)speak:(NSString*)text lang:(NSString*)lang rate:(CGFloat)rate pitch:(CGFloat)pitch;

@end
