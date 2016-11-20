//
//  ImageManager.m
//  Photos
//
//  Created by Danil Tulin on 11/19/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "ImageManager.h"

@interface ImageManager ()

@property (nonatomic) AssetFetchResult *fetchResult;
@property (nonatomic) CGSize imageSize;

@end

@implementation ImageManager

+ (instancetype)managerWithFetchResult:(AssetFetchResult *)fetchResult
                          andImageSize:(CGSize)imageSize {
    ImageManager *manager = [[ImageManager alloc] init];
    manager.fetchResult = fetchResult;
    manager.imageSize = imageSize;
    return manager;
}

- (void)fetchImageAtIndex:(NSInteger)index
              withHandler:(ImageResultHandler)handler {
    
}

- (void)cancelImageFetchingAtIndex:(NSInteger)index {
    
}

@end
