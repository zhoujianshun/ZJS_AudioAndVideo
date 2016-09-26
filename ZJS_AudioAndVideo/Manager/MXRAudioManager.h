//
//  MXRAudioManager.h
//  ZJS_AudioAndVideo
//
//  Created by 周建顺 on 15/12/31.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MXRAudioManager;

typedef void(^StopCallBack)(MXRAudioManager* manager,BOOL isSuccess,NSDictionary *userInfo);

@interface MXRAudioManager : NSObject

@property (nonatomic,readonly,getter=isPlaying) BOOL playing;


+ (id)shareAudioPlayManager;
- (void)playAudio:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end stopCallBack:(StopCallBack)callBack;

- (void)playCurrentAudio;
- (void)stopPlay;


@end
