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
    cell.assetCollection = self.fetchResult[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return THUMBNAIL_SIZE.height + 2*OFFSET;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *assetCollection = self.fetchResult[indexPath.row];
    PhotosController *controller = [PhotosController photosControllerWithAssetCollection:assetCollection];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - Fetch Result

- (PHFetchResult<PHAssetCollection *> *)fetchResult {
    if (_fetchResult)
        return _fetchResult;
    _fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                            subtype:PHAssetCollectionSubtypeAlbumRegular
                                                            options:nil];
    return _fetchResult;
}


@end
