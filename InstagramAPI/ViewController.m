//
//  ViewController.m
//  InstagramAPI
//
//  Created by Blues on 15/9/7.
//  Copyright (c) 2015年 Blues. All rights reserved.
//




#import "ViewController.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SBJson.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AFInstagramManager.h"
#import "OrderItem.h"
#import "FollowOrderList.h"
#import "PresentControllerViewController.h"

#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#define InsKey @"6618606de1acf0d804b47831d5074f3f302478330565df90aac37264dc632147"
#define InsKey1 @"b4a23f5e39b5929e0666ac5de94c89d1618a2916"
#define InsKey2 @"25a0afd75ed57c6840f9b15dc61f1126a7ce18124df77d7154e7756aaaa4fce4"

#define userDefault     [NSUserDefaults standardUserDefaults]



//static NSString* kUserAgent = @"Instagram 6.12.0 (iPhone6,2; iPhone OS 8_3; en_GB; en) AppleWebKit/420+";
static NSString* kUserAgent = @"Instagram 6.9.1 Android (15/4.0.4; 160dpi; 320x480; Sony; MiniPro; mango; semc; en_Us)";

//static NSString* kStringBoundary = @"B17B7707-F82B-480B-A7E0-B55EEEC71473";
static const NSTimeInterval kTimeoutInterval = 120.0;


@interface ViewController ()<MFMailComposeViewControllerDelegate>
{
    BOOL * finished;
    NSString *kStringBoundary;
    NSOperationQueue *queue;
    NSDictionary *headerDic;
}
@property (nonatomic, copy) void (^successLogin)(NSString *code);

@property (nonatomic, strong)NSString *csrftoken;
@property (nonatomic, strong)NSString *httpMethod;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, strong)NSDictionary *requestBody;
@property (nonatomic, strong)NSURLConnection *connection;
@property (nonatomic, strong)NSString *requestFlag;
@property (nonatomic, strong)NSString *device_id;
@property (weak, nonatomic) IBOutlet UIButton *insLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *postLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *postFollowBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *sentMailBtn;
@property (nonatomic, strong)NSNumber *userID;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userUrl;

@property (nonatomic, strong)NSArray *mediaIDArr;
@property (nonatomic, strong)NSArray *followArr;
@property (nonatomic, assign)NSInteger arrIndex;

@end

@implementation ViewController

-(void)setSuccessLoginBlock:(void (^)(NSString *))successLoginBlock
{
    _successLogin = successLoginBlock;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    //    [self getUniqueStrByUUID];
    self.device_id = [self getUniqueStrByUUID];
    
    //    [self makeApiCallWithMethod:@"///fas" Params:nil Ssl:NO Use_cookie:NO];
    
    self.mediaIDArr = @[@"1044798097628187013_49147161",
                        @"1044797529476155770_49147161",
                        @"1043219096665180782_49147161",
                        @"1037159855630174696_49147161",
                        @"1026766597104192153_49147161",
                        @"1026337002043329262_49147161",
                        @"1025017418203908357_49147161",
                        @"1021238494407805841_49147161",
                        @"1015849055007394429_49147161",
                        @"1015828320977274997_49147161",
                        @"1014181500937160845_49147161",
                        @"1013428067774875659_49147161",
                        @"1012688843295541635_49147161",
                        @"1010520607338646397_49147161",
                        @"1008318606211140176_49147161",
                        @"1053762018098850200_486821321",
                        @"1049358076694800713_486821321",
                        @"1017859215749065156_486821321",
                        @"1016402385265010773_486821321",
                        @"1003715812568377799_486821321",
                        @"997476737813359236_486821321",
                        @"968808145425311952_486821321",
                        @"954075993462843965_486821321",
                        @"946770200950516505_486821321",
                        @"945710879831533730_486821321",
                        @"944407325061720215_486821321",
                        @"936584237636954288_486821321",
                        @"929307660448475676_486821321",
                        @"895886259121335134_486821321",
                        @"893802589015288559_486821321",
                        @"892607613820513067_486821321",
                        @"888513446253209832_486821321",
                        @"1057611318299145317_261092508",
                        @"1053279034088187151_1422928160",
                        @"1025033943753477692_1993037354",
                        @"1055625660011029140_2011539007",
                        @"1035983490201734456_1993037354",
                        @"486553319828305578_261092508",
                        @"1055611980582134187_2011539007",
                        @"486557604074960602_261092508",
                        @"1059272854531241870_367550796",
                        @"1055647995233476630_2011539007",
                        @"1053277565175817459_1422928160",
                        @"1063577685984553011_2157262313",
                        @"1064866514730076258_2158918185",
                        @"1064370801892068377_2158886218",
                        @"1064860687643889722_2158944787",
                        @"1064377018824023516_2158941558",
                        @"1064875323747929970_2158886218",
                        @"1064378362204075071_2158899684",
                        @"1064889508020030714_2158886218",
                        @"1064889055723064559_2158886218",
                        @"1064355403880631925_2158901186",
                        @"1064307509711052950_2158766767",
                        @"1064897834745269704_2158886218",
                        @"1064897444800826811_2158886218",
                        @"1064368218015897223_2158890868",
                        @"1064375305596752018_2158944787",
                        @"1064358165999574259_2158903126"];
    
    self.followArr = @[@"1935027429",@"676472",@"1095314671",@"1422656387",@"1390308064",@"465801013",@"30618776",@"1991422485",@"287684963",@"1680644505",@"2038726157",@"1742327521",@"2013787504",@"199997451",@"1599781168",@"1586031701",@"1322896057",@"1996356974",@"47583271",@"1702309994",@"632623",@"1812092393",@"2100611465",@"1437859792",@"2123099991",@"936004829",@"829625881",@"1561178672",@"516881205",@"291774334",@"1447893733",@"218134228",@"1981026256",@"2134165943",@"373614085",@"1491381285",@"1150538009",@"543457927",@"2071148048",@"2076456420",@"211552758",@"1702585768",@"1471627530"
                       ,@"223838876"
                       ,@"40135876"
                       ,@"2053872150"
                       ,@"1441012173"
                       ,@"1262031923"
                       ,@"1336449724"
                       ,@"615081722"
                       ,@"1445686036"
                       ,@"325762575"
                       ,@"2022308612"
                       ,@"1558042169"
                       ,@"463293231"
                       ,@"924575263"
                       ,@"1955500117"
                       ,@"511509316"
                       ,@"2125158115"
                       ,@"1687173446"
                       ,@"1985809720"
                       ,@"2079369679"
                       ,@"1763422567"
                       ,@"1909355677"
                       ,@"425438653"
                       ,@"1417605598"
                       ,@"2000321405"
                       ,@"1277028579"
                       ,@"1810672351"
                       ,@"372948818"
                       ,@"1654881528",@"490972861",@"1172647572",@"233203848",@"262750486",@"1533239658",@"1067416366",@"516417338",@"2114979302",@"1477558500",@"1439756077",@"2150720558",@"456877657",@"1424858334",@"855085718",@"2155364048",@"2049555239",@"1510934754",@"552941587",@"1704640472",@"1626699654",@"364254191",@"1666348682",@"326854023",@"214368133",@"1820176740",@"429480382",@"1554796948",@"1950835202",@"407525373"];
    
    self.arrIndex = 0;
    
    
    //head  请求头
    
    NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
    headerDic = @{@"User-Agent":kUserAgent, @"Content-Type":contentType, @"Accept-Language" : @"en;q=1, zh-Hans;q=0.9, ja;q=0.8, zh-Hant;q=0.7, fr;q=0.6, de;q=0.5"};
    
    
//    self.ig_key = [userDefault objectForKey:igkey];
//    NSString *keyAgentVersion = [userDefault objectForKey:igversion];
//    NSArray *keyArr = [keyAgentVersion componentsSeparatedByString:@"|"];
//    self.ig_key_version = [keyArr firstObject];
//    self.ig_agent = [keyArr lastObject];
//    self.device_id = [userDefault objectForKey:deviceID];
    
    [self getBaseParam];
    
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}



- (void)sendMailClicked:(id)sender {
    
    int i = [self getRandomNumber:1 to:3];

    NSLog(@"%d", i);
//    [self displayComposerSheet];
    
    
    
    
    PresentControllerViewController *preVC =[[PresentControllerViewController alloc] init];
    
    [self.navigationController pushViewController:preVC animated:NO];
    
    
    
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


//获取基础参数

- (void)getBaseParam
{
    
    NSDictionary *dic = [NSMutableDictionary dictionary];
    
    dic = @{@"plat": @1 , @"appid" : @"80015"};
    
//    NSString *str=[NSString stringWithFormat:@"http://192.168.0.88:8088/GetLikeGetFollowerWeb/userinfo/BaseParm.do"];
//    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [request addValue:@"Instagram 6.12.0 (iPhone6,2; iPhone OS 8_3; en_GB; en) AppleWebKit/420+" forHTTPHeaderField:@"user-agent	"];
    
    
    [[RC_RequestManager shareInstance] requestForBaseParm:dic success:^(id responseObject) {
        NSDictionary *parmDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if (parmDic) {
            if ([parmDic objectForKey:@"autoFollowerSpeed"]) {
                [userDefault setObject:[parmDic objectForKey:@"autoFollowerSpeed"] forKey:autoFollowerSpeed];
            } else {
                [userDefault setObject:@"0" forKey:autoFollowerSpeed];
            }
            
            if ([parmDic objectForKey:@"autoFollowerSwitch"]) {
                [userDefault setObject:[parmDic objectForKey:@"autoFollowerSwitch"] forKey:autoFollowerSwitch];
            } else {
                [userDefault setObject:@"0" forKey:autoFollowerSwitch];
            }
            if ([parmDic objectForKey:@"autoLikeSpeed"]) {
                [userDefault setObject:[parmDic objectForKey:@"autoLikeSpeed"] forKey:autoLikeSpeed];
            } else {
                [userDefault setObject:@"0" forKey:autoLikeSpeed];
            }
            if ([parmDic objectForKey:@"autoLikeSwitch"]) {
                [userDefault setObject:[parmDic objectForKey:@"autoLikeSwitch"] forKey:autoLikeSwitch];
            } else {
                [userDefault setObject:@"0" forKey:autoLikeSwitch];
            }
            if ([parmDic objectForKey:@"manualFollowerSpeed"]) {
                [userDefault setObject:[parmDic objectForKey:@"manualFollowerSpeed"] forKey:manualFollowerSpeed];
            } else {
                [userDefault setObject:@"50" forKey:manualFollowerSpeed];
            }
            if ([parmDic objectForKey:@"manualFollowerStealNum"]) {
                [userDefault setObject:[parmDic objectForKey:@"manualFollowerStealNum"] forKey:manualFollowerStealNum];
            } else {
                [userDefault setObject:@"0" forKey:manualFollowerStealNum];
            }
            if ([parmDic objectForKey:@"manualLikeSpeed"] ) {
                [userDefault setObject:[parmDic objectForKey:@"manualLikeSpeed"] forKey:manualLikeSpeed];
            } else {
                [userDefault setObject:@"60" forKey:manualLikeSpeed];
            }
            if ([parmDic objectForKey:@"manualLikeStealNum"]) {
                [userDefault setObject:[parmDic objectForKey:@"manualLikeStealNum"] forKey:manualLikeStealNum];
            } else {
                [userDefault setObject:@"0" forKey:manualLikeStealNum];
            }
            if ([parmDic objectForKey:@"scoreFlag"]) {
                [userDefault setObject:[parmDic objectForKey:@"scoreFlag"] forKey:scoreFlag];
            } else {
                [userDefault setObject:@"0" forKey:scoreFlag];
            }
            if ([parmDic objectForKey:@"scoresendgold"]) {
                [userDefault setObject:[parmDic objectForKey:@"scoresendgold"] forKey:scoresendgold];
            } else {
                [userDefault setObject:@"10" forKey:scoresendgold];
            }
            if ([parmDic objectForKey:@"stoptime"]) {
                [userDefault setObject:[parmDic objectForKey:@"stoptime"] forKey:stoptime];
            } else {
                [userDefault setObject:@"15" forKey:stoptime];
            }
            if ([parmDic objectForKey:@"igkey"]) {
                [userDefault setObject:@"25a0afd75ed57c6840f9b15dc61f1126a7ce18124df77d7154e7756aaaa4fce4" forKey:igkey];
            } else {
                [userDefault setObject:@"25a0afd75ed57c6840f9b15dc61f1126a7ce18124df77d7154e7756aaaa4fce4" forKey:igkey];
            }
            if ([parmDic objectForKey:@"igversion"]) {
                [userDefault setObject:@"4|Instagram 6.9.1 Android" forKey:igversion];
            } else {
                [userDefault setObject:@"4|Instagram 6.9.1 Android" forKey:igversion];
            }
            if(![userDefault objectForKey:deviceID]){
                [userDefault setObject:[self getUniqueStrByUUID] forKey:deviceID];
            }
            [userDefault synchronize];
        } else {
            [userDefault setObject:@"0" forKey:autoFollowerSpeed];
            [userDefault setObject:@"0" forKey:autoFollowerSwitch];
            [userDefault setObject:@"0" forKey:autoLikeSpeed];
            [userDefault setObject:@"0" forKey:autoLikeSwitch];
            [userDefault setObject:@"50" forKey:manualFollowerSpeed];
            [userDefault setObject:@"0" forKey:manualFollowerStealNum];
            [userDefault setObject:@"60" forKey:manualLikeSpeed];
            [userDefault setObject:@"0" forKey:manualLikeStealNum];
            [userDefault setObject:@"0" forKey:scoreFlag];
            [userDefault setObject:@"10" forKey:scoresendgold];
            [userDefault setObject:@"15" forKey:stoptime];
            [userDefault setObject:@"25a0afd75ed57c6840f9b15dc61f1126a7ce18124df77d7154e7756aaaa4fce4" forKey:igkey];
            [userDefault setObject:@"4|Instagram 6.9.1 Android" forKey:igversion];
            if(![userDefault objectForKey:deviceID]){
                [userDefault setObject:[self getUniqueStrByUUID] forKey:deviceID];
            }
            [userDefault synchronize];
        }
    } andFailed:^(NSError *error) {
        [userDefault setObject:@"0" forKey:autoFollowerSpeed];
        [userDefault setObject:@"0" forKey:autoFollowerSwitch];
        [userDefault setObject:@"0" forKey:autoLikeSpeed];
        [userDefault setObject:@"0" forKey:autoLikeSwitch];
        [userDefault setObject:@"50" forKey:manualFollowerSpeed];
        [userDefault setObject:@"0" forKey:manualFollowerStealNum];
        [userDefault setObject:@"60" forKey:manualLikeSpeed];
        [userDefault setObject:@"0" forKey:manualLikeStealNum];
        [userDefault setObject:@"0" forKey:scoreFlag];
        [userDefault setObject:@"10" forKey:scoresendgold];
        [userDefault setObject:@"15" forKey:stoptime];
        [userDefault setObject:@"25a0afd75ed57c6840f9b15dc61f1126a7ce18124df77d7154e7756aaaa4fce4" forKey:igkey];
        [userDefault setObject:@"4|Instagram 6.9.1 Android" forKey:igversion];
        if(![userDefault objectForKey:deviceID]){
            [userDefault setObject:[self getUniqueStrByUUID] forKey:deviceID];
        }
        [userDefault synchronize];
    }];

}


- (void)getPictureFromSever
{
    
}



- (IBAction)InsLogin:(id)sender {
    
      NSLog(@"%lu", (unsigned long)self.followArr.count);
    
    [self deleteCookieWithKey];
    [self.postLikeBtn setEnabled:NO];
    NSDictionary *params = @{@"username":@"team3_3",@"from_reg":@"false",@"password":@"123456abc"};
    NSString *sign_body = [self makeApiCallWithMethod:@"Login" Params:params Ssl:NO Use_cookie:nil];
    NSDictionary *requestBody = @{@"ig_sig_key_version" : @"4", @"signed_body" : sign_body};
    NSMutableData *bodyData = [NSMutableData generatePostBodyWithRequestBody:requestBody Boundary:kStringBoundary];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    [[AFInstagramManager shareManager] loginRequestWithHeader:headerDic body:bodyData timeoutInterVal:kTimeoutInterval result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //做一下sever的登录
        
        self.userID = [[responseObject objectForKey:@"logged_in_user"] objectForKey:@"pk"];
        self.userName = [[responseObject objectForKey:@"logged_in_user"] objectForKey:@"username"];
        self.userUrl = [[responseObject objectForKey:@"logged_in_user"] objectForKey:@"profile_pic_url"];
        
        if (self.userID != nil) {
            [self severLogin];
        }
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieDic setObject:cookie.value forKey:cookie.name];
        }
        self.csrftoken = [cookieDic objectForKey:@"csrftoken"];
        [userDefault setObject:self.csrftoken forKey:ctoken];
        [self.postLikeBtn setEnabled:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}

// sever登录

- (void)severLogin
{
    [[RC_RequestManager shareInstance] registeUseInfo:[self getRegisteUseInfoDic] success:^(id responseObject) {
        NSLog(@"%@", responseObject);
    } andFailed:^(NSError *error) {
        
    }];
}

-(NSDictionary *)getRegisteUseInfoDic    //appid userid usertoken picurl  password countryid deviceid pushtoken
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:ACCESSTOKEN_KEY];
    NSString *userToken = @"";
    if (token) {
        userToken = token;
    }
    
    NSNumber *userId = [[NSNumber alloc] init];
    if (self.userID) {
        userId = self.userID;
    }
    NSString *userName = @"";
    if (self.userName) {
        userName = self.userName;
    }
    
    
    NSString *picUrl = @"";
    if (self.userUrl) {
        picUrl = self.userUrl;
    }
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    NSString *deviceid = @"";
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    
    if (idfv == nil) {
        deviceid = defaultDevID;
    } else
    {
        deviceid = idfv;
    }
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSString *countCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if (countCode == nil) {
        countCode = @"US";
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSRange range = NSMakeRange(3, localTimeZone.abbreviation.length - 3);
    NSInteger timeZoneStr = [[localTimeZone.abbreviation substringWithRange:range] integerValue];
    NSNumber *timeZoneNum = [NSNumber numberWithInteger:timeZoneStr];
    if (timeZoneNum == nil) {
        timeZoneNum = @0;
    }
    
    dic = @{@"plat":@1, @"userid":userId, @"username" : userName, @"password":@"", @"countryid":countCode, @"usertoken":userToken, @"pushtoken":deviceToken, @"picurl":picUrl, @"deviceid":deviceid, @"appid":SeverAppID, @"language":CURR_LANG, @"timeZone":timeZoneNum};
    NSLog(@"dicUserInfo:%@", dic);
    
    return dic;
}


- (void)deleteCookieWithKey
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
}



- (IBAction)postLike:(id)sender {   ///Like
    
    
    NSInteger likeAutoSwitch = [[userDefault objectForKey:autoLikeSwitch] integerValue];
    NSInteger likeAutoCount = [[userDefault objectForKey:autoLikeSpeed] integerValue];
    [self getAutoLikeList:10];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if (likeAutoSwitch != 0) {
            [self getAutoLikeList:likeAutoCount];
        }
    });
}

//获取图片列表, 自动消耗
- (void)getAutoLikeList:(NSInteger)count
{
    NSDictionary *dic = @{@"plat":@1, @"appid" : @"80015", @"userid" : self.userID, @"usertoken" : @"",@"type" : @0};
    [[RC_RequestManager shareInstance] requestPictureFormSeverWithParm:dic success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"state"] intValue] == 10000) {
            OrderList *list = [[OrderList alloc] initWithArray:[responseObject objectForKey:@"list"]];
            NSLog(@"%@", list.array);
            if (list.array.count > 0) {
                [self beginAutoLike:list.array count:count - list.array.count];
            }
        }
    } andFailed:^(NSError *error) {
        
    }];
}


static int total = 0;
- (void)beginAutoLike:(NSArray *)dataList count:(NSInteger)count {
    for (int i = 0; i < dataList.count; ++ i) {
        OrderItem *likeModel = dataList[i];
        NSString *mediaId = likeModel.picid;
        NSDictionary *likeParams = @{@"photo_id":mediaId,@"_uuid":@"8E620E94-8CF1-4389-9360-CEDC7742C998",@"_uid":@"2058722339",@"_csrftoken":@"db906fa9a02ee7f28dd510fa7ec3315b"};
        NSString *sign_body = [self makeApiCallWithMethod:@"Like" Params:likeParams Ssl:NO Use_cookie:self.csrftoken];
        NSDictionary *requestBody = @{@"ig_sig_key_version" : @"4", @"signed_body" : sign_body};
        NSMutableData *bodyData = [NSMutableData generatePostBodyWithRequestBody:requestBody Boundary:kStringBoundary];

       [[AFInstagramManager shareManager] likeRequestWithUrl:[NSString stringWithFormat: @"https://i.instagram.com/api/v1/media/%@/like/?d=0&src=timeline", mediaId] header:headerDic body:bodyData timeoutInterVal:kTimeoutInterval result:^(AFHTTPRequestOperation *operation, id responseObject) {
           if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
               total += 1;
               NSLog(@"================> finish total = %zd", total);
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
       }];
        
    }
    [self getAutoLikeList:count];
}





- (IBAction)postFollow:(id)sender {
    
//    for (int i = 0; i < self.followArr.count; i++) {
//        NSString *followId = self.followArr[i];
//        self.url = [NSString stringWithFormat:@"https://i.instagram.com/api/v1/friendships/create/%@/", followId];
//        NSDictionary *followStr = @{@"_uuid":@"8E620E94-8CF1-4389-9360-CEDC7742C998",@"_uid":@"2158917908",@"user_id":followId,@"_csfrtoken":@"db906fa9a02ee7f28dd510fa7ec3315b"};
//        
//        NSString *sign_body = [self makeApiCallWithMethod:@"Follow" Params:followStr Ssl:NO Use_cookie:self.csrftoken];
//        self.requestBody = @{@"ig_sig_key_version" : @"4", @"signed_body" : sign_body};
//        self.httpMethod = @"POST";
//        [self connect];
//    }
  
    [self getAutoFollowList:10];
    
    
}


- (void)getAutoFollowList:(NSInteger)count
{
    NSDictionary *dic = @{@"plat":@1, @"appid" : @"80015", @"userid" : @1993037354, @"usertoken" : @"",@"type" : @0};
    [[RC_RequestManager shareInstance] requestUserFormSeverWithParm:dic success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"state"] intValue] == 10000) {
            FollowOrderList *list = [[FollowOrderList alloc] initWithArray:[responseObject objectForKey:@"list"]];
            NSLog(@"%@", list.array);
            if (list.array.count > 0) {
                [self beginAutoFollow:list.array count:count - list.array.count];
            }
        }

        
        
    } andFailed:^(NSError *error) {
        
    }];
    
    
}


static int total1 = 0;
- (void)beginAutoFollow:(NSArray *)dataList count:(NSInteger)count {
    for (int i = 0; i < dataList.count; ++ i) {
        FollowOrderItem *followModel = dataList[i];
        NSString *userID = followModel.userid;
        NSDictionary *followParams = @{@"_uuid":@"8E620E94-8CF1-4389-9360-CEDC7742C998",@"_uid":@"2058722339",@"user_id":userID,@"_csfrtoken":@"db906fa9a02ee7f28dd510fa7ec3315b"};
        NSString *sign_body = [self makeApiCallWithMethod:@"Follow" Params:followParams Ssl:NO Use_cookie:self.csrftoken];
        NSDictionary *requestBody = @{@"ig_sig_key_version" : @"4", @"signed_body" : sign_body};
        NSMutableData *bodyData = [NSMutableData generatePostBodyWithRequestBody:requestBody Boundary:kStringBoundary];
        
        [[AFInstagramManager shareManager] followRequestWithUrl:[NSString stringWithFormat: @"https://i.instagram.com/api/v1/friendships/create/%@/", userID] header:headerDic body:bodyData timeoutInterVal:kTimeoutInterval result:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                total1 += 1;
                NSLog(@"================> finish total = %zd", total1);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
    [self getAutoLikeList:count];
}





- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
    
}


- (NSString *)makeApiCallWithMethod:(NSString *)method Params:(NSDictionary *)params Ssl:(BOOL)ssl Use_cookie:(NSString *)user_cookie
{
    
    NSMutableDictionary *defaultRequestBody = [NSMutableDictionary dictionaryWithDictionary:params];
    
    
    if ([method isEqualToString:@"Login"]) {
        [defaultRequestBody setObject:self.device_id forKey:@"device_id"];
        [defaultRequestBody setObject:self.device_id forKey:@"_uuid"];
    }
    
    if ([method isEqualToString:@"Like"]) {
        [defaultRequestBody setObject:self.device_id forKey:@"_uuid"];
        [defaultRequestBody setObject:user_cookie forKey:@"_csrftoken"];
    }
    
    if ([method isEqualToString:@"Follow"]) {
        [defaultRequestBody setObject:self.device_id forKey:@"_uuid"];
        [defaultRequestBody setObject:user_cookie forKey:@"_csrftoken"];
    }
    
    
    NSString *sig = nil;
    NSString *sign_body = nil;
    
    if (defaultRequestBody != nil) {
        NSString *sbJsonStr = [self sbJsonRecoverDic:defaultRequestBody];
        sig = [NSString signWithKey:InsKey2 usingData:sbJsonStr];
        sign_body = [NSString stringWithFormat:@"%@.%@", sig, sbJsonStr];
    }
    
    return sign_body;
}

- (void)connect {
    
    
    kStringBoundary = [self getUniqueStrByUUID];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:kTimeoutInterval];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"i.instagram.com:443" forHTTPHeaderField:@"Host"];
        [request setValue:@"en;q=1, zh-Hans;q=0.9, ja;q=0.8, zh-Hant;q=0.7, fr;q=0.6, de;q=0.5" forHTTPHeaderField:@"Accept-Language"];
        [request setValue:@"AQ==" forHTTPHeaderField:@"X-IG-Capabilities"];
        [request setHTTPBody:[self generatePostBody]];
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];

    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@ %ld",dict, (long)self.arrIndex);
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies) {
            // Here I see the correct rails session cookie
            
            [cookieDic setObject:cookie.value forKey:cookie.name];
            
        }
        self.csrftoken = [cookieDic objectForKey:@"csrftoken"];
        [self.postLikeBtn setEnabled:YES];
        NSLog(@"%@", cookieDic);
        
//        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        NSString *cookiesString = [self sbJsonRecoverDic:dic];
//        
//        
//        [defaults setObject: dic forKey: @"sessionCookies"];
//        [defaults synchronize];
        
        self.arrIndex++;
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@ %ld",error, (long)self.arrIndex);
        self.arrIndex++;
    }];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperations:[NSArray arrayWithObject:operation] waitUntilFinished:YES];
    
    
}

- (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray * pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            if ([httpMethod isEqualToString:@"GET"]) {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL, /* allocator */
                                                                                                        (__bridge CFStringRef)[params objectForKey:key],
                                                                                                        NULL, /* charactersToLeaveUnescaped */
                                                                                                        (CFStringRef)@"!*'();:@&=$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    //    NSLog(@"URL: %@", [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query]);
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

#pragma mark - internal



- (NSMutableData *)generatePostBody {
    NSMutableData *body = [NSMutableData data];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]];
    int i = 0;
    for (id key in [self.requestBody keyEnumerator]) {
        i++;
        
        if (([[self.requestBody valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[self.requestBody valueForKey:key] isKindOfClass:[NSData class]])) {
            
            [dataDictionary setObject:[self.requestBody valueForKey:key] forKey:key];
            continue;
            
        }
        
        [self utfAppendBody:body
                       data:[NSString
                             stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                             key]];
        [self utfAppendBody:body data:[self.requestBody valueForKey:key]];
        
        if (i == 2) {
            endLine  = [NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary];
        }
        
        [self utfAppendBody:body data:endLine];
        
        
    }
    
    if ([dataDictionary count] > 0) {
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            if ([dataParam isKindOfClass:[UIImage class]]) {
                NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:@"Content-Type: image/png\r\n\r\n"];
                [body appendData:imageData];
            } else {
                NSAssert([dataParam isKindOfClass:[NSData class]],
                         @"dataParam must be a UIImage or NSData");
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:@"Content-Type: content/unknown\r\n\r\n"];
                [body appendData:(NSData*)dataParam];
            }
            
            
            
            
            [self utfAppendBody:body data:endLine];
            
        }
    }

    NSString *result = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    return body;
}

- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
    [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}


- (NSString *)sbJsonRecoverDic:(NSDictionary *)dic
{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonString = [writer stringWithObject:dic];
    return jsonString;
}

- (NSString *)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
    
}

- (NSString *)signWithKey:(NSString *)key usingData:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return [[HMAC.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
