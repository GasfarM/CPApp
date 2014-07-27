//
//  PhotoPickerViewController.m
//  CPApp
//
//  Created by Gasfar Muhametdinov on 26.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoPickerCell.h"
#import "InstagramAPIModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "PreviewViewController.h"

@interface PhotoPickerViewController ()

@property (weak, nonatomic) NSArray *imageURLs;
@property (strong, nonatomic) NSMutableArray *selectedImages;

@end

@implementation PhotoPickerViewController

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
    self.previewButton.enabled = NO;
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareView
{
    self.imageURLs = [InstagramAPIModel sharedManager].cachedImagesURLs;
    self.collectionView.allowsMultipleSelection = YES;
    self.selectedImages = [[NSMutableArray alloc] init];
}

#pragma mark CollectionView related methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageURLs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.imageURLs[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerCell *selectedCell = (PhotoPickerCell *) [collectionView cellForItemAtIndexPath:indexPath];
    if (selectedCell.imageView.image)
    {
        [self.selectedImages addObject:selectedCell.imageView.image];
    }
    self.previewButton.enabled = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerCell *selectedCell = (PhotoPickerCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [self.selectedImages removeObject:selectedCell.imageView.image];
    if ([self.selectedImages count] == 0)
        self.previewButton.enabled = NO;
}

- (IBAction)doneButtonPressed
{
    [self performSegueWithIdentifier:@"toPreview" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPreview"])
    {
        PreviewViewController *destinationViewController = [segue destinationViewController];
        [destinationViewController makeCollageWithImages:self.selectedImages];
    }
}

@end
