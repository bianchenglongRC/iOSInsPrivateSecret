//
//  PresentControllerViewController.m
//  InstagramAPI
//
//  Created by Blues on 15/11/11.
//  Copyright © 2015年 Blues. All rights reserved.
//

#import "PresentControllerViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface PresentControllerViewController ()<MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *errorTab;
    NSArray *errorArr;
}




@end

@implementation PresentControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *leftButton = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemCancel target : self action : @selector (backBtnClicked:)];
    self.navigationItem.title = @"ERROR LIST";
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self initDataSource];
    
    [self addTableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(40, 50, 70, 70);
    [btn setTitle:@"click" forState:UIControlStateNormal];
//    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(sentMail) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)initDataSource
{
    DataBaseHandler *errorDB = [DataBaseHandler shareInstance];
    
    [errorDB openDB];
    
    errorArr = [NSArray array];
    
    errorArr = [errorDB selectAllErrorWithFlag:self.errorFlag];
    
    
    
    

}

- (void)addTableView
{
    errorTab = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    errorTab.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    errorTab.delegate = self;
    errorTab.dataSource = self;
    [self.view addSubview:errorTab];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ErrorItem *errorModel = [errorArr objectAtIndex:indexPath.row];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    detailVC.errorModel = errorModel;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* const cellIdentifiy = @"detifail";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiy];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifiy];
    }
    
    ErrorItem *errorModel = [errorArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = errorModel.errorid;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = errorModel.errorstr;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.numberOfLines = 5;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return errorArr.count;
}










- (void)sentMail
{
    [self displayComposerSheet];
}
-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Enter Your Subject!"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"wowbianbian@163.com"];
    
    
    [picker setToRecipients:toRecipients];
    
    // Attach an image to the email
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Icon-Small-40" ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];
    
    // Fill out the email body text
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
