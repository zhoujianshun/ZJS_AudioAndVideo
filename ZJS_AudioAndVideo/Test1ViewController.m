//
//  Test1ViewController.m
//  ZJS_AudioAndVideo
//
//  Created by 周建顺 on 15/12/31.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "Test1ViewController.h"
#import "MXRAudioManager.h"

@interface Test1ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapped:(id)sender {
    
    if ([[MXRAudioManager shareAudioPlayManager] isPlaying]) {
        [[MXRAudioManager shareAudioPlayManager] stopPlay];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp3"];
        [[MXRAudioManager shareAudioPlayManager] playAudio:path startAt:0 endOf:-1 stopCallBack:^(MXRAudioManager *manager, BOOL isSuccess, NSDictionary *userInfo) {
            NSLog(@"tapped isSuccess:%@",isSuccess?@"YES":@"NO");
        }];
    }
    
}
- (IBAction)playAtTime:(id)sender {
    
    if ([[MXRAudioManager shareAudioPlayManager] isPlaying]) {
        
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp3"];
        [[MXRAudioManager shareAudioPlayManager] playAudio:path startAt:10 endOf:20 stopCallBack:^(MXRAudioManager *manager, BOOL isSuccess, NSDictionary *userInfo) {
                NSLog(@"playAtTime isSuccess:%@",isSuccess?@"YES":@"NO");
        }];
    }
    
}
- (IBAction)playCurrent:(id)sender {
    
    
    if ([[MXRAudioManager shareAudioPlayManager] isPlaying]) {
        
    }else{

        [[MXRAudioManager shareAudioPlayManager] playCurrentAudio];
    }
}

- (IBAction)play2:(id)sender {
    if ([[MXRAudioManager shareAudioPlayManager] isPlaying]) {
        [[MXRAudioManager shareAudioPlayManager] stopPlay];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CognitiveCard" ofType:@"mp3"];
        [[MXRAudioManager shareAudioPlayManager] playAudio:path startAt:0 endOf:-1 stopCallBack:^(MXRAudioManager *manager, BOOL isSuccess, NSDictionary *userInfo) {
            NSLog(@"tapped isSuccess:%@",isSuccess?@"YES":@"NO");
        }];
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
