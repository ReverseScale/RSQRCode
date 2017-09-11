//
//  RSBoxView.h
//  RSQRCode
//
//  Created by WhatsXie on 2017/8/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSBoxView : UIView
@property (strong,nonatomic) UIButton *lightBtn;
@property (strong,nonatomic) UIButton *imgBtn;
@property (strong,nonatomic) UIButton *createBtn;

+ (instancetype)maskView;
- (void)repetitionAnimation;
@end
