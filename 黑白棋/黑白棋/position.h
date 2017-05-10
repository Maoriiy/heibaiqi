//
//  position.h
//  黑白棋
//
//  Created by jackey on 17/4/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface position : NSObject

@property(nonatomic,assign) int posX;
@property(nonatomic,assign) int posY;

-(instancetype)initWithposX:(int)x posY:(int)y;
+(instancetype)positionWithposX:(int)x posY:(int)y;

@end
