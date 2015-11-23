//
//  TableViewCell.h
//  Proficiency exercise
//
//  Created by Kartheek P. on 23/11/15.
//  Copyright (c) 2015 Kartheek P. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TableViewCell : UITableViewCell
{
    UILabel *mTitleLabel,*mDescryptionLabel;
    UIImageView *mImageIcon;
    UIActivityIndicatorView* mLoadingView;
}
@property (nonatomic,strong)  UILabel *mTitleLabel,*mDescryptionLabel;
@property (nonatomic,strong)  UIImageView *mImageIcon;
@property (nonatomic,strong)  UIActivityIndicatorView* mLoadingView;


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setTitleText : (NSString*) text;
- (void) setDescryptionText : (NSString*) text;
- (float) getHeight : (NSString*) imageName;

@end
