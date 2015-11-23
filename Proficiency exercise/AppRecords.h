//
//  AppRecords.h
//  Proficiency exercise
//
//  Created by Kartheek P. on 23/11/15.
//  Copyright (c) 2015 Kartheek P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppRecords : NSObject
{
    NSString *mTitleName;
    UIImage *mImageIcon;
    NSString *mDescription;
    NSString *mImageURLString;
}
@property (nonatomic, strong) NSString *mTitleName;
@property (nonatomic, strong) UIImage *mImageIcon;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *mDescription;
@property (nonatomic, strong) NSString *mImageURLString;

@end
