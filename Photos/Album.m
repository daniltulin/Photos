//
//  Album.m
//  Photos
//
//  Created by Danil Tulin on 11/17/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import "Album.h"

@interface Album ()

@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSUInteger count;
@property (nonatomic, readwrite) UIImage *thumbnail;

@end

@implementation Album

+ (instancetype)albumWithName:(NSString *)name
                        count:(NSUInteger)count
                    thumbnail:(UIImage *)thumbnail {
    Album *album = [[Album alloc] init];
    album.name = name;
    album.count = count;
    album.thumbnail = thumbnail;
    return album;
}

@end
