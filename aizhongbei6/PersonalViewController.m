//
//  PersonalViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/26.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "PersonalViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "ThridClass.h"
#import "HttpSection.h"


@interface PersonalViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSDictionary* jsonDict;
    NSData *imageData;
}
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sex;
@property (weak, nonatomic) IBOutlet UITextField *studentID;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UIImageView *Pic;



@end

@implementation PersonalViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //_phone.isEditing = NO;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [self viewInit];
    [HttpSection url:@"GetPersonnel" type:@"POST" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",string);
        NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
        jsonDict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            _name.text = jsonDict[@"Nickname"]== [NSNull null] ? @"未填写":jsonDict[@"Nickname"];
            _phone.text = jsonDict[@"MobilePhone"]== [NSNull null]?  @"未填写":jsonDict[@"MobilePhone"];
            NSString* Sextext = jsonDict[@"Sex"]== [NSNull null] ? @"未填写":jsonDict[@"Sex"];
            if([Sextext isEqualToString:@"女"])
            {
                //_sex.selected = NO;
                _sex.selectedSegmentIndex = 1;
            }else{
                _sex.selectedSegmentIndex = 0;
            }
            _studentID.text = jsonDict[@"StudentNo"] == [NSNull null] ? @"未填写":jsonDict[@"StudentNo"];
            _realName.text = jsonDict[@"Name"]== [NSNull null] ? @"未填写":jsonDict[@"Name"];
            
            
        });
    }];
    [self viewF5];
    
}

-(void)viewF5
{
    [HttpSection url:@"GetPersonnel" type:@"POST" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",string);
        NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
        jsonDict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            _name.text = jsonDict[@"Nickname"]== [NSNull null] ? @"未填写":jsonDict[@"Nickname"];
            _phone.text = jsonDict[@"MobilePhone"]== [NSNull null]?  @"未填写":jsonDict[@"MobilePhone"];
            NSString* Sextext = jsonDict[@"Sex"]== [NSNull null] ? @"未填写":jsonDict[@"Sex"];
            if([Sextext isEqualToString:@"女"])
            {
                //_sex.selected = NO;
                _sex.selectedSegmentIndex = 1;
            }else{
                _sex.selectedSegmentIndex = 0;
            }
            _studentID.text = jsonDict[@"StudentNo"] == [NSNull null] ? @"未填写":jsonDict[@"StudentNo"];
            _realName.text = jsonDict[@"Name"]== [NSNull null] ? @"未填写":jsonDict[@"Name"];
            
            if(jsonDict[@"PictureUrl"] != [NSNull null])
            {
                [_Pic sd_setImageWithURL:jsonDict[@"PictureUrl"] placeholderImage:[UIImage imageNamed:@"face.png"]];
            }
            
        });
    }];

}



-(void)viewInit
{
    _cancelButton.hidden = YES;
    _confirmButton.hidden = YES;
    _phone.userInteractionEnabled = NO;
    _name.userInteractionEnabled = NO;
    _sex.userInteractionEnabled = NO;
    _studentID.userInteractionEnabled = NO;
    _realName.userInteractionEnabled = NO;
    _Pic.userInteractionEnabled = NO;
}

- (IBAction)new:(id)sender {
    //
    _phone.userInteractionEnabled = NO;// 除了手机号，其他的都可以修改。
    _name.userInteractionEnabled = YES;
    _sex.userInteractionEnabled = YES;
    _studentID.userInteractionEnabled = YES;
    _realName.userInteractionEnabled = YES;
    
    _cancelButton.hidden = NO;
    _confirmButton.hidden = NO;
    _Pic.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageChange)];
    [_Pic addGestureRecognizer:singleTap];
    
    
    
    
}
- (IBAction)confirm:(id)sender {
    
    
    
    [self viewInit];
    NSString* sexString = [NSString string];
    if(_sex.selectedSegmentIndex == 0)
    {
        sexString = @"男";
    }else{
        sexString = @"女";
    }

    /*
     NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
     然后应用Base64编码将其转换成base64编码的字符串：
     NSString *encodedString = [imageData base64Encoding];
     */
    UIImage* image;
//    if(_image2.isHidden == YES)
//    {
        image = _Pic.image;
//    }else{
//        image =  _image2.image;
//    }
    
    NSString* body;
    NSString* pic = [ThridClass imageBase64:image];
    pic = [ThridClass imageEnd:pic];
   // NSLog(@"%@",pic);
    body = [NSString stringWithFormat:@"name=%@&studentNo=%@&nickname=%@&sex=%@&picCode=%@",_realName.text,_studentID.text,_name.text,sexString,pic];
        
    
    
    
    [HttpSection url:@"UpdateUser" type:@"POST" body:body block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        dispatch_async(dispatch_get_main_queue(), ^{
            if([dataString intValue] > 0 )
            {
                [self performSelector:@selector(SVP2:) withObject:@"修改成功" afterDelay:0.5];
            }else{
                [self performSelector:@selector(SVP:) withObject:@"修改失败" afterDelay:0.5];
            }
        });
        
    }];
    
    [self viewWillAppear:YES];
}

-(void)ImageChange
{
    //这里，就是点击图片调用的方法。
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"从手机中选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        // 2. 创建图片选择控制器
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        /**
         typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
         UIImagePickerControllerSourceTypePhotoLibrary, // 相册
         UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
         UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
         }
         */
        // 3. 设置打开照片相册类型(显示所有相簿)
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // 照相机
        // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 4.设置代理
        ipc.delegate = self;
        // 5.modal出这个控制器
        [self presentViewController:ipc animated:YES completion:nil];
        
    }];
    
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"摄像头不可用");
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"摄像头不可用"];
            [ThridClass SVProgressHUD_dismiss];
            
            
            return;
        }else{
            NSLog(@"需要实体机");
        }
        
    }];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
  //  _image2.hidden = NO;
    // 设置图片
    //_image2.image = info[UIImagePickerControllerOriginalImage];
    _Pic.image = info[UIImagePickerControllerOriginalImage];
}

- (IBAction)cancel:(id)sender {
     [self viewInit];
    _cancelButton.hidden = YES;
    _confirmButton.hidden = YES;
     [self viewF5];
    
    
}


- (IBAction)password:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField * firstKeywordTF = [[UITextField alloc]init];
        UITextField * secondKeywordTF = [[UITextField alloc]init];
        UITextField * ThirdKeywordTF = [[UITextField alloc]init];
        NSArray * textFieldArr = @[firstKeywordTF,secondKeywordTF,ThirdKeywordTF];
        
        textFieldArr = alertController.textFields;
        UITextField * tf1 = alertController.textFields[0];
        UITextField * tf2 = alertController.textFields[1];
        UITextField * tf3 = alertController.textFields[2];
        
        
        if ([tf2.text isEqualToString: tf3.text]) {
            NSString* body = [NSString stringWithFormat:@"oldPassword=%@&newPassword=%@",tf1.text,tf3.text];
            [HttpSection url:@"ChangePassword" type:@"POST" body:body block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([dataString isEqualToString:@"true"])
                    {
                         [self performSelector:@selector(SVP2:) withObject:@"修改成功" afterDelay:0.5];
                    }else{
                        [self performSelector:@selector(SVP:) withObject:@"修改失败" afterDelay:0.5];
                    }
                });
                
            }];
        }else
        {
            [alertController dismissViewControllerAnimated:NO completion:nil];
            
            //[self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
            [self performSelector:@selector(SVP:) withObject:@"两次输入不一致" afterDelay:0.5];
            
        }
       

        
    }]];
    
    //增加取消按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入旧密码";
        textField.secureTextEntry = YES;
    }];
    
    //定义第二个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新密码";
        textField.secureTextEntry = YES;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"确认新密码";
        textField.secureTextEntry = YES;
        
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)SVP:(NSString*) str
{
    [SVProgressHUD showErrorWithStatus:str];
    [ThridClass SVProgressHUD_dismiss];
}

-(void)SVP2:(NSString*) str
{
    [SVProgressHUD showSuccessWithStatus:str];
    [ThridClass SVProgressHUD_dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
