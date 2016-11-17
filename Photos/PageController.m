//
//  PageController.m
//  Photos
//
//  Created by Danil Tulin on 11/17/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "PageController.h"

@interface PageController ()

@end

@implementation PageController

- (instancetype)init {
    UIPageViewControllerTransitionStyle transitionStyle = UIPageViewControllerTransitionStyleScroll;
    UIPageViewControllerNavigationOrientation orientation =
    											UIPageViewControllerNavigationOrientationHorizontal;
    if (self = [super initWithTransitionStyle:transitionStyle
                        navigationOrientation:orientation
                                      options:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.hidesBarsOnTap = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnTap = NO;
}

- (void)setViewController:(UIViewController *)controller {
    [self setViewControllers:@[controller]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

@end
