//
//  InstagramAPIModel.m
//  CPApp
//
//  Created by Gasfar Muhametdinov on 25.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import "InstagramAPIModel.h"
#import "InstagramAPIConsts.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface InstagramAPIModel ()
@end

@implementation InstagramAPIModel

+ (instancetype)sharedManager
{
    static InstagramAPIModel *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[InstagramAPIModel alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString: kInstagramURL]];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    
    return self;
}

- (void)getImagesForUser:(NSString*)name
{
    self.cachedImagesURLs = nil;
    self.cachedImagesURLs = [self getImagesFromMedia:name];
}

- (NSArray *)getImagesFromMedia:(NSString *)userName
{
    NSString *instagramUserId;
    NSString *searchUrlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&client_id=061f5cef0f6a40b09e6c9848f2a55f1d", userName];
    jsonData = [self jsonFromInst:searchUrlString];
    if (jsonData == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"Не удалось подключиться"];
        return nil;
    }
    NSDictionary *metaSD = (NSDictionary*)[jsonData objectForKey:@"meta"];
    
    // Получаем UserID пользователя по нику
    if (metaSD && [[metaSD objectForKey:@"code"] integerValue] == 200)
    {
        NSArray *instagramSearchData = (NSArray*)[jsonData objectForKey:@"data"];
        NSDictionary *userData;
        if ([instagramSearchData count] != 0)
        {
            for (int i=0; i < [instagramSearchData count]; i++)
            {
                userData = [instagramSearchData objectAtIndex:i];
                NSString *userNameFromData = [userData objectForKey:@"username"];
                if ((userNameFromData.length != 0) & ([userNameFromData isEqualToString:userName]))
                {
                    instagramUserId = [userData objectForKey:@"id"];
                    break;
                }
            }
        }
    }
    // Получаем массив URL фото по UserID пользователя
    if (instagramUserId != nil & instagramUserId.length != 0)
    {
        NSString *userMediaUrlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent?count=-1&client_id=061f5cef0f6a40b09e6c9848f2a55f1d", instagramUserId];
        jsonData = [self jsonFromInst:userMediaUrlString];
        NSDictionary *metaM = (NSDictionary*)[jsonData objectForKey:@"meta"];
        
        if (metaM && [[metaM objectForKey:@"code"] integerValue] == 200)
        {
            return [[NSArray alloc] initWithArray:[self getURLArray]];
        }
        else
        {
            // У пользователя нет фото
            [SVProgressHUD showErrorWithStatus:@"Нет фото у пользователя"];
            return nil;
        }
    }
    else
    {
        // Пользователь не найден
        [SVProgressHUD showErrorWithStatus:@"Неверное имя"];
        return nil;
    }
    return nil;
}

- (NSDictionary *) jsonFromInst:(NSString*)urlString
{
    NSURLRequest *requestData  = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:nil error:nil];
    if (responseData == nil)
    {
        return nil;
    }
    NSDictionary *jsonDataSet = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    return jsonDataSet;
}

// Получаем массив с URL фото
- (NSArray *)getURLArray
{
    NSArray *instagramMediaData = (NSArray*)[jsonData objectForKey:@"data"];
    NSDictionary *userMedia;
    NSDictionary *images;
    NSDictionary *imageStandartRes;
    NSDictionary *imageURL;
    NSDictionary *likes;
    NSDictionary *likesCount;
    
    NSString *LINK = @"link";
    NSString *COUNT = @"count";
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict;
    for (int i=0; i < [instagramMediaData count]; i++)
    {
        userMedia        = [instagramMediaData objectAtIndex:i];
        images           = [userMedia objectForKey:@"images"];
        imageStandartRes = [images objectForKey:@"low_resolution"];
        imageURL         = [imageStandartRes objectForKey:@"url"];
        likes            = [userMedia objectForKey:@"likes"];
        likesCount       = [likes objectForKey:@"count"];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:imageURL, LINK, likesCount, COUNT, nil];
        [array addObject:dict];
    }
    return [self getPopularImgURLArray:array count:COUNT];
}

// Получаем популярные фото
- (NSArray *)getPopularImgURLArray:(NSMutableArray *)imgURLArray count:(NSString *)countString
{
    NSArray *sortedArray;
    NSMutableArray *urlForCollage = [[NSMutableArray alloc] init];
    NSSortDescriptor *countDescriptor = [[NSSortDescriptor alloc] initWithKey:countString ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:countDescriptor];
    sortedArray = [imgURLArray sortedArrayUsingDescriptors:descriptors];
    if ([sortedArray count] != 0)
    {
        for (int i=0; i < [sortedArray count]; i++)
        {
            NSDictionary *element = [sortedArray objectAtIndex:i];
            NSString *instagramLink = [element objectForKey:@"link"];
            [urlForCollage addObject:instagramLink];
        }
        return [[NSArray alloc] initWithArray:urlForCollage];
    }
    else
    {
        return nil;
    }
}

@end
