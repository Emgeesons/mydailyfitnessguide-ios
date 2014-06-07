//
//  WeeklySchedule.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 27/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "WeeklySchedule.h"

@implementation WeeklySchedule {
    NSArray *weeklyBasic1, *weeklyBasic2, *weeklyIntermediate1, *weeklyIntermediate2NCOdd, *weeklyIntermediate2NCEven, *weeklyAdvance1, *weeklyAdvance2, *vacationFunctional1, *weeklyBasic2NC, *weeklyAdvance1NC, *functional1, *functional2, *vacation;
    NSString *programLevel, *vacationDate;
    NSInteger numberOfDays;
}

-(id)initialize {
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    int month = [self getMonth];
    NSString *dietType = [self getDietType];
    
    [self initializeAllArray];
    programLevel = [self getProgramLevel:month dietType:dietType];
    
    return self;
}

-(int)getMonth {
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
    NSString *startDate, *endDate;
    
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"start_date"]) {
            startDate = [results stringForColumn:@"value"];
        } else if ([[results stringForColumn:@"type"] isEqualToString:@"vacationDate"]) {
            vacationDate = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    endDate = [f stringFromDate:[NSDate date]];
    numberOfDays = [DatabaseExtra numberOfDaysBetween:startDate and:endDate];
    
    return (numberOfDays/30) + 1;
}

-(NSString *)getDietType {
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
    NSString *dietType;
    
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"programType"]) {
            dietType = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    return dietType;
}

-(NSArray *)getWeeklySchedule {
    NSArray *tmpArray;
    
    if ([vacationDate isEqualToString:@""] || vacationDate == NULL) {
        if ([programLevel isEqualToString:@"Basic 1"]) {
            tmpArray = weeklyBasic1;
        } else if ([programLevel isEqualToString:@"Basic 2 (No Cardio)"]) {
            tmpArray = weeklyBasic2NC;
        } else if ([programLevel isEqualToString:@"Intermediate 2 (No Cardio)"]) {
            //do based on odd and even week
            int numOfDays = numberOfDays % 30; // give you remaining of days
            int week = (numOfDays/7) + 1; // will give you week number
            if (week == 1 || week == 3) {
                tmpArray = weeklyIntermediate2NCOdd;
            } else {
                tmpArray = weeklyIntermediate2NCEven;
            }
        } else if ([programLevel isEqualToString:@"Advance 1 (No Cardio)"]) {
            tmpArray = weeklyAdvance1NC;
        } else if ([programLevel isEqualToString:@"Advance 2"]) {
            tmpArray = weeklyAdvance2;
        } else if ([programLevel isEqualToString:@"Functional Training 2"]) {
            tmpArray = functional2;
        } else if ([programLevel isEqualToString:@"Functional Training 1"]) {
            tmpArray = functional1;
        }
        
        else if ([programLevel isEqualToString:@"Basic 2"]) {
            tmpArray = weeklyBasic2;
        } else if ([programLevel isEqualToString:@"Intermediate 1"]) {
            tmpArray = weeklyIntermediate1;
        } else if ([programLevel isEqualToString:@"Advance 1"]) {
            tmpArray = weeklyAdvance1;
        }
    } else {
        // vacation time
        tmpArray = vacation;
    }
    
    return tmpArray;
}

-(NSString *)getProgramLevel:(int)month dietType:(NSString *)dietType {
    NSString *type;
    if ([dietType isEqualToString:@"weightGain"]) {
        month = month % 8;
        //NSLog(@"%d", month);
        if (month == 1) {
            type = @"Basic 1";
        } else if (month == 2) {
            type = @"Basic 2 (No Cardio)";
        } else if (month == 3) {
            type = @"Intermediate 1";
        } else if (month == 4) {
            type = @"Intermediate 2 (No Cardio)";
        } else if (month == 5) {
            type = @"Advance 1 (No Cardio)";
        } else if (month == 6) {
            type = @"Advance 2";
        } else if (month == 7) {
            type = @"Functional Training 2";
        } else if (month == 8) {
            type = @"Functional Training 1";
        }
    } else {
        // for weightLoss
        if (month == 1) {
            type = @"Basic 1";
        } else if (month == 2) {
            type = @"Basic 2";
        } else if (month == 3) {
            type = @"Basic 2";
        } else if (month == 4) {
            type = @"Intermediate 1";
        } else if (month == 5) {
            type = @"Intermediate 1";
        } else if (month == 6) {
            type = @"Intermediate 1";
        } else if (month == 7) {
            type = @"Advance 1";
        } else if (month == 8) {
            type = @"Advance 1";
        } else if (month == 9) {
            type = @"Advance 1";
        } else if (month == 10) {
            type = @"Advance 2";
        } else if (month == 11) {
            type = @"Advance 2";
        } else if (month == 12) {
            type = @"Functional Training 2";
        } else {
            type = @"Functional Training 1";
        }
    }
    return type;
}

-(void)initializeAllArray {
    weeklyBasic1 = @[@"Cardio", @"Whole Body Resistance Training", @"Rest", @"Cardio", @"Whole Body Resistance Training", @"Cardio", @"Rest", @"Basic 1"];
    
    weeklyBasic2 = @[@"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Cardio & Abs", @"Rest", @"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Cardio / Rest", @"Basic 2"];
    
    weeklyAdvance1 = @[@"Lower Body Resistance Training (Legs)", @"Rest", @"Upper Body Resistance Training (back)", @"Cardio & Abs/ Core", @"Upper Body Resistance Training (Chest + Biceps)", @"Rest", @"Upper Body Resistance Training (Shoulder + Triceps)", @"Advance 1"];
    
    weeklyAdvance2 = @[@"Lower Body Resistance Training (Legs)", @"Rest", @"Upper Body Resistance Training (back)", @"Cardio & Abs/ Core", @"Upper Body Resistance Training (Chest + Biceps)", @"Rest", @"Upper Body Resistance Training (Shoulder + Triceps)", @"Advance 2"];
    
    weeklyIntermediate1 = @[@"Lower Body Resistance Training", @"Upper Body Resistance Training (Back + Biceps)", @"Cardio & Core (Abs)", @"Rest", @"Upper Body Resistance Training (Chest + Shoulder + Triceps)", @"Cardio & Core (Abs)", @"Rest", @"Intermediate 1"];
    
    //vacationFunctional1 = @[@"Exercise", @"Rest", @"Exercise", @"Rest", @"Exercise", @"Cardio", @"Rest"];
    
    weeklyBasic2NC = @[@"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Abs", @"Rest", @"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Rest", @"Basic 2 (No Cardio)"];
    
    weeklyAdvance1NC = @[@"Lower Body Resistance Training (Legs)", @"Rest", @"Upper Body Resistance Training (back)", @"Abs/ Core", @"Upper Body Resistance Training (Chest + Biceps)", @"Rest", @"Upper Body Resistance Training (Shoulder + Triceps)", @"Advance 1 (No Cardio)"];
    
    functional1 = @[@"Exercise", @"Rest", @"Exercise", @"Rest", @"Exercise", @"Cardio", @"Rest", @"Functional Training 1"];
    
    functional2 = @[@"Exercise", @"Rest", @"Exercise", @"Rest", @"Exercise", @"Cardio", @"Rest", @"Functional Training 2"];
    
    weeklyIntermediate2NCOdd = @[@"Chest, Shoulders & Triceps + Quads & Calves", @"Rest", @"Back & Biceps + Hamstrings & Abs", @"Rest", @"Chest, Shoulders & Triceps + Quads & Calves", @"Rest", @"Rest", @"Intermediate 2 (No Cardio)"];
    
    weeklyIntermediate2NCEven = @[@"Back & Biceps + Hamstrings & Abs", @"Rest", @"Chest, Shoulders & Triceps + Quads & Calves", @"Rest", @"Back & Biceps + Hamstrings & Abs", @"Rest", @"Rest", @"Intermediate 2 (No Cardio)"];
    
    vacation = @[@"Exercise", @"Rest", @"Exercise", @"Rest", @"Exercise", @"Cardio", @"Rest", @"vacation"];
}

-(NSArray *)getMonthlyScheduleWithMonthNumber:(NSInteger)monthNo {
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
    NSString *startDate, *endDate;
    
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"start_date"]) {
            startDate = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    endDate = [f stringFromDate:[NSDate date]];
    int days = [DatabaseExtra numberOfDaysBetween:startDate and:endDate];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    int month = [self getMonth];
    NSString *dietType = [self getDietType];
    
    [self initializeAllArray];
    
    // For month
    for (int i = 1; i < (month + 1); i++) {
        // For week 1-4
        for (int j = 1; j < 5; j++) {
            NSArray *tmpArray = [self getProgramLevel:month withWeek:1 dietType:dietType];
            // For number of items present in array
            for (int k = 0; k < (tmpArray.count - 1); k++) {
                [array addObject:tmpArray[k]];
            }
            [array addObject:array[0]];
            [array addObject:array[1]];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    NSString *dayName = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@", dayName);
    
    if ([dayName isEqualToString:@"Mon"]) {
        // remove 1
        [array removeObjectsInRange:NSMakeRange(0, 1)];
    } else if ([dayName isEqualToString:@"Tue"]) {
        // remove 2
        [array removeObjectsInRange:NSMakeRange(0, 2)];
    } else if ([dayName isEqualToString:@"Wed"]) {
        // remove 3
        [array removeObjectsInRange:NSMakeRange(0, 3)];
    } else if ([dayName isEqualToString:@"Thu"]) {
        // remove 4
        [array removeObjectsInRange:NSMakeRange(0, 4)];
    } else if ([dayName isEqualToString:@"Fri"]) {
        // remove 5
        [array removeObjectsInRange:NSMakeRange(0, 5)];
    } else if ([dayName isEqualToString:@"Sat"]) {
        // remove 6
        [array removeObjectsInRange:NSMakeRange(0, 6)];
    }
    
    // remove any additional days which goes beyond 29 days
    if (days > 30) {
        int remainderDays = days % 30;
        [array removeObjectsInRange:NSMakeRange(array.count - remainderDays, remainderDays)];
        //NSLog(@"%d", (array.count - remainderDays));
    }
    
    return array;
}

-(NSArray *)getProgramLevel:(int)month withWeek:(NSInteger)week dietType:(NSString *)dietType {
    NSArray *tmpArray;
    if ([vacationDate isEqualToString:@""] || vacationDate == NULL) {
        if ([dietType isEqualToString:@"weightGain"]) {
            month = month % 8;
            //NSLog(@"%d", month);
            if (month == 1) {
                tmpArray = weeklyBasic1;
            } else if (month == 2) {
                tmpArray = weeklyBasic2NC;
            } else if (month == 3) {
                tmpArray = weeklyIntermediate1;
            } else if (month == 4) {
                if (week == 1 || week == 3) {
                    tmpArray = weeklyIntermediate2NCOdd;
                } else {
                    tmpArray = weeklyIntermediate2NCEven;
                }
            } else if (month == 5) {
                tmpArray = weeklyAdvance1NC;
            } else if (month == 6) {
                tmpArray = weeklyAdvance2;
            } else if (month == 7) {
                tmpArray = functional2;
            } else if (month == 8) {
                tmpArray = functional1;
            }
        } else {
            // for weightLoss
            if (month == 1) {
                tmpArray = weeklyBasic1;
            } else if (month == 2) {
                tmpArray = weeklyBasic2;
            } else if (month == 3) {
                tmpArray = weeklyBasic2;
            } else if (month == 4) {
                tmpArray = weeklyIntermediate1;
            } else if (month == 5) {
                tmpArray = weeklyIntermediate1;
            } else if (month == 6) {
                tmpArray = weeklyIntermediate1;
            } else if (month == 7) {
                tmpArray = weeklyAdvance1;
            } else if (month == 8) {
                tmpArray = weeklyAdvance1;
            } else if (month == 9) {
                tmpArray = weeklyAdvance1;
            } else if (month == 10) {
                tmpArray = weeklyAdvance2;
            } else if (month == 11) {
                tmpArray = weeklyAdvance2;
            } else if (month == 12) {
                tmpArray = functional2;
            } else {
                tmpArray = functional1;
            }
        }
    } else {
        // vacation time
        tmpArray = vacation;
    }
    return tmpArray;
}

@end
