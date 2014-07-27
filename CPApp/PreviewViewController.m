//
//  PreviewViewController.m
//  CPApp
//
//  Created by Gasfar Muhametdinov on 26.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import "PreviewViewController.h"
#import <MessageUI/MessageUI.h>

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Стараемся уместить весь коллаж на экране, путем уменьшения размера выбранных фото
- (void)makeCollageWithImages:(NSArray *)images
{
    CGSize collageSize = self.view.frame.size;
    
    // Размер коллажа
    collageSize.height = 500;
    collageSize.width = 320;
    int col = 0;
    int row = 0;
    UIGraphicsBeginImageContext(collageSize);
    
    // Считаем количество фото по высоте и ширине коллажа
    float colHeight = (sqrt(([images count]) / (collageSize.width / collageSize.height))) + 1;
    float colWidth = ((collageSize.width / collageSize.height) * colHeight) + 1;
    
    // Размеры фото в зависимости от их количества по высоте и ширине коллажа
    float imWidth = (collageSize.width / colWidth) + 1;
    float imHeight = (collageSize.height / colHeight) + 1;
    
    for (UIImage *image in images)
    {
        [image drawInRect:CGRectMake(col, row, (int)imWidth, (int)imHeight)];
        col += (int)imWidth;
        if ((col + (int)imWidth) > collageSize.width)
        {
            col = 0;
            row += (int)imHeight;
        }
    }
    UIImage *collageImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = collageImage;
}

- (IBAction)sendMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:@"Instagram collage"];
        NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
        [mailVC addAttachmentData:imageData mimeType:@"image/png" fileName:@"photoCollage"];
        [self presentViewController:mailVC animated:YES completion:nil];
    }
    else
    {
        //[SVProgressHUD showErrorWithStatus:@"Ошибка отправки письма"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
