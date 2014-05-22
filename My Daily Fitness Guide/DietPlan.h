//
//  DietPlan.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 22/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DietPlan : NSObject {
    NSString *WGVeg1;
    NSMapTable *vegGainMap, *nonVegGainMap, *vegLossMap, *nonVegLossMap;
}

-(id)initialize;
-(NSString *)getDiet;

@end
