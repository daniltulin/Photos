//
//  PreviewPhotoController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "PreviewController.h"

@interface PreviewController () <UIGestureRecognizerDelegate>

@property (nonatomic, readwrite) PHAsset *asset;
@property (nonatomic) UIImageView *imageView;

@property (nonatomic, readwrite) NSUInteger index;

@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic) PHImageRequestID requestID;

@end

@implementation PreviewController

+ (instancetype)previewControllerWithAsset:(PHAsset *)asset
                                  andIndex:(NSUInteger)index {
    PreviewController *controller = [[PreviewController alloc] init];
    controller.asset = asset;
    controller.index = index;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    
    self.imageView.frame = self.view.bounds;
    if (_indicatorView)
        self.indicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                                CGRectGetMidY(self.view.bounds));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.imageView.image == nil) {
        [self obtainImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.requestID)
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
}

- (void)obtainImage {
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    
    typedef void (^ImageSettingBlock)(NSData *imageData);
    ImageSettingBlock settingBlock = ^void(NSData *imageData) {
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
        _indicatorView = nil;
        
        self.imageView.image = [UIImage imageWithData:imageData];
    };
    
    ResultImageDataHandler resultHandler = ^void(NSData *imageData,
                                                 NSString *dataUTI,
                                                 UIImageOrientation orientation,
                                                 NSDictionary *info) {
        enqueueInMainQueue(^{
            settingBlock(imageData);
        });
    };
    
    self.requestID = [[PHImageManager defaultManager] requestImageDataForAsset:self.asset
                                                                       options:options
                                                                 resultHandler:resultHandler];
}

#pragma mark - Image View

- (UIImageView *)imageView {
    if (_imageView)
        return _imageView;
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    return _imageView;
}

#pragma mark - Indicator View

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView)
        return _indicatorView;
    
    _indicatorView = [[UIActivityIndicatorView alloc] init];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    return _indicatorView;
}

@end
