//
//  PageController.h
//  Photos
//
//  Created by Danil Tulin on 11/17/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageController : UIPageViewController

// Setting current View Controller
// Just calling setViewControllers: w/o animation
- (void)setViewController:(UIViewController *)controller;

@end
