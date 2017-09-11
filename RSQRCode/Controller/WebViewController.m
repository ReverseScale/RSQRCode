//
//  WebViewController.m
//  RSQRCode
//
//  Created by WhatsXie on 2017/8/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    self.webView.delegate = self;
    [self.webView loadRequest:urlRequest];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0 ,0 ,30 ,30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"Safari"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButton;
}


//safari打开
- (void)rightBarButtonClick:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:self.url];
    
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [self getTitle];
}

//获取网站标题
- (NSString *)getTitle {
    NSString *str = [[NSString alloc]initWithFormat:@"document.title"];
    NSString *returnstr = [self.webView stringByEvaluatingJavaScriptFromString:str];
    if ([returnstr isEqualToString: @""]) {
        return @" ";
    }
    return returnstr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
