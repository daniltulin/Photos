//
//  PhotosController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "PhotosController.h"

#import "ImageManager.h"

#import "PageController.h"
#import "PreviewController.h"

#import "ThumbnailView.h"

@interface PhotosController () <UICollectionViewDelegateFlowLayout, UIPageViewControllerDataSource,
								UIPageViewControllerDelegate>

@property (nonatomic) ImageManager *manager;
@property (nonatomic) PHAssetCollection *assetCollection;
@property (nonatomic) AssetFetchResult *fetchResult;

@property (nonatomic) UIPageViewController *pageViewController;

@end

@implementation PhotosController

- (instancetype)init {
    NSLog(@"Call initWithAssetCollection: instead");
    abort();
    return nil;
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection {
    UICollectionViewFlowLayout *viewLayout = [[UICollectionViewFlowLayout alloc] init];
    viewLayout.minimumLineSpacing = .0f;
    viewLayout.minimumInteritemSpacing = .0f;
    if (self = [super initWithCollectionViewLayout:viewLayout]) {
        self.assetCollection = assetCollection;
    }
    return self;
}

+ (instancetype)photosControllerWithAssetCollection:(PHAssetCollection *)assetCollection {
    PhotosController *controller = [[PhotosController alloc]
                                    initWithAssetCollection:assetCollection];
    return controller;
}


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ThumbnailView class]
            forCellWithReuseIdentifier:reuseIdentifier];
    executeInBackground(^{
        [self manager];
    });
}

#pragma mark -  <UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                    forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    ImageResultHandler handler = ^void(UIImage *image) {
        cell.thumbnail = image;
    };
    [self.manager fetchImageAtIndex:index
                        withHandler:handler];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    [self.manager cancelImageFetchingAtIndex:index];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self thumbnailSize];
}

- (CGSize)thumbnailSize {
    CGFloat width = CGRectGetWidth(self.view.bounds) / 4;
    return CGSizeMake(width, width);
}

- (CGSize)thumbnailPhysicalSize {
    CGSize thumbnailSize = [self thumbnailSize];
    float imageWidth = 3 * thumbnailSize.width;
    return CGSizeMake(imageWidth, imageWidth);
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    PageController *controller = [[PageController alloc] init];
    controller.dataSource = self;
    PHAsset *asset = self.fetchResult[index];
    
    PreviewController *previewController = [PreviewController previewControllerWithAsset:asset
                                                                                andIndex:index];
    [controller setViewController:previewController];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - PageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    PreviewController *previewController = (PreviewController *)viewController;
    NSUInteger index = previewController.index;
    if (index == 0)
        return nil;
    NSInteger newIndex = index - 1;
    PHAsset *asset = self.fetchResult[newIndex];
    return [PreviewController previewControllerWithAsset:asset andIndex:newIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    PreviewController *previewController = (PreviewController *)viewController;
    NSUInteger index = previewController.index;
    if (index == self.fetchResult.count - 1)
        return nil;
    NSInteger newIndex = index + 1;
    PHAsset *asset = self.fetchResult[newIndex];
    return [PreviewController previewControllerWithAsset:asset andIndex:newIndex];
}

#pragma mark - Fetch Result

- (AssetFetchResult *)fetchResult {
    if (_fetchResult)
        return _fetchResult;
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                       ascending:YES];
    options.sortDescriptors = @[dateSortDescriptor];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    
    _fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection
                                                 options:options];
    return _fetchResult;
}

- (NSArray *)albumAssets {
    NSMutableArray *assets = [NSMutableArray array];
    [self.fetchResult enumerateObjectsUsingBlock:^(PHAsset *obj,
                                                   NSUInteger idx,
                                                   BOOL *stop) {
        [assets addObject:obj];
    }];
    return assets;
}

#pragma mark - ImageManager

- (ImageManager *)manager {
    if (_manager)
        return _manager;
    NSArray *assets = [self albumAssets];
    _manager = [ImageManager managerWithAssets:assets
                                  andImageSize:CGSizeZero];
    return _manager;
}

@end
