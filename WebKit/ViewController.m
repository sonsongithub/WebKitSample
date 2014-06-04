//
//  ViewController.m
//  WebKit
//
//  Created by sonson on 2014/06/05.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
	webView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:webView];
	
	NSDictionary *views = NSDictionaryOfVariableBindings(webView);
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView(>=0)]-0-|"
																	  options:0
																	  metrics:nil
																		views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView(>=0)]-0-|"
																	  options:0
																	  metrics:nil
																		views:views]];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
