//
//  TESTStatic.m
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2016/11/25.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

#import "TESTStatic.h"

static int a = 1;

@interface TESTStatic (){
}

@end

@implementation TESTStatic

- (instancetype)init
{
    self = [super init];
    if (self) {
        a = 2;
    }
    return self;
}

@end
