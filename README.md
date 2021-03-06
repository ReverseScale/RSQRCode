# RSQRCode
二维码扫描、生成工具 Demo

![](https://img.shields.io/badge/platform-iOS-red.svg) 
![](https://img.shields.io/badge/language-Objective--C-orange.svg) 
![](https://img.shields.io/badge/download-791K-brightgreen.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

在微信的教育下，二维码逐渐走进了我们的生活，不少 App 也加入了扫码的功能，其实用起来也不是很麻烦。

| 名称 |1.列表页 |2.扫码页 |3.生成页 
| ------------- | ------------- | ------------- | ------------- | 
| 截图 | ![](https://s2.ax1x.com/2019/03/23/AGrEAf.jpg) | ![](https://s2.ax1x.com/2019/03/23/AGrkHP.jpg) | ![](https://s2.ax1x.com/2019/03/23/AGrFBt.jpg) | 
| 描述 | 通过 storyboard 搭建基本框架 | 扫描摄像头下二维码 | 根据文本生成二维码 |

## Advantage 框架的优势
* 1.文件少，代码简洁
* 2.功能完善，使用简单
* 3.自带 WebView 跳转
* 4.具备较高自定义性


## Requirements 要求
* iOS 7+
* Xcode 8+


## Usage 使用方法
### 代理部分
```
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
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
RSQRCode 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
