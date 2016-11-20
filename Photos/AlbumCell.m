//
//  AlbumTableViewCell.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "AlbumCell.h"

@interface AlbumCell ()

@property (nonatomic) UIImageView *albumPreview;

@end

@implementation AlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self.contentView addSubview:self.albumPreview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = {CGPointZero, THUMBNAIL_SIZE};
    self.albumPreview.frame = frame;
    
    CGFloat centerOffset = OFFSET + THUMBNAIL_SIZE.width/2;
    CGRect bounds = self.contentView.bounds;
    self.albumPreview.center = CGPointMake(CGRectGetWidth(bounds) - centerOffset,
                                           CGRectGetMidY(bounds));
    
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.size.width = CGRectGetMinX(self.albumPreview.frame) -
    						CGRectGetMinX(labelFrame) - OFFSET;
    self.textLabel.frame = labelFrame;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setThumbnail:(UIImage *)thumbnail {
    _thumbnail = thumbnail;
    self.albumPreview.image = thumbnail;
}

#pragma mark - Album Preview

- (UIImageView *)albumPreview {
    if (_albumPreview)
        return _albumPreview;
    _albumPreview = [[UIImageView alloc] init];
    _albumPreview.contentMode = UIViewContentModeScaleAspectFill;
    _albumPreview.clipsToBounds = YES;
    return _albumPreview;
}

@end
