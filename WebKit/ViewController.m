//
//  ViewController.m
//  WebKit
//
//  Created by sonson on 2014/06/05.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"
#import "helper.h"

#import <WebKit/WebKit.h>

@implementation NSURLResponse(WebKitTest)

- (NSString*)httpResponseFieldDescription {
	if ([self isKindOfClass:[NSHTTPURLResponse class]]) {
		return [[(NSHTTPURLResponse*)self allHeaderFields] description];
	}
	return @"Not http response";
}

@end

@implementation WKNavigationResponse(WebKitTest)

- (NSString*)canShowMIMETypeDescription {
	if (self.canShowMIMEType) {
		return @"canShowMIMEType";
	}
	return @"Not canShowMIMEType";
}

- (NSString*)forMainFrameDescription {
	if (self.forMainFrame) {
		return @"forMainFrame";
	}
	return @"Not forMainFrame";
}

- (NSString*)responseFeildDescription {
	return [self.response httpResponseFieldDescription];
}

@end

@implementation WKNavigationAction(WebKitTest)

- (NSString*)navigationTypeDescription {
	switch (self.navigationType) {
		case WKNavigationTypeLinkActivated:
			return @"WKNavigationTypeLinkActivated";
		case WKNavigationTypeFormSubmitted:
			return @"WKNavigationTypeFormSubmitted";
		case WKNavigationTypeBackForward:
			return @"WKNavigationTypeBackForward";
		case WKNavigationTypeReload:
			return @"WKNavigationTypeReload";
		case WKNavigationTypeFormResubmitted:
			return @"WKNavigationTypeFormResubmitted";
		case WKNavigationTypeOther:
			return @"WKNavigationTypeOther";
		default:
			return @"Unknown";
	}
}

@end

@interface ViewController () <WKNavigationDelegate, WKUIDelegate>
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.userContentController = [[WKUserContentController alloc] init];
	
	WKUserScript *script = [[WKUserScript alloc] initWithSource:@"function hoge() {alert('this is alert message which is defined on Objective-C.');}"
												  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
											   forMainFrameOnly:YES];
	
	[configuration.userContentController addUserScript:script];
	
	WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
	webView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:webView];
	
	webView.navigationDelegate = self;
	webView.UIDelegate = self;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(webView);
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView(>=0)]-0-|"
																	  options:0
																	  metrics:nil
																		views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[webView(>=0)]-0-|"
																	  options:0
																	  metrics:nil
																		views:views]];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8192"]]];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation.request.URL);
	DNSLog(@"%@", ((NSHTTPURLResponse*)navigation.response).allHeaderFields);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	DNSLogMethod
	DNSLog(@"%@", navigation.request.URL);
	DNSLog(@"%@", ((NSHTTPURLResponse*)navigation.response).allHeaderFields);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	DNSLogMethod
	DNSLog(@"%@", navigation.request.URL);
	DNSLog(@"%@", ((NSHTTPURLResponse*)navigation.response).allHeaderFields);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation.request.URL);
	DNSLog(@"%@", ((NSHTTPURLResponse*)navigation.response).allHeaderFields);
	
	DNSLog(@"%@", webView.configuration.userContentController.userScripts);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation.request.URL);
	DNSLog(@"%@", ((NSHTTPURLResponse*)navigation.response).allHeaderFields);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation.request.URL);
	DNSLog(@"%@", ((NSHTTPURLResponse*)navigation.response).allHeaderFields);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
	DNSLogMethod
	DNSLog(@"request = %@", navigationAction.request);
	DNSLog(@"sourceFrame = %@", navigationAction.sourceFrame);
	DNSLog(@"targetFrame = %@", navigationAction.targetFrame);
	DNSLog(@"navigation type = %@", [navigationAction navigationTypeDescription]);
	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
	DNSLogMethod
	DNSLog(@"%@", [navigationResponse canShowMIMETypeDescription]);
	DNSLog(@"%@", [navigationResponse forMainFrameDescription]);
	DNSLog(@"%@", [navigationResponse responseFeildDescription]);
	decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
	DNSLogMethod
	return webView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler {
	DNSLogMethod
	DNSLog(@"alert -> %@", message);
	completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
	DNSLogMethod
	completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler {
	DNSLogMethod
	completionHandler(@"Something happened.");
}

@end
