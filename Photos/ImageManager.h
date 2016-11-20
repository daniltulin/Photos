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

+ (instancetype)managerWithFetchResult:(AssetFetchResult *)fetchResult
                          andImageSize:(CGSize)imageSize;

- (void)fetchImageAtIndex:(NSInteger)index
              withHandler:(ImageResultHandler)handler;

- (void)cancelImageFetchingAtIndex:(NSInteger)index;

@end
