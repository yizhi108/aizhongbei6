//
//  NewSpaceViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/28.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "NewSpaceViewController.h"
#import <SVProgressHUD.h>
#import "ThridClass.h"
#import <CTAssetCheckmark.h>
#import <CTAssetsPickerController.h>
#import "HttpSection.h"
//CTAssetsPickerController

@interface NewSpaceViewController ()<UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray* imageArray;
    NSMutableArray* imageViewArray;
}
@property (weak, nonatomic) IBOutlet UITextView *contentView;

@end

@implementation NewSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    imageViewArray = [[NSMutableArray alloc] init];
    
    
    for(int i = 0;i<9;i++)
    {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(10+(i%3)*(SCREENWIDTH/3), 250+(i/3)*(SCREENWIDTH/3), SCREENWIDTH/3-20, SCREENWIDTH/3-20);
       
        
        [self.view addSubview:imageView];
        [imageViewArray addObject:imageView];
    }
}



- (IBAction)report:(id)sender {
    NSString* contentString = _contentView.text;
    NSString* picString = [[NSString alloc] init];
    for(int i = 0 ;i<imageArray.count;i++)
    {
        
        
        UIImage *image = imageArray[i];
      //  image = [[UIImage alloc] initWithContentsOfFile:@"12.jpg"];
        NSString *Datastring2 = [ThridClass imageBase64:image];
       
        if(picString == nil||[picString isEqualToString:@""])
        {
            picString = [NSString stringWithFormat:@"%@",Datastring2];
        }else{
            picString = [NSString stringWithFormat:@"%@,%@",picString,Datastring2];
        }

    }
    
    picString = [ThridClass imageEnd:picString];
  //  picString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)picString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);

    NSString* body = [NSString stringWithFormat:@"contents=%@&picCode=%@",contentString,picString];
    [HttpSection url:@"PublishTalking" type:@"POST" body:body block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      //  NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",dataString);
//        NSLog(@"%@",response);
        NSLog(@"%@",error);
        if(error == nil)
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [ThridClass SVProgressHUD_dismiss];
        }
        
    }];
    
    
    
    
}
- (IBAction)addPic:(id)sender {
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"从手机中选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        
        picker.showsSelectionIndex = YES;
        
        picker.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            picker.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:picker animated:YES completion:nil];
    
    }];

    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
          //  NSLog(@"摄像头不可用");
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"摄像头不可用"];
            [ThridClass SVProgressHUD_dismiss];
            
            
            return;
        }else{
          //  NSLog(@"需要实体机");
        }

        }];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

   
                                    
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray<PHAsset *> *)assets {
    /** 关闭图片选择控制器*/
    imageArray = [[NSMutableArray alloc] init];
    [picker dismissViewControllerAnimated:YES completion:^{
        CGFloat scale = [UIScreen mainScreen].scale;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        [imageArray removeAllObjects];
        /** 遍历选择的所有图片*/
        for (NSInteger i = 0; i < assets.count; i++) {
            PHAsset *asset = assets[i];
            CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
            [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                    [imageArray addObject:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageViewArray[imageArray.count-1] setImage:imageArray[imageArray.count-1]];
                });


            }];
           
        }
           }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
  //  self.imageView.image = info[UIImagePickerControllerOriginalImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
