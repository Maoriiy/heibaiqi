//
//  position.m
//  黑白棋
//
//  Created by jackey on 17/4/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "position.h"

@implementation position

-(instancetype)initWithposX:(int)x posY:(int)y {
    if (self = [super init]) {
        self.posX = x;
        self.posY = y;
    }
    return self;
}

+(instancetype)positionWithposX:(int)x posY:(int)y {
    return [[self alloc] initWithposX:x posY:y];
}

@end
