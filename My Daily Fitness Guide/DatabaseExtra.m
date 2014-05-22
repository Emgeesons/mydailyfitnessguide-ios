//
//  DatabaseExtra.m
//  Hinduja
//
//  Created by yogesh on 25/03/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "DatabaseExtra.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DatabaseExtra
+(NSString *)dbPath {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"my_daily_fitness.sqlite"];
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (BOOL)nameValidationWithSpace:(UITextField *)textField {
    NSString *emailRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:textField.text];
    return isValid;
}

+ (BOOL)nameValidationWithoutSpace:(UITextField *)textField {
    NSString *emailRegex = @"[a-zA-z]+(['-][a-zA-Z]+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:textField.text];
    return isValid;
}

+ (BOOL)numberValidation:(UITextField *)textField {
    NSString *emailRegex = @"^([0-9]+)?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:textField.text];
    return isValid;
}

+(BOOL) isValidEmail:(UITextField *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString.text];
}

+ (NSInteger)getAge:(NSDate *)date {
    NSDate* birthday = date;
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    return [ageComponents year];
}

+ (NSString *)getUDID {
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    return [oNSUUID UUIDString];
}

+ (NSString *)trimString:(UITextField *)textField {
    NSString *string = textField.text;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}

- (BOOL)checkConnection {
    internetReachability = [Reachability reachabilityForInternetConnection];
	[internetReachability startNotifier];
    
    NetworkStatus netStatus = [internetReachability currentReachabilityStatus];
    BOOL connectionRequired = [internetReachability connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable:{
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:{
            connectionRequired = YES;
            break;
        }
        case ReachableViaWiFi:{
            connectionRequired = YES;
            break;
        }
    }
    
    return connectionRequired;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

+ (BOOL)removeFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    return success;
}

+ (NSString *)filterPhoneNumber:(NSString *)phoneNumber {
    NSString *unfilteredString = phoneNumber;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    NSMutableString *newString;
    
    if (resultString.length == 10) {
        newString = [NSMutableString stringWithFormat:@"0091%@", resultString];
    } else if (resultString.length == 12) {
        newString = [NSMutableString stringWithFormat:@"00%@", resultString];
    } else if (resultString.length == 11) {
        NSString *test = [[NSString alloc] initWithFormat:@"%@", resultString];
        test = [test stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"0091"];
        newString = [NSMutableString stringWithFormat:@"%@", test];
    } else {
        newString = [NSMutableString stringWithFormat:@"%@", resultString];
    }
    
    return newString;
}

+ (NSString *)getHHNO {
    FMDatabase *database = [FMDatabase databaseWithPath:[self dbPath]];
    NSString *hhno;
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT data FROM profile WHERE type = 'hhno'"];
    while([results next]) {
        hhno = [results stringForColumn:@"data"];
    }
    [database close];
    
    if ([hhno length] == 0) {
        hhno = @"0";
    };
    
    return hhno;
}

+ (void)errorInConnection {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Oops! something goes wrong." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+ (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSInteger) numberOfDaysBetween:(NSString *)start and:(NSString *)end {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return ([components day] + 1);
}

@end
