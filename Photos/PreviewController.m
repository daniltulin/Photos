//
//  PreviewPhotoController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "PreviewController.h"

@interface PreviewController ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic, readwrite) NSUInteger index;

@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation PreviewController

+ (instancetype)previewControllerWithIndex:(NSUInteger)index {
    PreviewController *controller = [[PreviewController alloc] init];
    controller.index = index;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    if (self.previewImage == nil &&
        self.indicatorView.superview == nil) {
    	[self.view addSubview:self.indicatorView];
    	[self.indicatorView startAnimating];
    }
}

- (void)setPreviewImage:(UIImage *)previewImage {
    _previewImage = previewImage;
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    _indicatorView = nil;
    self.imageView.image = previewImage;
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
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    return _indicatorView;
}

@end
