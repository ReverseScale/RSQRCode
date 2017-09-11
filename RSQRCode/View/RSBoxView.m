//
//  RSBoxView.m
//  RSQRCode
//
//  Created by WhatsXie on 2017/8/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//
#import <Masonry.h>
#import "RSBoxView.h"

@interface RSBoxView()
@property (nonatomic, strong) CALayer *lineLayer;

@end

@implementation RSBoxView
+ (instancetype)maskView {
    
    RSBoxView *boxView = [[RSBoxView alloc] init];
    
    return boxView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    self.lineLayer = [CALayer layer];
    self.lineLayer.contents = (id)[UIImage imageNamed:@"scanningLine"].CGImage;
    [self.layer addSublayer:self.lineLayer];
    [self repetitionAnimation];
    
    CGFloat bottom = -30;
    
    UIButton *lightBtn = [[UIButton alloc] init];
    lightBtn.backgroundColor = [UIColor whiteColor];
    lightBtn.alpha = 0.3;
    lightBtn.layer.cornerRadius = 25;
    lightBtn.layer.masksToBounds = YES;
    [lightBtn setImage:[UIImage imageNamed:@"lightoff"] forState:UIControlStateNormal];
    [self addSubview:lightBtn];
    
    
    UIButton *imgBtn = [[UIButton alloc] init];
    imgBtn.backgroundColor = [UIColor whiteColor];
    imgBtn.alpha = 0.3;
    imgBtn.layer.cornerRadius = 25;
    imgBtn.layer.masksToBounds = YES;
    [imgBtn setImage:[UIImage imageNamed:@"Img"] forState:UIControlStateNormal];
    [self addSubview:imgBtn];
    
    
    UIButton *createBtn = [[UIButton alloc] init];
    createBtn.backgroundColor = [UIColor whiteColor];
    createBtn.alpha = 0.3;
    createBtn.layer.cornerRadius = 25;
    createBtn.layer.masksToBounds = YES;
    [createBtn setImage:[UIImage imageNamed:@"Code"] forState:UIControlStateNormal];
    [self addSubview:createBtn];
    
    [imgBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.offset(44);
        make.bottom.offset(bottom);
        make.height.width.offset(50);
    }];
    
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.offset(bottom);
        make.height.width.offset(50);
    }];
    
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.offset(-44);
        make.bottom.offset(bottom);
        make.height.width.offset(50);
    }];
    
    
    self.lightBtn = lightBtn;
    self.imgBtn = imgBtn;
    self.createBtn = createBtn;
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 300;
    CGFloat pickingFieldHeight = 300;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2, (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    //填充使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
    
    self.lineLayer.frame = CGRectMake((self.frame.size.width - 300) / 2, (self.frame.size.height - 300) / 2, 300, 2);
}

- (void)stopAnimation {
    [self.lineLayer removeAnimationForKey:@"translationY"];
}

- (void)repetitionAnimation {
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 1.5;
    basic.repeatCount = NSIntegerMax;
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
}
@end
