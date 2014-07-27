//
//  UserSearchViewController.m
//  CPApp
//
//  Created by Gasfar Muhametdinov on 25.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import "UserSearchViewController.h"
#import "InstagramAPIModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface UserSearchViewController ()

@end

@implementation UserSearchViewController

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

- (IBAction)MakeCollageButton:(id)sender
{
    [self.userTextField resignFirstResponder];
    [self MakeCollage];
}

- (void)MakeCollage
{
    NSString *userName = self.userTextField.text;
    if ([userName isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите имя пользователя" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[InstagramAPIModel sharedManager] getImagesForUser:userName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if ([[InstagramAPIModel sharedManager].cachedImagesURLs count] != 0)
                {
                    [self performSegueWithIdentifier:@"toPhotoPicker" sender:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удалось получить данные пользователя" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        });
    }
}

@end
