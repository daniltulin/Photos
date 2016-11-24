//
//  ThumbnailCollectionView.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "ThumbnailView.h"

@interface ThumbnailView ()

@property (nonatomic) UIImageView *thumbnailImageView;

@end

@implementation ThumbnailView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self addSubview:self.thumbnailImageView];
    self.thumbnailImageView.frame = self.bounds;
}

- (void)setThumbnail:(UIImage *)thumbnailImage {
    _thumbnail = thumbnailImage;
    self.thumbnailImageView.image = thumbnailImage;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImageView = nil;
}

#pragma mark - ThumbnailImageView

- (UIImageView *)thumbnailImageView {
    if (_thumbnailImageView)
        return _thumbnailImageView;
    _thumbnailImageView = [[UIImageView alloc] init];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnailImageView.clipsToBounds = YES;
    _thumbnailImageView.backgroundColor = [UIColor lightGrayColor];
    return _thumbnailImageView;
}

@end
