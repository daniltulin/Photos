//
//  Album.h
//  Photos
//
//  Created by Danil Tulin on 11/17/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

+ (instancetype)albumWithName:(NSString *)name
                        count:(NSUInteger)count
                   identifier:(NSString *)localIdentifier;

@property (nonatomic, copy, readonly) NSString *localIdentifier;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSUInteger count;

@end
