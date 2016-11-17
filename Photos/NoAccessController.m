//
//  NoAccessControllerViewController.m
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "NoAccessController.h"

@interface NoAccessController ()

@property (nonatomic) UILabel *label;

@end

@implementation NoAccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview: self.label];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.label.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                    CGRectGetMidY(self.view.bounds));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - label

- (UILabel *)label {
    if (_label)
        return _label;
    
    _label = [[UILabel alloc] init];
    _label.text = NSLocalizedString(@"No access to photos", @"");
    _label.textColor = [UIColor blackColor];
    [_label sizeToFit];
    
    return _label;
}

@end
