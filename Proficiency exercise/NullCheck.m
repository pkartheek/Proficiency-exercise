//
//  NullCheck.m
//  Proficiency exercise
//
//  Created by Kartheek P. on 23/11/15.
//  Copyright (c) 2015 Kartheek P. All rights reserved.
//

#import "NullCheck.h"

@implementation NullCheck

////// check null type ////////////////

+ (NSString *)checknull :(NSString *)value
{
    if (value ==nil)
    {
        return @"";
    }
    
   else if ([value isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    else if ([value isEqualToString:@""])
    {
        return @"";
    }
    else
    {
        return value;
    }
}

////// calculating the row height///////////////////////////////////////////////////

+(float) calculte_height: (float)width :(NSString *)str_desc
{
    
    CGRect textRect = [str_desc boundingRectWithSize:CGSizeMake(width, 1000)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                                        context:nil];
    
    CGSize stringSize= textRect.size;

    return stringSize.height;
    
}


@end
