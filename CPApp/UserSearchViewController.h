//
//  UserSearchViewController.h
//  CPApp
//
//  Created by Gasfar Muhametdinov on 25.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface UserSearchViewController : UIViewController<UITextFieldDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *makeButton;

@end
