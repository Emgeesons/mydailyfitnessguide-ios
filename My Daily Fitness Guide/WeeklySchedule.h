//
//  WeeklySchedule.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 27/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeeklySchedule : NSObject {
    FMDatabase *database;
}

-(id)initialize;
-(NSArray *)getWeeklySchedule;
-(NSString *)getProgramLevel:(int)month dietType:(NSString *)dietType;
-(int)getMonth;
-(NSString *)getDietType;

-(NSArray *)getMonthlyScheduleWithMonthNumber:(NSInteger)monthNo;

@end
