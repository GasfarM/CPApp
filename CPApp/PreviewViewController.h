//
//  PreviewViewController.h
//  CPApp
//
//  Created by Gasfar Muhametdinov on 26.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PreviewViewController : UIViewController<MFMailComposeViewControllerDelegate>

- (void)makeCollageWithImages:(NSArray *)images;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
