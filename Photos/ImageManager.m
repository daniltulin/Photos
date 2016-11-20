//
//  ImageManager.m
//  Photos
//
//  Created by Danil Tulin on 11/19/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "ImageManager.h"

@interface ImageManager ()

@property (nonatomic) NSArray *assets;
@property (nonatomic) CGSize imageSize;

@end

@implementation ImageManager

+ (instancetype)managerWithAssets:(NSArray *)assets
                     andImageSize:(CGSize)imageSize {
    ImageManager *manager = [[ImageManager alloc] init];
    manager.assets = assets;
    manager.imageSize = imageSize;
    return manager;
}

- (void)fetchImageAtIndex:(NSInteger)index
              withHandler:(ImageResultHandler)handler {
    
}

- (void)fetchImageAtIndex:(NSInteger)index
           withTargetSize:(CGSize)targetSize
               andHandler:(ImageResultHandler)handler {
    
}

- (void)cancelImageFetchingAtIndex:(NSInteger)index {
    
}

@end
