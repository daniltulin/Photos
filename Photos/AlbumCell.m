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

- (void)setAssetCollection:(PHAssetCollection *)assetCollection {
    _assetCollection = assetCollection;
    
    self.textLabel.text = assetCollection.localizedTitle;
    self.detailTextLabel.text = [self fetchAssetsCountString];
    [self fetchLastAlbumImage];
}

- (NSString *)fetchAssetsCountString {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    AssetFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection
                                                                  options:options];
    return [[NSNumber numberWithLong:fetchResult.count] stringValue];
}

- (void)fetchLastAlbumImage {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.fetchLimit = 1;
    
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                       ascending:YES];
    options.sortDescriptors = @[dateSortDescriptor];
    AssetFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection
                                                                          options:options];
    PHAsset *lastAsset = [fetchResult firstObject];
    PHImageManager *manager = [PHImageManager defaultManager];
    
    ResultHandler resultHandler = ^void(UIImage *result, NSDictionary *info) {
        self.albumPreview.image = result;
    };
    
    [manager requestImageForAsset:lastAsset
                       targetSize:THUMBNAIL_SIZE
                      contentMode:PHImageContentModeDefault
                          options:nil
                    resultHandler:resultHandler];
}

#pragma mark - Album Preview

- (UIImageView *)albumPreview {
    if (_albumPreview)
        return _albumPreview;
    _albumPreview = [[UIImageView alloc] init];
    return _albumPreview;
}

@end
