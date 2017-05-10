//
//  chessbtn.h
//  黑白棋
//
//  Created by jackey on 17/4/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class position;

typedef enum {
    ChessEmpty = 0,
    ChessSelectBlack,
    ChessSelectWhite,
    ChessBlack,
    ChessWhite,
} ChessStatus;

@interface chessbtn : UIButton

@property(nonatomic,strong) position *pos;
@property(nonatomic,assign) ChessStatus status;

-(instancetype)initWithPosition:(position *) pos;
+(instancetype)chessbtnWithPosition:(position *)pos;


@end
