//
//  UIColor+Extra.h
//  Hinduja
//
//  Created by yogesh on 20/03/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extra)

+ (UIColor *)colorWithHexString:(NSString *)colorString;
+ (UIColor *)colorWithHexValue:(int)hexValue;

@end
