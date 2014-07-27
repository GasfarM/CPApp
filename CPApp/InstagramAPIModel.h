//
//  InstagramAPIModel.h
//  CPApp
//
//  Created by Gasfar Muhametdinov on 25.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InstagramAPIModel : AFHTTPSessionManager<UITextFieldDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>
{
    NSDictionary *jsonData;
    
    NSString *instaCollagePathToImage;
}

@property (strong, nonatomic) NSArray *cachedImagesURLs;

+ (instancetype)sharedManager;

- (void)getImagesForUser:(NSString*)name;

@end
