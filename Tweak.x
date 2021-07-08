#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NSMutableArray *timers = nil;

@interface UIViewController (Category)
- (WKWebView *)__wkWebView;
@end

@implementation UIViewController (Category)
- (WKWebView *)__wkWebView {
	UIView *containerView = self.view.subviews.firstObject;

	for (UIView *lookingView in containerView.subviews) {
		if ([lookingView isKindOfClass:[WKWebView class]]) {
			return (WKWebView *)lookingView;
        }
	}

	return nil;
}
@end

@interface _TtC9KakaoTalk29SharpTabWebPageViewController : UIViewController
- (void)startTimer;
- (void)disablePageScrolling;
- (void)refersh;
- (void)clickMarker;
@end

@interface _TtC9KakaoTalk21KoinWebViewController : UIViewController
- (void)startTimer;
- (void)checkmate;
- (void)webView:(id)v1 runJavaScriptAlertPanelWithMessage:(id)v2 initiatedByFrame:(id)v3 completionHandler:(void (^)(void))v4;
- (void)webView:(id)v1 runJavaScriptConfirmPanelWithMessage:(id)v2 initiatedByFrame:(id)v3 completionHandler:(void (^)(BOOL))v4;
@end

%hook UIViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent 
                     animated:(BOOL)flag 
                   completion:(void (^)(void))completion {
	[UIView performWithoutAnimation:^(){
		%orig(viewControllerToPresent, NO, completion);
	}];
}
%end

%hook _TtC9KakaoTalk29SharpTabWebPageViewController
- (void)viewDidLoad {
	%orig();

 	[self startTimer];
	[self disablePageScrolling];
}

%new
- (void)startTimer {
	if (timers == nil) {
		timers = [@[] mutableCopy];
	}

	__weak typeof(self) weakSelf = self;
	NSTimer *refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.7 repeats:YES block:^(NSTimer * _Nonnull timer) {
		[weakSelf refersh];
    }];

	NSTimer *clickMarkerTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
		[weakSelf clickMarker];
    }];

	[timers addObject:refreshTimer];
	[timers addObject:clickMarkerTimer];
}

%new
- (void)disablePageScrolling {
	for (UIScrollView *view in self.parentViewController.view.subviews) {
		if ([view isKindOfClass:[UIScrollView class]]) {
			view.scrollEnabled = NO;
		}
	}
}

%new
- (void)refersh {
	NSString *jsCode = @"document.getElementsByClassName('btn_refresh')[0].click()";
	[[self __wkWebView] evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

%new
- (void)clickMarker {
	NSString *jsCode = @"\
	markers = document.getElementsByClassName('marker');\
	for (let i = 0; i < markers.length; i++) {\
		marker = markers[i];\
		has_icons_1 = marker.getElementsByClassName('icon icon-comm-pin_1to3');\
		has_icons_2 = marker.getElementsByClassName('icon icon-comm-pin_4to6');\
		if (has_icons_1.length > 0) {\
			has_icons_1[0].click();\
		} else if (has_icons_2.length > 0) {\
			has_icons_2[0].click();\
		}\
	}\
	";
	[[self __wkWebView] evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

%end

%hook _TtC9KakaoTalk21KoinWebViewController
- (void)viewDidLoad {
	%orig();
	[self startTimer];
}

%new
- (void)startTimer {
	if (timers == nil) {
		timers = [@[] mutableCopy];
	}

	__weak typeof(self) weakSelf = self;
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
		[weakSelf checkmate];
    }];

	[timers addObject:timer];
}

%new
- (void)checkmate {
	NSLog(@"checkmate");
	NSString *jsCode = @"\
	buttons = document.getElementsByTagName('button');\
	for (let i = 0; i < buttons.length; i++) {\
		button = buttons[i];\
		if ((button.textContent == '당일예약') && (button.className == 'btn ')) {\
			button.click()\
		}\
	}\
	";
	[[self __wkWebView] evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)webView:(id)v1 runJavaScriptAlertPanelWithMessage:(id)v2 initiatedByFrame:(id)v3 completionHandler:(void (^)(void))v4 {
	NSLog(@"runJavaScriptAlertPanelWithMessage: %@", v2);
	v4();
}

- (void)webView:(id)v1 runJavaScriptConfirmPanelWithMessage:(id)v2 initiatedByFrame:(id)v3 completionHandler:(void (^)(BOOL))v4 {
	NSLog(@"runJavaScriptConfirmPanelWithMessage: %@", v2);
	v4(YES);
}
%end