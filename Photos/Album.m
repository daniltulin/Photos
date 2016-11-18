//
//  Album.m
//  Photos
//
//  Created by Danil Tulin on 11/17/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "Album.h"

@interface Album ()

@property (nonatomic, copy, readwrite) NSString *localIdentifier;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSUInteger count;

@end

@implementation Album

+ (instancetype)albumWithName:(NSString *)name
                        count:(NSUInteger)count
                   identifier:(NSString *)localIdentifier {
    Album *album = [[Album alloc] init];
    album.name = name;
    album.count = count;
    album.localIdentifier = localIdentifier;
    return album;
}

@end
