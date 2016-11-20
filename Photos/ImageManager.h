//
//  ImageManager.h
//  Photos
//
//  Created by Danil Tulin on 11/19/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageResultHandler)(UIImage *image);

@interface ImageManager : NSObject

+ (instancetype)managerWithAssets:(NSArray *)assets
                     andImageSize:(CGSize)targetSize;

- (void)fetchImageAtIndex:(NSInteger)index
              withHandler:(ImageResultHandler)handler;

// In case if you need bigger size image than you specified
// in constructor
- (void)fetchImageAtIndex:(NSInteger)index
           withTargetSize:(CGSize)targetSize
               andHandler:(ImageResultHandler)handler;

- (void)cancelImageFetchingAtIndex:(NSInteger)index;

@end
