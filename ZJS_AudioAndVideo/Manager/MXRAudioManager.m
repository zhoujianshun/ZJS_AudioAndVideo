//
//  MXRAudioManager.m
//  ZJS_AudioAndVideo
//
//  Created by 周建顺 on 15/12/31.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "MXRAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MXRAudioManager()<AVAudioPlayerDelegate>

@property (nonatomic,copy) StopCallBack stopCallback;
@property (nonatomic,copy) NSString *filePath;
@property (assign, nonatomic) NSTimeInterval            startTime;
@property (assign, nonatomic) NSTimeInterval            endTime;

@property (nonatomic) NSTimer *timer;


@end

@implementation MXRAudioManager{
    AVAudioPlayer *audioPlayer;
}

+(id)shareAudioPlayManager{
    static dispatch_once_t onceToken;
    static MXRAudioManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MXRAudioManager alloc] init];
    });
    
    return instance;
}

-(instancetype)init{
    self = [super init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    
    return self;
}

-(void)AVAudioSessionInterruptionNotification:(NSNotification *)notification{
    NSLog(@"AVAudioSessionInterruptionNotification");
}

-(void)playAudio:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end stopCallBack:(StopCallBack)callBack{
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        //DLOG(@"文件不存在");
        [self audioStopedAtError];
        return;
    }
    
    if (start > end && end != -1){
        //[MXRConstant showAlert:@"当前音频配置错误" andShowTime:2.0f];
        [self audioStopedAtError];
        return;
    }
    
    //设置后台播放模式
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [audioSession setActive:YES error:nil];

    self.filePath = filePath;
    self.startTime      = start;
    self.endTime        = end;
    self.stopCallback   = callBack;
    

    if (audioPlayer) {
        [self stopPlay];
    }
    

    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSError *error=nil;
    //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    //设置播放器属性
    audioPlayer.numberOfLoops=0;//设置为0不循环
    audioPlayer.delegate=self;

    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
    }
    audioPlayer.currentTime = self.startTime;

    [self startTimer];
    
    [audioPlayer prepareToPlay];//加载音频文件到缓存
    [audioPlayer play];
}



-(void)playCurrentAudio{
    if (audioPlayer) {
        
        if ([audioPlayer isPlaying]) {
            
        }else{
            audioPlayer.currentTime = self.startTime;
            [self startTimer];
            [audioPlayer play];
        }
        
    }
}

-(void)stopPlay{
    [self stopPlayIsSuccess:NO];
}



-(BOOL)isPlaying{
    if (audioPlayer) {
        return audioPlayer.isPlaying;
    }
    
    return NO;
}

#pragma mark 私有方法

-(void)startTimer{
    if (self.endTime != -1) {
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:(self.endTime - self.startTime) target:self selector:@selector(stopAtEndTime) userInfo:nil repeats:NO];
    }
}

// 计时器到了，停止播放
-(void)stopAtEndTime{
    [self stopPlayIsSuccess:YES];
}

// 出错时的回调
-(void)audioStopedAtError{

    if (self.stopCallback) {
        self.stopCallback(self,NO,nil);
    }
}

-(void)stopPlayIsSuccess:(BOOL)isSuccess{
    if (audioPlayer) {
        if ([audioPlayer isPlaying]) {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            
            [audioPlayer stop];
            audioPlayer.currentTime = self.startTime;
            
            if (self.stopCallback) {
                self.stopCallback(self,isSuccess,nil);
            }
        }
        
    }
}

-(AVAudioPlayer *)createAudioPlayer:(NSString *)filePath{
    
    self.filePath = filePath;
    
    NSString *urlStr=[[NSBundle mainBundle]pathForResource:filePath ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    NSError *error=nil;
    //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
     AVAudioPlayer * player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    //设置播放器属性
    player.numberOfLoops=0;//设置为0不循环
    player.delegate=self;
    [player prepareToPlay];//加载音频文件到缓存
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        return nil;
    }
    //设置后台播放模式
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [audioSession setActive:YES error:nil];
    
    return player;
}


#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.stopCallback) {
        self.stopCallback(self,flag,nil);
    }
}


@end
