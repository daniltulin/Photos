//
//  ViewController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "AlbumsController.h"

#import <Photos/Photos.h>

#import "AlbumCell.h"

#import "PhotosController.h"

@interface AlbumsController ()

@property (nonatomic) PHFetchResult<PHAssetCollection *> *fetchResult;

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
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.album = nil;
    
    NSUInteger index = indexPath.row;
    PHAssetCollection *assetCollection = self.fetchResult[index];
    
    NSString *name = assetCollection.localizedTitle;
    NSUInteger count = [self fetchAssetCount:assetCollection];
    
    ResultHandler resultHandler = ^void(UIImage *result, NSDictionary *info) {
        Album *album = [Album albumWithName:name
                                      count:count
                                  thumbnail:result];
        cell.album = album;
    };
    [self fetchLastImage:assetCollection
           resultHandler:resultHandler];
    return cell;
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

#pragma mark - Fetch Result

- (PHFetchResult<PHAssetCollection *> *)fetchResult {
    if (_fetchResult)
        return _fetchResult;

    PHAssetCollectionType type = PHAssetCollectionTypeAlbum;
    PHAssetCollectionSubtype subtype = PHAssetCollectionSubtypeAlbumRegular;
    _fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                            subtype:subtype
                                                            options:nil];
    return _fetchResult;
}

- (NSUInteger)fetchAssetCount:(PHAssetCollection *)assetCollection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    AssetFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                  options:options];
    return fetchResult.count;
}

- (void)fetchLastImage:(PHAssetCollection *)assetCollection
         resultHandler:(ResultHandler)resultHandler {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.fetchLimit = 1;
    
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
    
    [manager requestImageForAsset:lastAsset
                       targetSize:imageSize
                      contentMode:contentMode
                          options:nil
                    resultHandler:resultHandler];
}

@end
