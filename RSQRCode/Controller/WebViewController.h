//
//  WebViewController.h
//  RSQRCode
//
//  Created by WhatsXie on 2017/8/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong,nonatomic) NSString *url;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
