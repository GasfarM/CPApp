//
//  PhotoPickerCell.m
//  CPApp
//
//  Created by Gasfar Muhametdinov on 26.07.14.
//  Copyright (c) 2014 NT. All rights reserved.
//

#import "PhotoPickerCell.h"

@implementation PhotoPickerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected && self.imageView.image)
    {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    else
    {
        self.contentView.backgroundColor = nil;
    }
}

@end
