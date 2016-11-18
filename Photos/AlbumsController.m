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

@interface AlbumsController () <PHPhotoLibraryChangeObserver>

@property (nonatomic) PHFetchResult<PHAssetCollection *> *fetchResult;

@property (nonatomic) NSMutableDictionary *operations;
@property (nonatomic) NSOperationQueue *operationQueue;

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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
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

    NSNumber *identifier = [NSNumber numberWithUnsignedInteger:index];
    NSDictionary *args = @{@"cell": cell,
                           @"identifier": identifier};

    typedef NSInvocationOperation Operation;
    Operation *operation = [[Operation alloc] initWithTarget:self
                                                    selector:@selector(obtainCellInformation:)
                                                      object:args];
    [self.operationQueue addOperation:operation];
    self.operations[identifier] = operation;
    return cell;
}

- (void)tableView:(UITableView *)tableView
didEndDisplayingCell:(AlbumCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *identifier = [NSNumber numberWithUnsignedInteger:indexPath.row];
    NSOperation *operation = self.operations[identifier];
    if (operation != nil && operation.isFinished == NO) {
        [operation cancel];
        [self.operations removeObjectForKey:identifier];
    }
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

- (void)obtainCellInformation:(NSDictionary *)args {
    AlbumCell *cell = args[@"cell"];
    NSNumber *identifier = args[@"identifier"];
    NSInteger index = [identifier integerValue];

    PHAssetCollection *assetCollection = self.fetchResult[index];
    NSInteger count = [self fetchAssetCount:assetCollection];

    enqueueInMainQueue(^{
        cell.detailTextLabel.text = [[NSNumber numberWithLong:count] stringValue];
    });

    ResultHandler resultHandler = ^void(UIImage *result, NSDictionary *info) {
        enqueueInMainQueue(^{
            if (self.operations[identifier] == nil)
                return;

            [self.operations removeObjectForKey:identifier];
            cell.thumbnail = result;
        });
    };
    [self fetchLastImage:assetCollection
           resultHandler:resultHandler];
}

- (void)fetchLastImage:(PHAssetCollection *)assetCollection
         resultHandler:(ResultHandler)resultHandler {
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
    requestOptions.synchronous = YES;
    
    [manager requestImageForAsset:lastAsset
                       targetSize:imageSize
                      contentMode:contentMode
                          options:requestOptions
                    resultHandler:resultHandler];
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

#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    PHFetchResultChangeDetails *changeDetails =
    	[changeInstance changeDetailsForFetchResult:self.fetchResult];
    enqueueInMainQueue(^{
        if (changeDetails != nil)
            [self updateContentWithChangeDetails:changeDetails];
        else
            [self.tableView reloadData];
    });
}

- (void)updateContentWithChangeDetails:(PHFetchResultChangeDetails *)changeDetails {
    _fetchResult = changeDetails.fetchResultAfterChanges;
    if (changeDetails.hasIncrementalChanges)
        [self updateContentWithIncrementalChanges:changeDetails];
    else
        [self.tableView reloadData];
}

- (void)updateContentWithIncrementalChanges:(PHFetchResultChangeDetails *)changeDetails {
    [self.tableView beginUpdates];

    NSIndexSet *removed = changeDetails.removedIndexes;
    if (removed.count)
        [self.tableView deleteRowsAtIndexPaths:[self indexPathsFromIndexSet:removed]
                              withRowAnimation:UITableViewRowAnimationFade];

    NSIndexSet *inserted = changeDetails.insertedIndexes;
    if (inserted.count)
        [self.tableView insertRowsAtIndexPaths:[self indexPathsFromIndexSet:inserted]
                              withRowAnimation:UITableViewRowAnimationFade];

    NSIndexSet *changed = changeDetails.changedIndexes;
    if (changed.count)
        [self.tableView reloadRowsAtIndexPaths:[self indexPathsFromIndexSet:changed]
                              withRowAnimation:UITableViewRowAnimationFade];

    if (changeDetails.hasMoves)
        [changeDetails enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
            [self.tableView moveRowAtIndexPath:fromIndexPath
                                   toIndexPath:toIndexPath];
        }];

    [self.tableView endUpdates];
}

- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)set {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx
                                                 inSection:0]];
    }];
    return indexPaths;
}

#pragma mark - operations

- (NSMutableDictionary *)operations {
    if (_operations)
        return _operations;
    _operations = [[NSMutableDictionary alloc] init];
    return _operations;
}

- (NSOperationQueue *)operationQueue {
    if (_operationQueue)
        return _operationQueue;
    _operationQueue = [[NSOperationQueue alloc] init];
    return _operationQueue;
}

@end
