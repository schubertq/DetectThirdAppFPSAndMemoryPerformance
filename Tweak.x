#import "fps/YYFPSLabel.h"
#import "fps/YYWeakProxy.h"
#import "memory/QMemoryIncrease.h"
#import "utils/PublicDefine.h"

@interface HomeViewController 

- (id)view;

@end

@interface MGADView : UIView

@end

@interface MGVODPlayerViewController : UIViewController

- (void)traversalView:(UIView *)view;
- (void)hideAdView;
- (id)playerCenter;

@end

// 向阳而生
// MGTVMediaPlayerView
// VODPlayerView
// MGVODControlView
// MGADView
// HNVideoQueuePlayerLayerView
// MGADHarlfScreenControlView

/*
%hook MGADView

- (id)initWithFrame:(struct CGRect)arg1 fullScreen:(int)arg2 cornerADContainer:(id)arg3 {
	return nil;
}

%end


%hook MGVODPlayerViewController

- (void)viewWillAppear:(_Bool)arg1 {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAdView];
    });
}

%end
*/

%hook MGADView

- (id)initWithFrame:(struct CGRect)arg1 fullScreen:(int)arg2 cornerADContainer:(id)arg3 {
	//[self setHidden:YES];
	arg1 = CGRectZero;
	return %orig;
}

%end


%hook MGADHarlfScreenControlView

- (instancetype)init {
    return nil;
}

- (id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}

- (void)setAdRequest:(id)arg1 {
	
}

- (void)showAdvertiser:(id)arg1 {
	
}

%end

%hook HNVideoQueuePlayerLayerView

- (instancetype)init {
    return nil;
}

%end

%hook MGVODPlayerViewController

%new
- (void)traversalView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
    	if ([subview isKindOfClass:NSClassFromString(@"MGADView")]) {
	        subview.hidden = YES;
	        [subview removeFromSuperview];
	        break;
	    }

        [self traversalView:subview];
    }
}

- (void)viewWillAppear:(_Bool)arg1 {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self traversalView:self.view];
		[[self playerCenter] cancel];

		//[self hideAdView];
		
		//[[self playerCenter] performSelector:@selector(setHalfScreenAdDetailViewHidden:) withObject:@(YES)];
	});
}

- (void)showGreditsGoods:(id)arg1 actionType:(id)arg2 {
	
}

- (void)showVideoPreViewonData:(id)arg1 atDataType:(long long)arg2 {
	
}

- (void)presentControllerWithUrlStr:(id)arg1 withType:(long long)arg2 info:(id)arg3 adInfoModel:(id)arg4 {
	
}

- (void)playerControlEvent:(unsigned long long)arg1 withInfo:(id)arg2 params:(id)arg3 adInfoModel:(id)arg4 {
	
}

%end

%hook TemplateLayerTipsEntryView

- (id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}

%end

/*
%hook HomeViewController
- (void)viewWillAppear:(_Bool)arg1 {
	%orig;
*/

%hook MGBannerADView

- (id)initWithDelegate:(id)arg1 {
	return nil;
}

%end

%hook AppDelegate

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
        [fpsLabel sizeToFit];
        // 当前顶层窗口
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        // 添加到窗口
        [window addSubview:fpsLabel];

        QMemoryIncrease *memory = [QMemoryIncrease new];
        [memory start];
    });

	return %orig;
}

%end