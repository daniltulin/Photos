//
//  ImageManager.m
//  Photos
//
//  Created by Danil Tulin on 11/19/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "ImageManager.h"

@interface ImageManager ()

@property (nonatomic) PHImageManager *manager;

@property (nonatomic) NSArray *assets;
@property (nonatomic) CGSize targetSize;

@property (nonatomic) PHImageContentMode contentMode;
@property (nonatomic) PHImageRequestOptions *options;

@property (nonatomic) NSMutableDictionary *requests;

@end

@implementation ImageManager

+ (instancetype)managerWithAssets:(NSArray *)assets
                     andImageSize:(CGSize)targetSize {
    ImageManager *manager = [[ImageManager alloc] init];
    manager.assets = assets;
    manager.targetSize = targetSize;
    return manager;
}

- (void)fetchImageAtIndex:(NSInteger)index
              withHandler:(ImageResultHandler)handler {
    [self fetchImageAtIndex:index
             withTargetSize:self.targetSize
                 andHandler:handler];
}

- (void)fetchImageAtIndex:(NSInteger)index
           withTargetSize:(CGSize)targetSize
               andHandler:(ImageResultHandler)handler {
    NSNumber *identifier = [NSNumber numberWithInteger:index];
    if (self.requests[identifier])
        return;
    
    PHAsset *asset = self.assets[index];
    ResultHandler resultHandler = ^(UIImage *result,
                                    NSDictionary *info){
        [self.requests removeObjectForKey:identifier];
        if ([info[PHImageCancelledKey] boolValue])
            return;
        if (info[PHImageErrorKey]) {
            NSLog(@"Error was occured: %@", info[PHImageErrorKey]);
            return;
        }
        handler(result);
    };
    ResultHandler resultHandlerWrapper = ^(UIImage *result,
                                          NSDictionary *info) {
        executeInMain(^{
            resultHandler(result, info);
        });
    };
    
    PHImageRequestID requestID = [self.manager requestImageForAsset:asset
                                                         targetSize:targetSize
                                                        contentMode:self.contentMode
                                                            options:self.options
                                                      resultHandler:resultHandlerWrapper];
    self.requests[identifier] = [NSNumber numberWithInteger:requestID];
}

- (void)cancelImageFetchingAtIndex:(NSInteger)index {
    NSNumber *identifier = [NSNumber numberWithInteger:index];
    NSNumber *request = self.requests[identifier];
    if (request != nil) {
        [self.requests removeObjectForKey:identifier];
        [self.manager cancelImageRequest:[request intValue]];
    }
}

#pragma mark - requests

- (NSMutableDictionary *)requests {
    if (_requests)
        return _requests;
    _requests = [[NSMutableDictionary alloc] init];
    return _requests;
}

#pragma mark - PHCachingImageManager

- (PHImageManager *)manager {
    if (_manager)
        return _manager;
    _manager = [PHImageManager defaultManager];
    return _manager;
}

#pragma mark - Parameteres

- (PHImageContentMode)contentMode {
    return PHImageContentModeAspectFit;
}

- (PHImageRequestOptions *)options {
    if (_options)
        return _options;
    _options = [[PHImageRequestOptions alloc] init];
    _options.resizeMode = PHImageRequestOptionsResizeModeFast;
    _options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    _options.networkAccessAllowed = YES;
    return _options;
}

@end
