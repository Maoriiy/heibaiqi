//
//  chessbtn.m
//  黑白棋
//
//  Created by jackey on 17/4/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "chessbtn.h"
#import "position.h"

@interface chessbtn()

@property(nonatomic,strong) UIImageView *image;

@end

@implementation chessbtn

-(instancetype)initWithPosition:(position *)pos {
    if (self = [super init]) {
        CGFloat btnW = 50;
        CGFloat btnH = btnW;
        CGFloat btnX = btnW * pos.posX + 7;
        CGFloat btnY = btnH * pos.posY + 7;
        self.frame = CGRectMake(btnX, btnY, btnW, btnH);
        self.pos = pos;

        self.image = [[UIImageView alloc] initWithFrame:self.bounds];
        self.status = ChessEmpty;
        [self addSubview:self.image];
       // [self.imageView setImage:[UIImage imageNamed:@"ChessStatusWhite"]];
//        self.backgroundColor = [UIColor brownColor];
    }
    return self;
}

-(void)setStatus:(ChessStatus)status {
    
//    NSLog(@"%d",status);
    if (status == ChessEmpty) {
      //  self.image.image = nil;
        self.image.image = nil;
    } else if (status == ChessSelectWhite) {
        [self.image setImage:[UIImage imageNamed:@"ChessSelectWhite"]];
    } else if (status == ChessWhite) {
//        self.backgroundColor = [UIColor whiteColor];
        [self.image setImage:[UIImage imageNamed:@"ChessStatusWhite"]];
    } else if (status == ChessBlack) {
        [self.image setImage:[UIImage imageNamed:@"ChessStatusBlack"]];
    }else if (status == ChessSelectBlack) {
        [self.image setImage:[UIImage imageNamed:@"ChessSelectBalck"]];
    }
    _status = status;
}

+(instancetype)chessbtnWithPosition:(position *)pos {
    chessbtn *btn = [[chessbtn alloc] initWithPosition:(position *)pos];
    return btn;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [UIColor blackColor];
    CGContextStrokeRect(ctx, rect);
}

@end
