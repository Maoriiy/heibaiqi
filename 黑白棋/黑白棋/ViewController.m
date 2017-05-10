//
//  ViewController.m
//  黑白棋
//
//  Created by jackey on 17/4/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "chessbtn.h"
#import "position.h"
#import "JohnAlertManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *chessView;
@property(nonatomic,assign) BOOL turn; //YES代表白棋回合，NO代表黑棋回合
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,weak) position *selectPos;

@property (nonatomic,strong) NSMutableArray *chessArray;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.turn = YES;
    self.selectPos = nil;
    self.info.text = @"白棋:2个\n黑棋:2个";
    for (int i = 0;  i < 64; i ++) {
        int posX = i % 8;
        int posY = i / 8;
        position *pos = [position positionWithposX:posX posY:posY];
        chessbtn *btn = [chessbtn chessbtnWithPosition:pos];
        [btn addTarget:self action:@selector(chessBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 27 || i == 36) {
            btn.status = ChessWhite;
        } else if (i == 28 || i == 35) {
            btn.status = ChessBlack;
        }
        [self.chessArray addObject:btn];
        [self.chessView addSubview:btn];
    }
    
}

-(void)chessBtnDidClick:(chessbtn *)btn {
    if (self.turn) { // 白棋回合
        if (btn.status == ChessEmpty) {
            if ([self whiteChessCanDown:btn]) {
                for (chessbtn *cbtn in self.chessView.subviews) {
                    if (cbtn.status == ChessSelectWhite) {
                        cbtn.status = ChessEmpty;
                    }
                }
                btn.status = ChessSelectWhite;
                self.selectPos = btn.pos;
            } else {
                [JohnAlertManager showFailedAlert:@"你不能在那里落子"];
            }
        }
    } else { // 黑棋回合
        if (btn.status == ChessEmpty) {
            if ([self blackChessCanDown:btn]) {
                for (chessbtn *cbtn in self.chessView.subviews) {
                    if (cbtn.status == ChessSelectBlack) {
                        cbtn.status = ChessEmpty;
                    }
                }
                btn.status = ChessSelectBlack;
                self.selectPos = btn.pos;
            } else {
                [JohnAlertManager showFailedAlert:@"你不能在那里落子"];
            }
        }
    }
}

- (IBAction)sureBtnClick {
    if (self.turn) { //白棋回合
        if (self.selectPos) {
            chessbtn *btn=[self chessBtnAtPosition:self.selectPos];
            btn.status = ChessWhite;
            [self judgeAroundWhiteChess:btn];
            self.selectPos = nil;
            self.turn = !self.turn;
        }
    } else { //黑棋回合
        if (self.selectPos) {
            chessbtn *btn=[self chessBtnAtPosition:self.selectPos];
            btn.status = ChessBlack;
            [self judgeAroundBlackChess:btn];
            self.selectPos = nil;
            self.turn = !self.turn;
        }
    }
    [self turnOver];
}

-(void)turnOver {
    int white = 0;
    int black = 0;
    int total = 0;
    for (chessbtn *btn  in self.chessArray) {
        if (btn.status == ChessWhite) {
            white ++;
            total ++;
        } else if (btn.status == ChessBlack) {
            black ++;
            total ++;
        }
    }
    self.info.text = [NSString stringWithFormat:@"白棋:%d个\n黑棋%d个",white,black];
    if (total == self.chessArray.count) {
        if (white > black) {
            NSString *str = [NSString stringWithFormat:@"白棋:%d 黑棋:%d \n白棋多，白棋胜！",white,black];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self gameover];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        } else if (black > white) {
            NSString *str = [NSString stringWithFormat:@"白棋:%d 黑棋:%d\n黑棋多，黑棋胜！",white,black];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self gameover];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [self gameover];
            }];
        } else {
            NSString *str = [NSString stringWithFormat:@"白棋:%d 黑棋:%d \n黑白棋一样多，平局!",white,black];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self gameover];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
                [self gameover];
            }];
        }
    }else if (white == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:@"没有白棋，黑棋胜" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gameover];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [self gameover];
        }];
        
    } else if (black == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:@"没有黑棋，白棋胜" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gameover];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [self gameover];
        }];
    }
    BOOL flag = NO;
    for (chessbtn *btn in self.chessArray) {
        if ( btn.status == ChessEmpty && ( [self blackChessCanDown:btn] || [self whiteChessCanDown:btn])) {
            flag = YES;
        }
    }
    if (!flag) {
        [JohnAlertManager showDefaultAlert:@"黑棋白棋都无处落子，游戏结束"];
        UIAlertController *alert = [[UIAlertController alloc] init];
        if (white > black) {
            alert.message = [NSString stringWithFormat:@"白棋:%d个 黑棋:%d个\n白棋胜",white,black];
            
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gameover];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            [self gameover];
        }];
        [self gameover];
    }
    [self changeturn];
    
}

-(void)changeturn {
    if (self.turn) {
        BOOL flag = NO;
        for (chessbtn *btn in self.chessArray) {
            if (btn.status == ChessEmpty) {
                if ([self whiteChessCanDown:btn]) {
                    flag = YES;
                    break;
                }
            }
        }
        if (!flag) {
            [JohnAlertManager showDefaultAlert:@"白棋无处可下，继续黑棋回合"];
            self.turn = !self.turn;
        }
    } else {
        BOOL flag = NO;
        for (chessbtn *btn in self.chessArray) {
            if (btn.status == ChessEmpty) {
                if ([self blackChessCanDown:btn]) {
                    flag = YES;
                    break;
                }
            }
        }
        if (!flag) {
            [JohnAlertManager showDefaultAlert:@"黑棋无处可下，继续白棋回合"];
            self.turn = !self.turn;
        }
    }
}

-(void)gameover {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游戏结束" message:@"你还想再来一局吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"好啊好啊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.chessArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.chessArray removeAllObjects];
        
        [self viewDidLoad];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [JohnAlertManager showDefaultAlert:@"妈的智障"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JohnAlertManager showSuccessAlert:@"还是再来一局吧"];
            [self.chessArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.chessArray removeAllObjects];
            
            [self viewDidLoad];
            
        });
    }];
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:yes completion:nil];
    
}

-(BOOL)whiteChessCanDown:(chessbtn *)btn {
    int btnX = btn.pos.posX;
    int btnY = btn.pos.posY;
    // 1.判断按钮上方
    if (btnY > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX posY:btnY-1]].status == ChessBlack) {
            for (int i = btnY - 2; i >= 0; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    // 2.判断按钮下方
    if (btnY < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX posY:btnY+1]].status == ChessBlack) {
            for (int i = btnY + 2; i <= 7; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    
    // 3.判断按钮左边
    if (btnX > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX-1 posY:btnY]].status == ChessBlack) {
            for (int i = btnX - 2; i >= 0; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    
    // 4.判断按钮右边
    if (btnX < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX+1 posY:btnY]].status == ChessBlack) {
            for (int i = btnX + 2; i <= 7; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    
    // 5.判断按钮左上方
    if (btnX > 1 && btnY > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX-1 posY:btnY-1]].status == ChessBlack) {
            for (int i = 2; i <= [self AWWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY-i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    
    // 6.判断按钮左下方
    if (btnX > 1 && btnY < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX-1 posY:btnY+1]].status == ChessBlack) {
            for (int i = 2; i <= [self ASWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY+i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    
    // 7.判断按钮右下方
    if (btnX < 6 && btnY < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX+1 posY:btnY+1]].status == ChessBlack) {
            for (int i = 2; i <= [self DSWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY+i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    
    // 8.判断按钮右上方
    if (btnX < 6 && btnY > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX+1 posY:btnY-1]].status == ChessBlack) {
            for (int i = 2; i <= [self DWWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY-i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessWhite) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(BOOL)blackChessCanDown:(chessbtn *)btn {
    int btnX = btn.pos.posX;
    int btnY = btn.pos.posY;
    // 1.判断按钮上方
    if (btnY > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX posY:btnY-1]].status == ChessWhite) {
            for (int i = btnY - 2; i >= 0; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 2.判断按钮下方
    if (btnY < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX posY:btnY+1]].status == ChessWhite) {
            for (int i = btnY + 2; i <= 7; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 3.判断按钮左边
    if (btnX > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX-1 posY:btnY]].status == ChessWhite) {
            for (int i = btnX - 2; i >= 0; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 4.判断按钮右边
    if (btnX < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX+1 posY:btnY]].status == ChessWhite) {
            for (int i = btnX + 2; i <= 7; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 5.判断按钮左上方
    if (btnX > 1 && btnY > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX-1 posY:btnY-1]].status == ChessWhite) {
            for (int i = 2; i <= [self AWWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY-i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 6.判断按钮左下方
    if (btnX > 1 && btnY < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX-1 posY:btnY+1]].status == ChessWhite) {
            for (int i = 2; i <= [self ASWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY+i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 7.判断按钮右下方
    if (btnX < 6 && btnY < 6) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX+1 posY:btnY+1]].status == ChessWhite) {
            for (int i = 2; i <= [self DSWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY+i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    // 8.判断按钮右上方
    if (btnX < 6 && btnY > 1) {
        if ([self chessBtnAtPosition:[position positionWithposX:btnX+1 posY:btnY-1]].status == ChessWhite) {
            for (int i = 2; i <= [self DWWithX:btnX Y:btnY]; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY-i]];
                if (bb.status == ChessEmpty) {
                    break;
                } else if (bb.status == ChessBlack) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

-(void)judgeAroundWhiteChess:(chessbtn *)btn {
    int btnX = btn.pos.posX;
    int btnY = btn.pos.posY;
    // 1.判断按钮上方
    if (btnY > 1) {
        position *posW = [[position alloc] init];
        BOOL flagW = NO;
        for (int i = btnY - 1; i >= 0; i--) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posW = bb.pos;
                flagW = YES;
                break;
            }
        }
        if (flagW) {
            for (int i = btnY - 1; i > posW.posY; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                bb.status = ChessWhite;
            }
        }
    }
    
    // 2.判断按钮下方
    if (btnY < 6) {
        position *posS = [[position alloc] init];
        BOOL flagS = NO;
        for (int i = btnY + 1; i <= 7; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posS = bb.pos;
                flagS = YES;
                break;
            }
        }
        if (flagS) {
            for (int i = btnY + 1; i < posS.posY; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                bb.status = ChessWhite;
            }
        }
    }
    
    // 3.判断按钮左边
    if (btnX > 1) {
        position *posA = [[position alloc] init];
        BOOL flagA = NO;
        for (int i = btnX - 1; i >= 0; i--) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posA = bb.pos;
                flagA = YES;
                break;
            }
        }
        if (flagA) {
            for (int i = btnX -1; i > posA.posX; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                bb.status = ChessWhite;
            }
        }
    }
    
    // 4.判断按钮右边
    if (btnX < 6) {
        position *posD = [[position alloc] init];
        BOOL flagD = NO;
        for (int i = btnX + 1; i <= 7; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posD = bb.pos;
                flagD = YES;
                break;
            }
        }
        if (flagD) {
            for (int i = btnX + 1; i < posD.posX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                bb.status = ChessWhite;
            }
        }
        
    }
    
    // 5.判断按钮左上方
    if (btnX > 1 && btnY > 1) {
        position *posAW = [[position alloc] init];
        BOOL flagAW = NO;
        for (int i = 1; i <= [self AWWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY-i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posAW = bb.pos;
                flagAW = YES;
                break;
            }
        }
        if (flagAW) {
            for (int i = 1; i < btnX - posAW.posX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY-i]];
                bb.status = ChessWhite;
            }
        }
    }
    
    
    // 6.判断按钮左下方
    if (btnX > 1 && btnY < 6 ) {
        position *posAS = [[position alloc] init];
        BOOL flagAS = NO;
        for (int i = 1; i <= [self ASWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY+i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posAS = bb.pos;
                flagAS = YES;
                break;
            }
        }
        if (flagAS) {
            for (int i = 1; i < btnX - posAS.posX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY+i]];
                bb.status = ChessWhite;
            }
        }
    }
    
    // 7.判断按钮右下方
    if (btnX < 6 && btnY < 6) {
        position *posDS = [[position alloc] init];
        BOOL flagDS = NO;
        for (int i = 1; i <= [self DSWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY+i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posDS = bb.pos;
                flagDS = YES;
                break;
            }
        }
        if (flagDS) {
            for (int i = 1; i < posDS.posX - btnX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY+i]];
                bb.status = ChessWhite;
            }
        }
    }
    
    // 8.判断按钮右上方
    if (btnX < 6 && btnY > 1) {
        position *posDW = [[position alloc] init];
        BOOL flagDW = NO;
        for (int i = 1; i <= [self DWWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY-i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessWhite) {
                posDW = bb.pos;
                flagDW = YES;
                break;
            }
        }
        if (flagDW) {
            for (int i = 1; i < posDW.posX - btnX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY-i]];
                bb.status = ChessWhite;
            }
        }
    }
}

-(void)judgeAroundBlackChess:(chessbtn *)btn {
    int btnX = btn.pos.posX;
    int btnY = btn.pos.posY;
    // 1.判断按钮上方
    if (btnY > 1) {
        position *posW = [[position alloc] init];
        BOOL flagW = NO;
        for (int i = btnY - 1; i >= 0; i--) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posW = bb.pos;
                flagW = YES;
                break;
            }
        }
        if (flagW) {
            for (int i = btnY - 1; i > posW.posY; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                bb.status = ChessBlack;
            }
        }
    }
    
    // 2.判断按钮下方
    if (btnY < 6) {
        position *posS = [[position alloc] init];
        BOOL flagS = NO;
        for (int i = btnY + 1; i <= 7; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posS = bb.pos;
                flagS = YES;
                break;
            }
        }
        if (flagS) {
            for (int i = btnY + 1; i < posS.posY; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX posY:i]];
                bb.status = ChessBlack;
            }
        }
    }
   
    
    // 3.判断按钮左边
    if (btnX > 1) {
        position *posA = [[position alloc] init];
        BOOL flagA = NO;
        for (int i = btnX - 1; i >= 0; i--) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posA = bb.pos;
                flagA = YES;
                break;
            }
        }
        if (flagA) {
            for (int i = btnX -1; i > posA.posX; i--) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                bb.status = ChessBlack;
            }
        }
    }
    
    
    // 4.判断按钮右边
    if (btnX < 6) {
        position *posD = [[position alloc] init];
        BOOL flagD = NO;
        for (int i = btnX + 1; i <= 7; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posD = bb.pos;
                flagD = YES;
                break;
            }
        }
        if (flagD) {
            for (int i = btnX + 1; i < posD.posX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:i posY:btnY]];
                bb.status = ChessBlack;
            }
        }
    }
    
    
    // 5.判断按钮左上方
    if (btnX > 1 && btnY > 1) {
        position *posAW = [[position alloc] init];
        BOOL flagAW = NO;
        for (int i = 1; i <= [self AWWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY-i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posAW = bb.pos;
                flagAW = YES;
                break;
            }
        }
        if (flagAW) {
            for (int i = 1; i < btnX - posAW.posX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY-i]];
                bb.status = ChessBlack;
            }
        }
    }
    
    
    // 6.判断按钮左下方
    if (btnX > 1 && btnY < 6) {
        position *posAS = [[position alloc] init];
        BOOL flagAS = NO;
        for (int i = 1; i <= [self ASWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY+i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posAS = bb.pos;
                flagAS = YES;
                break;
            }
        }
        if (flagAS) {
            for (int i = 1; i < btnX - posAS.posX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX-i posY:btnY+i]];
                bb.status = ChessBlack;
            }
        }
    }
    
    // 7.判断按钮右下方
    if (btnX < 6 && btnY < 6) {
        position *posDS = [[position alloc] init];
        BOOL flagDS = NO;
        for (int i = 1; i <= [self DSWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY+i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posDS = bb.pos;
                flagDS = YES;
                break;
            }
        }
        if (flagDS) {
            for (int i = 1; i < posDS.posX - btnX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY+i]];
                bb.status = ChessBlack;
            }
        }
    }
    
    // 8.判断按钮右上方
    if (btnX < 6 && btnY > 1) {
        position *posDW = [[position alloc] init];
        BOOL flagDW = NO;
        for (int i = 1; i <= [self DWWithX:btnX Y:btnY]; i++) {
            chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY-i]];
            if (bb.status == ChessEmpty) {
                break;
            } else if (bb.status == ChessBlack) {
                posDW = bb.pos;
                flagDW = YES;
                break;
            }
        }
        if (flagDW) {
            for (int i = 1; i < posDW.posX - btnX; i++) {
                chessbtn *bb = [self chessBtnAtPosition:[position positionWithposX:btnX+i posY:btnY-i]];
                bb.status = ChessBlack;
            }
        }
    }
    
}

-(void)setSelectPos:(position *)selectPos {
    _selectPos = selectPos;
    if (!_selectPos) {
        [self.sureBtn setEnabled:NO];
    } else {
        [self.sureBtn setEnabled:YES];
    }
}

-(void)setTurn:(BOOL)turn {
    if (turn) {
        [self.label setText:@"白棋回合"];
    } else {
        [self.label setText:@"黑棋回合"];
    }
    _turn = turn;
}

-(NSMutableArray *)chessArray {
    if (!_chessArray) {
        _chessArray = [NSMutableArray array];
    }
    return _chessArray;
}

-(chessbtn *)chessBtnAtPosition:(position *)pos {
    return self.chessArray[pos.posX + pos.posY * 8 ];
}

-(int)AWWithX:(int)x Y:(int)y {
    if (x < y) {
        return x;
    } else {
        return y;
    }
}
-(int)ASWithX:(int)x Y:(int)y {
    if (x < 7-y) {
        return x;
    } else {
        return 7-y;
    }
}
-(int)DSWithX:(int)x Y:(int)y {
    if (7-x < 7-y) {
        return 7-x;
    } else {
        return 7-y;
    }
}
-(int)DWWithX:(int)x Y:(int)y {
    if (7-x < y) {
        return 7-x;
    } else {
        return y;
    }
}

@end
