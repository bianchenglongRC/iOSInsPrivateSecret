//
//  DetailViewController.m
//  InstagramAPI
//
//  Created by Blues on 15/11/17.
//  Copyright © 2015年 Blues. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *errorIDLab;
@property (weak, nonatomic) IBOutlet UILabel *errorStrLab;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title  = self.errorModel.errorid;
    
    
//    self.errorIDLab.text = self.errorModel.errorid;
    self.errorStrLab.text = self.errorModel.errorstr;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
