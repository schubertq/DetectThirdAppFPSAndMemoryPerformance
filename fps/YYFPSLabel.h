//
//  YYFPSLabel.h
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Show Screen FPS...
 
 The maximum fps in OSX/iOS Simulator is 60.00.
 The maximum fps on iPhone is 59.97.
 The maxmium fps on iPad is 60.0.
 */


// 使用方式，在ViewController的viewDidLoad加入以下代码
//- (void) viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // 测试 fps
//    YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
//    [fpsLabel sizeToFit];
//    //    // 当前顶层窗口
//    //    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    //    // 添加到窗口
//    //    [window addSubview:_fpsLabel];
//    
//    [self.view addSubview:fpsLabel];
//}

@interface YYFPSLabel : UILabel

@end

