//
//  TableViewCell.m
//  Proficiency exercise
//
//  Created by Kartheek P. on 23/11/15.
//  Copyright (c) 2015 Kartheek P. All rights reserved.
//

#import "TableViewCell.h"
#import "NullCheck.h"

#define GAP 6

@implementation TableViewCell
@synthesize mTitleLabel, mDescryptionLabel, mImageIcon, mLoadingView;

//////////////////// tableview cell programmatically ///////////////////////////////////////////////////////

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.mTitleLabel = [[UILabel alloc]init];
        self.mTitleLabel.textColor = [UIColor blueColor];
        self.mTitleLabel.font = [UIFont fontWithName:@"Arial" size:22.0f];
        [self addSubview:self.mTitleLabel];
        
        self.mDescryptionLabel = [[UILabel alloc] init];
        self.mDescryptionLabel.textColor = [UIColor blackColor];
        self.mDescryptionLabel.font = [UIFont fontWithName:@"Arial" size:15.0f];
        self.mDescryptionLabel.numberOfLines = 0;
        [self addSubview:self.mDescryptionLabel];
        self.mImageIcon =[[UIImageView alloc] init ];
        self.mImageIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.mImageIcon.clipsToBounds = YES;
        [self  addSubview: self.mImageIcon];
        
        self.mLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.mLoadingView startAnimating];
        self.mLoadingView.hidesWhenStopped = YES;
        [self addSubview: self.mLoadingView];
        
        
    }
    return self;
}

////////////////////////////////// set title lable text anf frame /////////////////

- (void) setTitleText : (NSString*) text {
    
    CGRect newFrame = self.mTitleLabel.frame;
    
    if (![[NullCheck checknull: text] isEqualToString:@""])
    {
        self.mTitleLabel.text = text;
        
        CGSize maximumLabelSize = CGSizeMake(self.mTitleLabel.frame.size.width, FLT_MAX);
    
        CGRect textRect = [text boundingRectWithSize:maximumLabelSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:self.mTitleLabel.font}
                                             context:nil];
        
         CGSize stringSize= textRect.size;
        newFrame.size.height = stringSize.height;
    }
    else
    {
        self.mTitleLabel.text = @"";
        
        newFrame.size.height = 0;
        
    }
    
    self.mTitleLabel.frame = newFrame;
    
    CGRect frame = self.mDescryptionLabel.frame;
    frame.origin.y = newFrame.origin.y + newFrame.size.height + GAP;
    self.mDescryptionLabel.frame = frame;
    
    CGRect iconFrame = self.mImageIcon.frame;
    iconFrame.origin.y = frame.origin.y;
    self.mImageIcon.frame = iconFrame;
}


////////////////////////////////// set Descryption text anf frame /////////////////
- (void) setDescryptionText : (NSString*) text {
    
    if (![[NullCheck checknull: text] isEqualToString:@""])
    {
        self.mDescryptionLabel.text = text;
    }
    else
    {
        self.mDescryptionLabel.text = @"";
        CGRect newFrame = self.mDescryptionLabel.frame;
        newFrame.size.height = 0;
        self.mDescryptionLabel.frame = newFrame;
        return;
    }
    
    CGSize maximumLabelSize = CGSizeMake(self.mDescryptionLabel.frame.size.width, FLT_MAX);

    CGRect textRect = [text boundingRectWithSize:maximumLabelSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:self.mDescryptionLabel.font}
                                         context:nil];
    
    CGRect newFrame = self.mDescryptionLabel.frame;
    CGSize stringSize= textRect.size;
    newFrame.size.height = stringSize.height;
    self.mDescryptionLabel.frame = newFrame;
}

////////////////////////////////// Get Image height /////////////////

- (float) getHeight : (NSString*) imageName {
    
    NSLog(@"ss%@ss\n ss%@ss\n ss%@ss", self.mTitleLabel.text, self.mDescryptionLabel.text, imageName);
    
    if(imageName.length > 0) {
        float height = self.mDescryptionLabel.frame.origin.y + self.mDescryptionLabel.frame.size.height + GAP + GAP;
        float height1 = self.mImageIcon.frame.origin.y + self.mImageIcon.frame.size.height + GAP + GAP;
        
        if(height > height1) {
            return height;
        }

        return height1;
        
    } else {
        return self.mDescryptionLabel.frame.origin.y + self.mDescryptionLabel.frame.size.height + GAP + GAP;
    }
}
@end
