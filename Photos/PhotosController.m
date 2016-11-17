//
//  PhotosController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "PhotosController.h"

#import "PageController.h"
#import "PreviewController.h"

#import "ThumbnailView.h"

@interface PhotosController () <UICollectionViewDelegateFlowLayout, UIPageViewControllerDataSource,
								UIPageViewControllerDelegate>

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
}

#pragma mark <UICollectionViewDelegate>

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
    PHAsset *asset = self.fetchResult[indexPath.row];
    
    ResultHandler resultHandler = ^void(UIImage *result, NSDictionary *info) {
            cell.thumbnail = result;
    };
    CGSize thumbnailSize = [self thumbnailSize];
    float imageWidth = 3 * thumbnailSize.width;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(imageWidth, imageWidth)
                                              contentMode:PHImageContentModeDefault
                                                  options:nil
                                            resultHandler:resultHandler];
    return cell;
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
    
    PHAsset *asset = self.fetchResult[index - 1];
    return [PreviewController previewControllerWithAsset:asset andIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    PreviewController *previewController = (PreviewController *)viewController;
    NSUInteger index = previewController.index;
    if (index == self.fetchResult.count - 1)
        return nil;
    PHAsset *asset = self.fetchResult[index + 1];
    return [PreviewController previewControllerWithAsset:asset andIndex:index + 1];
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

@end
