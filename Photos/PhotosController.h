//
//  PhotosController.h
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

@interface PhotosController : UICollectionViewController

+ (instancetype)photosControllerWithAssetCollection:(PHAssetCollection *)assetCollection;

@end
