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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.albumPreview];
    
    CGRect frame = {CGPointZero, THUMBNAIL_SIZE};
    self.albumPreview.frame = frame;
    
    CGFloat centerOffset = OFFSET + THUMBNAIL_SIZE.width/2;
    CGRect bounds = self.contentView.bounds;
    self.albumPreview.center = CGPointMake(CGRectGetWidth(bounds) - centerOffset,
                                           CGRectGetMidY(bounds));
}

- (void)setAlbum:(Album *)album {
    _album = album;
    
    if (album != nil) {
        self.textLabel.text = album.name;
        self.detailTextLabel.text = [[NSNumber numberWithUnsignedInteger:album.count] stringValue];
        self.albumPreview.image = album.thumbnail;
    } else {
        self.textLabel.text = nil;
        self.detailTextLabel.text = nil;
        self.albumPreview.image = nil;
    }
}

#pragma mark - Album Preview

- (UIImageView *)albumPreview {
    if (_albumPreview)
        return _albumPreview;
    _albumPreview = [[UIImageView alloc] init];
    return _albumPreview;
}

@end
