//
//  TextViewController.h
//  RSQRCode
//
//  Created by WhatsXie on 2017/8/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (strong,nonatomic) NSString *contentStr;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
