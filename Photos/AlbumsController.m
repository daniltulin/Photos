//
//  ViewController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "AlbumsController.h"

#import <Photos/Photos.h>

#import "ImageManager.h"

#import "AlbumCell.h"
#import "PhotosController.h"

@interface AlbumsController ()

@property (nonatomic) PHFetchResult<PHAssetCollection *> *fetchResult;
@property (nonatomic) ImageManager *manager;

@property (nonatomic) NSArray *assets;

@end

@implementation AlbumsController

- (instancetype)init {
    if (self = [super init]) {
        [self.tableView registerClass:[AlbumCell class]
               forCellReuseIdentifier:ALBUM_CELL_ID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:ALBUM_CELL_ID
                                                      forIndexPath:indexPath];

    NSInteger index = indexPath.row;
    PHAssetCollection *collection = self.fetchResult[index];

    cell.textLabel.text = collection.localizedTitle;
    cell.detailTextLabel.text = nil;
    cell.thumbnail = nil;
    
    executeInBackground(^{
        NSInteger count = [self fetchAssetCount:collection];
        executeInBackground(^{
            cell.detailTextLabel.text = [[NSNumber numberWithInteger:count] stringValue];
        });
    });
    
    ImageResultHandler handler = ^void(UIImage *image) {
        cell.thumbnail = image;
    };
    [self.manager fetchImageAtIndex:index
                        withHandler:handler];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didEndDisplayingCell:(AlbumCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    [self.manager cancelImageFetchingAtIndex:index];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return THUMBNAIL_SIZE.height + 2*OFFSET;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *assetCollection = self.fetchResult[indexPath.row];
    PhotosController *controller = [PhotosController
                                    photosControllerWithAssetCollection:assetCollection];
    controller.title = assetCollection.localizedTitle;
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - Fetching

- (NSUInteger)fetchAssetCount:(PHAssetCollection *)assetCollection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    AssetFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                  options:options];
    return fetchResult.count;
}

- (void)fetchLastImage:(NSNumber *)identifier
         resultHandler:(ResultHandler)resultHandler {
    NSInteger index = [identifier integerValue];
    PHAssetCollection *assetCollection = self.fetchResult[index];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.fetchLimit = 1;
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                       ascending:NO];
    options.sortDescriptors = @[dateSortDescriptor];
    AssetFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                  options:options];
    PHAsset *lastAsset = [fetchResult firstObject];
    PHImageManager *manager = [PHImageManager defaultManager];

    CGFloat imageWidth = 3 * THUMBNAIL_SIZE.width;
    CGSize imageSize = CGSizeMake(imageWidth, imageWidth);

    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.networkAccessAllowed = YES;
}

#pragma mark - Image Manager

- (ImageManager *)manager {
    if (_manager)
        return _manager;
    NSArray *assets = nil;
    CGSize size = CGSizeZero;
    _manager = [ImageManager managerWithAssets:assets
                                  andImageSize:size];
    return _manager;
}

#pragma mark - FetchingResult

- (PHFetchResult<PHAssetCollection *> *)fetchResult {
    if (_fetchResult)
        return _fetchResult;

    PHAssetCollectionType type = PHAssetCollectionTypeAlbum;
    PHAssetCollectionSubtype subtype = PHAssetCollectionSubtypeAny;

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    _fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                            subtype:subtype
                                                            options:options];
    return _fetchResult;
}

@end
