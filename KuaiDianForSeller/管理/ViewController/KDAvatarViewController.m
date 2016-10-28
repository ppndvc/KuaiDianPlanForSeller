//
//  KDAvatarViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDAvatarViewController.h"
#import "JMActionSheet.h"

@interface KDAvatarViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImage *srcImage;

@end

@implementation KDAvatarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupUI
{
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = AVATAR_TITLE;
    
    if (VALIDATE_DICTIONARY(self.parameters))
    {
        NSString *titleString = [self.parameters objectForKey:@""];
        if (VALIDATE_STRING(titleString))
        {
            self.navigationItem.title = titleString;
        }
        
        _srcImage = (UIImage *)[self.parameters objectForKey:@""];
        if (VALIDATE_MODEL(_srcImage, @"UIImage"))
        {
            _imageView.image = _srcImage;
        }
    }
}
- (IBAction)onTapActionButton:(id)sender
{
    __block UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.view.backgroundColor = [UIColor clearColor];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    JMActionSheetDescription *desc = [[JMActionSheetDescription alloc] init];
    desc.actionSheetTintColor = [UIColor grayColor];
    desc.actionSheetCancelButtonFont = [UIFont boldSystemFontOfSize:17.0f];
    desc.actionSheetOtherButtonFont = [UIFont systemFontOfSize:16.0f];
    
    JMActionSheetItem *cancelItem = [[JMActionSheetItem alloc] init];
    cancelItem.title = BUTTON_TITLE_CANCEL;
    desc.cancelItem = cancelItem;
    
    WS(ws);
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        JMActionSheetItem *cameraAction = [[JMActionSheetItem alloc] init];
        cameraAction.title = CAMERA_BUTTON_TITLE;
        cameraAction.action = ^(void){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [ws presentViewController:imagePicker animated:YES completion:nil];
        };
        [items addObject:cameraAction];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        JMActionSheetItem *pictureAction = [[JMActionSheetItem alloc] init];
        pictureAction.title = PICTURE_BUTTON_TITLE;
        
        pictureAction.action = ^(void){
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [ws presentViewController:imagePicker animated:YES completion:nil];
        };
        [items addObject:pictureAction];
    }
    
    desc.items = items;
    [JMActionSheet showActionSheet:desc];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self processImage:selectedImage];
}
-(void)processImage:(UIImage *)srcImage
{
    [self showHUD];
    srcImage = [KDTools compressWithSourceImage:srcImage targetWidth:MAX_COMPRESS_IMAGE_WIDTH];
    _imageView.image = srcImage;
    _srcImage = srcImage;
    [self hideHUD];
}

-(void)dealloc
{
    DDLogInfo(@"-KDAvatarViewController dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
