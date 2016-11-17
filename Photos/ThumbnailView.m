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
    self.thumbnailImageView.image = thumbnailImage;
}

#pragma mark - ThumbnailImageView

- (UIImageView *)thumbnailImageView {
    if (_thumbnailImageView)
        return _thumbnailImageView;
    _thumbnailImageView = [[UIImageView alloc] init];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnailImageView.clipsToBounds = YES;
    return _thumbnailImageView;
}

@end
