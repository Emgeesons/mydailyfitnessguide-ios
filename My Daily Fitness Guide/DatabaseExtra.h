//
//  DatabaseExtra.h
//  Hinduja
//
//  Created by yogesh on 25/03/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <sys/utsname.h>

@interface DatabaseExtra : NSObject {
    Reachability *internetReachability;
}

+ (NSString *)dbPath;
+ (NSString *) md5:(NSString *) input;
+ (BOOL)nameValidationWithSpace:(UITextField *)textField;
+ (BOOL)nameValidationWithoutSpace:(UITextField *)textField;
+ (BOOL)numberValidation:(UITextField *)textField;
+ (BOOL) isValidEmail:(UITextField *)emailString Strict:(BOOL)strictFilter;
+ (NSInteger)getAge:(NSDate *)date;
+ (NSString *)getUDID;
+ (NSString *)trimString:(UITextField *)textField;
- (BOOL)checkConnection;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (UIImage *) getImageFromURL:(NSString *)fileURL;
+ (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
+ (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+ (BOOL)removeFile:(NSString *)fileName;
+ (NSString *)filterPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)getHHNO;

+ (void)errorInConnection;
+ (NSString *)getDeviceName;

+ (NSInteger) numberOfDaysBetween:(NSString *)startDate and:(NSString *)endDate;

+ (CAGradientLayer *) setGradietColourForView:(UIView *)view;

@end
