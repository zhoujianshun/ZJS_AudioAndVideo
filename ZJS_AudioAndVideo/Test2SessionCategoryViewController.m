//
//  Test2SessionCategoryViewController.m
//  ZJS_AudioAndVideo
//
//  Created by 周建顺 on 2016/9/23.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "Test2SessionCategoryViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface Test2SessionCategoryViewController()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ambientButton;
@property (weak, nonatomic) IBOutlet UIButton *soloAmbientButton;
@property (weak, nonatomic) IBOutlet UIButton *playbackButton;

@property (nonatomic,weak) UIButton *currentPlayButton;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation Test2SessionCategoryViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (IBAction)ambientButtonTapped:(UIButton*)sender {
     AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [audioSession setActive:NO error:nil];
    if (self.currentPlayButton == self.ambientButton) {
        
    }else{
        [self stopCurrentAudio];
        
    }
    
    if (sender.isSelected) {
        [self stopCurrentAudio];
    }else{
        self.currentPlayButton = self.ambientButton;
       
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
        //    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [self playAudio];
    }

}
- (IBAction)soloAmbientButtonTapped:(UIButton*)sender {
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [audioSession setActive:NO error:nil];
    if (self.currentPlayButton == self.soloAmbientButton) {
        
    }else{
        [self stopCurrentAudio];
        
    }
    
    if (sender.isSelected) {
        [self stopCurrentAudio];
    }else{
        self.currentPlayButton = self.soloAmbientButton;
    
        [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        //    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        
        [self playAudio];
    }
}
- (IBAction)playbackButtonTapped:(UIButton*)sender {
    if (self.currentPlayButton == self.playbackButton) {
        
    }else{
        [self stopCurrentAudio];
        
    }
    
    if ( self.playbackButton.isSelected) {
        [self stopCurrentAudio];
    }else{
        self.currentPlayButton = self.playbackButton;
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self playAudio];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopCurrentAudio];
}

-(void)playAudio{
    
     self.currentPlayButton.selected = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp3"];
    
    NSError *error;
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:&error];
    //设置播放器属性
    self.audioPlayer.numberOfLoops=0;//设置为0不循环
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}

-(void)pauseAudio{
    [self.audioPlayer pause];
}

-(void)continuePlay{
    [self.audioPlayer play];
}

-(void)stopCurrentAudio{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    self.currentPlayButton.selected = NO;
    [self.audioPlayer stop];
    self.currentPlayButton = nil;
}


// 控制中心，耳机线控
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
   // [super remoteControlReceivedWithEvent:event];

    NSLog(@"%i,%i",event.type,event.subtype);
    if(event.type==UIEventTypeRemoteControl){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                if (self.currentPlayButton == self.playbackButton) {
                    
                    if (self.audioPlayer.isPlaying) {
                        [self pauseAudio];
                    }else{
                        [self continuePlay];
                    }
                    
                }else{
                    [self playbackButtonTapped:self.playbackButton];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
            {
                [self pauseAudio];
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (self.currentPlayButton == self.playbackButton) {
                    
                    if (self.audioPlayer.isPlaying) {
                        [self pauseAudio];
                    }else{
                        [self continuePlay];
                    }
                    
                }else{
                    [self playbackButtonTapped:self.playbackButton];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next...");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Previous...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"Begin seek forward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"End seek forward...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                NSLog(@"Begin seek backward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                NSLog(@"End seek backward...");
                break;
            default:
                break;
        }
    }
}

@end
