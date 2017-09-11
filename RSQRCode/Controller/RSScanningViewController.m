//
//  RSScanningViewController.m
//  RSQRCode
//
//  Created by WhatsXie on 2017/8/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "RSScanningViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "RSBoxView.h"
#import "RSCreateQRViewController.h"
#import "TextViewController.h"
#import "WebViewController.h"

#define WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface RSScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, strong) AVCaptureConnection *connection;

@property (nonatomic, assign) BOOL flashOpen;

@property (strong,nonatomic) RSBoxView *boxView;

@end

@implementation RSScanningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.session startRunning];
    [self.boxView repetitionAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

- (void)setupUI {
    _boxView = [RSBoxView maskView];
    
    _boxView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    [self.view addSubview:_boxView];
    
    [_boxView.lightBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchDown];
    
    [_boxView.imgBtn addTarget:self action:@selector(openPhoto:) forControlEvents:UIControlEventTouchDown];
    
    [_boxView.createBtn addTarget:self action:@selector(createQR:) forControlEvents:UIControlEventTouchDown];
    
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _layer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_layer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                  context:nil
                                                  options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            CIQRCodeFeature *feature = [features firstObject];
            
            BOOL isURL = [weakSelf getUrlLink:feature.messageString];
            
            if (isURL) {
                
                [self pushWebViewWithURLSring:feature.messageString];
                
            } else {
                
                [self piushTextViewWithTextString:feature.messageString];
                
            }
        } else {
            [weakSelf showAlertWithTitle:@"提示" message:@"没有发现二维码" handler:nil];
        }
        
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        BOOL isURL = [self getUrlLink:metadataObject.stringValue];
        
        if (isURL) {
            
            [self pushWebViewWithURLSring:metadataObject.stringValue];
            
        } else {
            
            [self piushTextViewWithTextString:metadataObject.stringValue];

        }
    }
}

- (void)pushWebViewWithURLSring:(NSString *)stringURL {
    WebViewController *webVC = [[WebViewController alloc] init];
    
    webVC.url = stringURL;
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)piushTextViewWithTextString:(NSString *)string {
    TextViewController *tVC = [[TextViewController alloc] init];
    
    tVC.contentStr = string;
    
    [self.navigationController pushViewController:tVC animated:YES];
}

#pragma mark - session
- (AVCaptureSession *)session {
    if (!_session) {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 主线程刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域
            CGFloat width = 300 / CGRectGetHeight(self.view.frame);
            CGFloat height = 300 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            
            
            //设置编码 二维&条形
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            session;
        });
    }
    
    return _session;
}


#pragma mark - 正则比配URL
- (BOOL)getUrlLink:(NSString *)link {
    NSString *regTags = @"((http[s]{0,1}|ftp|HTTP[S]|FTP)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regTags];
    
    BOOL isValid = [predicate evaluateWithObject:link];
    
    return isValid;
}

#pragma -mark Selector 方法

- (void)createQR:(UIButton *)sender {
    RSCreateQRViewController *vc = [[RSCreateQRViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 闪光灯开关
- (void)openLight:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        
        [sender setImage:[UIImage imageNamed:@"lighton"] forState:UIControlStateNormal];
        
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
        
        [sender setImage:[UIImage imageNamed:@"lightoff"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 打开相册
- (void)openPhoto:(UIButton *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    } else {
        [self showAlertWithTitle:@"提示" message:@"设备不支持访问相册" handler:nil];
    }
    
}


#pragma mark - 提示框
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
