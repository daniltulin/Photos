//
//  AlbumTableViewCell.h
//  Photos
//
//  Created by Danil Tulin on 11/16/16.
//  Copyright © 2016 Daniil Tulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

static NSString *ALBUM_CELL_ID = @"albumcellid";

@interface AlbumCell : UITableViewCell

@property (nonatomic) PHAssetCollection *assetCollection;

@end
