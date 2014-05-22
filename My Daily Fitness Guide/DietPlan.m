//
//  DietPlan.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 22/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "DietPlan.h"

@implementation DietPlan

-(id)initialize {
    vegGainMap = [[NSMapTable alloc] init];
    nonVegGainMap = [[NSMapTable alloc] init];
    vegLossMap = [[NSMapTable alloc] init];
    nonVegLossMap = [[NSMapTable alloc] init];
    
    [self setDietPlan];
    [self addDietToMap];
    
    return self;
}

-(NSString *)getDiet{
    FMDatabase *database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
    NSString *mealPreferance, *startDate, *dietType, *tmp, *week;
    
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"vegNonveg"]) {
            mealPreferance = [results stringForColumn:@"value"];
        } else if ([[results stringForColumn:@"type"] isEqualToString:@"start_date"]) {
            startDate = [results stringForColumn:@"value"];
        } else if ([[results stringForColumn:@"type"] isEqualToString:@"programType"]) {
            dietType = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString *endDate = [f stringFromDate:[NSDate date]];
    NSInteger numberOfDays = [DatabaseExtra numberOfDaysBetween:startDate and:endDate];
    int tmpWeek = numberOfDays/7;
    
    if ((numberOfDays % 7) == 0) {
        // current week
        week = [NSString stringWithFormat:@"%d", tmpWeek];
    } else {
        // show next week
        week = [NSString stringWithFormat:@"%d", (tmpWeek + 1)];
    }
    
    //NSLog(@"%@", week);
    
    if ([dietType isEqualToString:@"weightGain"]) {
        if ([mealPreferance isEqualToString:@"veg"]) {
            tmp = [vegGainMap objectForKey:week];
        } else {
            tmp = [nonVegGainMap objectForKey:week];
        }
    } else {
        if ([mealPreferance isEqualToString:@"veg"]) {
            tmp = [vegLossMap objectForKey:week];
        } else {
            tmp = [nonVegLossMap objectForKey:week];
        }
    }
    
    
    return tmp;
}

-(void)addDietToMap {
    [vegGainMap setObject:WGVeg1 forKey:@"1"];
}

-(void)setDietPlan {
    WGVeg1 = @"";
}

@end
