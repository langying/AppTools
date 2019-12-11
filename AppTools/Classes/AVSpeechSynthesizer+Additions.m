//
//  AVSpeechSynthesizer+Additions.m
//  AppTools
//
//  Created by 韩琼 on 16/4/20.
//  Copyright © 2016年 Amaze. All rights reserved.
//

#import "AVSpeechSynthesizer+Additions.h"

@implementation AVSpeechSynthesizer(Additions)

float slide(float rate, float min, float max) {
    return min + (max - min) * fmaxf(0, fminf(rate, 1));
}

+ (instancetype)sharedInstance {
    static id instance = nil;
    if (instance == nil) {
        instance = [AVSpeechSynthesizer.alloc init];
    }
    return instance;
}

+ (void)stop {
    [[AVSpeechSynthesizer sharedInstance] stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

+ (void)pause {
    [[AVSpeechSynthesizer sharedInstance] pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

+ (void)resume {
    if ([[AVSpeechSynthesizer sharedInstance] isPaused]) {
        [[AVSpeechSynthesizer sharedInstance] continueSpeaking];
    }
}

/**
 * 中文: zh-CN, zh-TW
 * 英文: en-GB, en-US
 * rate: [0 ~ 1] 对应 [min ~ max] 默认 [default]
 * pitch:[0 ~ 1] 对应 [0.5 ~ 1.0] 默认 [1.0]
 */
+ (void)speak:(NSString*)text lang:(NSString*)lang rate:(CGFloat)rate pitch:(CGFloat)pitch {
    AVSpeechUtterance* utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.rate               = slide(rate, AVSpeechUtteranceMinimumSpeechRate, AVSpeechUtteranceMaximumSpeechRate);
    utterance.voice              = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
    utterance.pitchMultiplier    = slide(pitch, 0.5, 2.0);
    utterance.preUtteranceDelay  = 0;
    utterance.postUtteranceDelay = 0;
    [[AVSpeechSynthesizer sharedInstance] speakUtterance:utterance];
}

@end
