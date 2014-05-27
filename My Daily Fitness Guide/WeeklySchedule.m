//
//  WeeklySchedule.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 27/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "WeeklySchedule.h"

@implementation WeeklySchedule {
    NSArray *weeklyBasic1, *weeklyBasic2, *weeklyIntermediate1, *weeklyIntermediate2NCOdd, *weeklyIntermediate2NCEven, *weeklyAdvance1, *weeklyAdvance2, *vacationFunctional1, *weeklyBasic2NC, *weeklyAdvance1NC, *functional1, *functional2;
    NSString *programLevel;
    NSInteger numberOfDays;
}


-(id)initialize {
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT value,type FROM fitnessMainData"];
    NSString *startDate, *dietType, *endDate;
    
    while([results next]) {
        if ([[results stringForColumn:@"type"] isEqualToString:@"start_date"]) {
            startDate = [results stringForColumn:@"value"];
        } else if ([[results stringForColumn:@"type"] isEqualToString:@"programType"]) {
            dietType = [results stringForColumn:@"value"];
        }
    }
    [database close];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    endDate = [f stringFromDate:[NSDate date]];
    numberOfDays = [DatabaseExtra numberOfDaysBetween:startDate and:endDate];
    
    int month = (numberOfDays/30) + 1;
    
    [self initializeAllArray];
    programLevel = [self getProgramLevel:month dietType:dietType];
    
    return self;
}

-(NSArray *)getWeeklySchedule {
    NSArray *tmpArray;
    
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
    }else if ([programLevel isEqualToString:@"Intermediate 1"]) {
        tmpArray = weeklyIntermediate1;
    }else if ([programLevel isEqualToString:@"Advance 1"]) {
        tmpArray = weeklyAdvance1;
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
    weeklyBasic1 = @[@"Cardio", @"Whole Body Resistance Training", @"Rest", @"Cardio", @"Whole Body Resistance Training", @"Cardio", @"Rest"];
    
    weeklyBasic2 = @[@"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Cardio & Abs", @"Rest", @"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Cardio / Rest"];
    
    weeklyAdvance1 = @[@"Lower Body Resistance Training (Legs)", @"Rest", @"Upper Body Resistance Training (back)", @"Cardio & Abs/ Core", @"Upper Body Resistance Training (Chest + Biceps)", @"Rest", @"Upper Body Resistance Training (Shoulder + Triceps)"];
    
    weeklyAdvance2 = [NSArray arrayWithArray:weeklyAdvance1];
    
    vacationFunctional1 = @[@"Exercise", @"Rest", @"Exercise", @"Rest", @"Exercise", @"Cardio", @"Rest"];
    
    weeklyBasic2NC = @[@"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Abs", @"Rest", @"Lower Body Resistance Training", @"Upper Body Resistance Training", @"Rest"];
    
    weeklyAdvance1NC = @[@"Lower Body Resistance Training (Legs)", @"Rest", @"Upper Body Resistance Training (back)", @"Abs/ Core", @"Upper Body Resistance Training (Chest + Biceps)", @"Rest", @"Upper Body Resistance Training (Shoulder + Triceps)"];
    
    functional1 = @[@"Exercise", @"Rest", @"Exercise", @"Rest", @"Exercise", @"Cardio", @"Rest"];
    
    functional2 = [NSArray arrayWithArray:functional1];
    
    weeklyIntermediate2NCOdd = @[@"Chest, Shoulders & Triceps + Quads & Calves", @"Rest", @"Back & Biceps + Hamstrings & Abs", @"Rest", @"Chest, Shoulders & Triceps + Quads & Calves", @"Rest", @"Rest"];
    
    weeklyIntermediate2NCEven = @[@"Back & Biceps + Hamstrings & Abs", @"Rest", @"Chest, Shoulders & Triceps + Quads & Calves", @"Rest", @"Back & Biceps + Hamstrings & Abs", @"Rest", @"Rest"];
}

@end
