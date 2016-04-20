//
//  ChangeUserCell.m
//  InstagramAPI
//
//  Created by Blues on 16/4/20.
//  Copyright © 2016年 Blues. All rights reserved.
//

#import "ChangeUserCell.h"
#import "CMethods.h"

@implementation ChangeUserCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        
        self.backImgView = [[UIImageView alloc] init];
//        self.backImgView.image = [UIImage imageNamed:@"gl_price_bg_normal"];
        [self addSubview:self.backImgView];
        
        self.headerImgView = [[UIImageView alloc] init];
        [self.backImgView addSubview:self.headerImgView];
        
        self.nameLbl = [[UILabel alloc] init];
        self.nameLbl.textColor = [UIColor whiteColor];
        [self.backImgView addSubview:self.nameLbl];
        
        
        self.signImgView = [[UIImageView alloc] init];
        self.signImgView.image = [UIImage imageNamed:@"ec_icon_coins"];
        [self.backImgView addSubview:self.signImgView];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backImgView.frame =  CGRectMake(0, 0, 548/2, 124/2);
    
    self.backImgView.backgroundColor  = [UIColor blueColor];
    
    self.headerImgView.frame = getFrameWithRect(11, 16, 33, 33);
    
    self.backImgView.layer.masksToBounds = YES;
    self.backImgView.layer.cornerRadius = 4;
    
    self.nameLbl.frame = getFrameWithRect(44, 0, self.frame.size.width/2, self.frame.size.height);    
    
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
