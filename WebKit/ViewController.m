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

@implementation WKNavigation(WebKitTest)

- (NSString*)description {
	return [NSString stringWithFormat:@"WKNavigation:\nRequestURL=>%@\nResponse=>%@", self.request.URL.absoluteString, [self.response httpResponseFieldDescription]];
}

@end

@implementation WKNavigationResponse(WebKitTest)

- (NSString*)canShowMIMETypeDescription {
	if (self.canShowMIMEType) {
		return @"Can show MIME type";
	}
	return @"Can not show MIME type";
}

- (NSString*)forMainFrameDescription {
	if (self.forMainFrame) {
		return @"for main frame";
	}
	return @"Not for main frame";}

- (NSString*)responseFeildDescription {
	return [self.response httpResponseFieldDescription];
}

- (NSString*)description {
	NSInteger statusCode = -1;
	if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)self.response;
		statusCode = [httpResponse statusCode];
	}
	return [NSString stringWithFormat:@"WKNavigationResponse:\n mime=>%@\n forMainFrameDescription=>%@\n responseFeildDescription = %@\n header = %@\n status code = %ld",
			[self canShowMIMETypeDescription],
			[self forMainFrameDescription],
			[self responseFeildDescription],
			[self.response httpResponseFieldDescription],
			statusCode];
}

@end

@implementation WKNavigationAction(WebKitTest)

- (NSString*)description {
	return [NSString stringWithFormat:@"WKNavigationAction:\n request=>%@\n sourceFrame=>%@\n targetFrame = %@\n navigation type = %@",
			self.request,
			self.sourceFrame,
			self.targetFrame,
			[self navigationTypeDescription]];
}

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

@interface ViewController () <WKNavigationDelegate, WKUIDelegate> {
	WKWebView *_webView;
	IBOutlet UIProgressView *progressView;
}
@end

@implementation ViewController

- (IBAction)reload:(id)sender {
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8081"]]];
}

- (void)prepareWKWebView {
	// Create WKWebViewConfiguration object in order to attach javascript to html content.
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.userContentController = [[WKUserContentController alloc] init];
	
	// Create javascript to attach html content.
	WKUserScript *script = [[WKUserScript alloc] initWithSource:@"function hoge() {alert('this is alert message which is defined on Objective-C.');}"
												  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
											   forMainFrameOnly:YES];
	
	// Add javascript to configuration object
	[configuration.userContentController addUserScript:script];
	
	// Create and add WKWebView to self.view.
	WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
	webView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:webView];
	
	webView.navigationDelegate = self;
	webView.UIDelegate = self;
	
	// Autolayout
	NSDictionary *views = NSDictionaryOfVariableBindings(webView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView(>=0)]-0-|"
																	  options:0
																	  metrics:nil
																		views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView(>=0)]-0-|"
																	  options:0
																	  metrics:nil
																		views:views]];
//	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8081"]]];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
	
	_webView = webView;
}
            
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
	[self prepareWKWebView];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	DNSLogMethod
	DNSLog(@"%@", navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	DNSLogMethod
	DNSLog(@"%@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	DNSLogMethod
	DNSLog(@"%@", navigation);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
	DNSLogMethod
	DNSLog(@"%@", navigationAction);
	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
	DNSLogMethod
	DNSLog(@"%@", navigationResponse);
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
