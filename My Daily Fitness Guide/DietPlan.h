//
//  DietPlan.h
//  My Daily Fitness Guide
//
//  Created by yogesh on 22/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DietPlan : NSObject {
    NSString *wlVeg1Diet, *wlVeg2Diet, *wlVeg3Diet, *wlVeg4Diet, *wlVeg5Diet, *wlVeg6Diet, *wlVeg7Diet, *wlVeg8Diet, *wlVeg9Diet, *wlVeg10Diet, *wlVeg11Diet, *wlVeg12Diet, *wlVeg13Diet, *wlVeg14Diet, *wlVeg15Diet;
    
    NSString *wlNonVeg1Diet, *wlNonVeg2Diet, *wlNonVeg3Diet, *wlNonVeg4Diet, *wlNonVeg5Diet, *wlNonVeg6Diet, *wlNonVeg7Diet, *wlNonVeg8Diet, *wlNonVeg9Diet, *wlNonVeg10Diet, *wlNonVeg11Diet, *wlNonVeg12Diet, *wlNonVeg13Diet, *wlNonVeg14Diet, *wlNonVeg15Diet;
    
    NSString *wgVeg1Diet, *wgVeg2Diet, *wgVeg3Diet, *wgVeg4Diet, *wgVeg5Diet, *wgVeg6Diet, *wgVeg7Diet, *wgVeg8Diet, *wgVeg9Diet, *wgVeg10Diet, *wgVeg11Diet, *wgVeg12Diet, *wgVeg13Diet, *wgVeg14Diet, *wgVeg15Diet;
    
    NSString *wgNonVeg1Diet, *wgNonVeg2Diet, *wgNonVeg3Diet, *wgNonVeg4Diet, *wgNonVeg5Diet, *wgNonVeg6Diet, *wgNonVeg7Diet, *wgNonVeg8Diet, *wgNonVeg9Diet, *wgNonVeg10Diet, *wgNonVeg11Diet, *wgNonVeg12Diet, *wgNonVeg13Diet, *wgNonVeg14Diet, *wgNonVeg15Diet;
    
    NSMapTable *vegGainMap, *nonVegGainMap, *vegLossMap, *nonVegLossMap;
}

-(id)initialize;
-(NSString *)getDiet;

@end
