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
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    ResultImageDataHandler resultHandler = ^void(NSData *imageData,
                                       			 NSString *dataUTI,
                                       			 UIImageOrientation orientation,
                                       			 NSDictionary *info) {
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
        _indicatorView = nil;
        
        self.imageView.image = [UIImage imageWithData:imageData];
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset
                                                      options:options
                                                resultHandler:resultHandler];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageView.frame = self.view.bounds;
    if (_indicatorView)
        self.indicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                                CGRectGetMidY(self.view.bounds));
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
