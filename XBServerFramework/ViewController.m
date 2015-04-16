//
//  ViewController.m
//  XBServerFramework
//
//  Created by Peter on 15/4/15.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "ZipArchive.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
///当framework加载过后，必须重启app，所以：启动-更新-加载
    
    NSLog(@"%@",NSHomeDirectory());
    
    UILabel* lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 100)];
    lblTip.text = @"当framework加载过后，必须重启app，所以：启动-更新-加载";
    lblTip.numberOfLines = 0;
    lblTip.textAlignment = NSTextAlignmentCenter;
    lblTip.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:lblTip];
    
    
    UIButton    *btnfw1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 44)];
    [btnfw1 setTitle:@"下载framework1" forState:UIControlStateNormal];
    [btnfw1 addTarget:self action:@selector(downloadFramework1) forControlEvents:UIControlEventTouchUpInside];
    btnfw1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnfw1];
    
    UIButton    *btnfw2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 44)];
    [btnfw2 setTitle:@"下载framework2" forState:UIControlStateNormal];
    [btnfw2 addTarget:self action:@selector(downloadFramework2) forControlEvents:UIControlEventTouchUpInside];
    btnfw2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnfw2];
    
    UIButton    *btnTest1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 200, 44)];
    [btnTest1 setTitle:@"验证framework结果" forState:UIControlStateNormal];
    btnTest1.backgroundColor = [UIColor redColor];
    [btnTest1 addTarget:self action:@selector(testFramework) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTest1];
    
    

}

- (void)downloadFramework1
{
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://7xi9xs.com1.z0.glb.clouddn.com/xb.zip?attname=&e=1429164961&token=wSmLCtfuHpXvG_r16jRMQNMDOeduvh_12foLm-hY:lAqwVSJnZJKrww75NKC4FKoUg8o"]];
    NSURLResponse* respone = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&respone error:&error];
    
    
    NSString* file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmp.zip"];
    [data writeToFile:file atomically:YES];
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:file] )
    {
        BOOL ret = [zip UnzipFileTo:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmp"] overWrite:YES];
        if( ret )
        {
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/XBPrivate.framework"] error:nil];
            [[NSFileManager defaultManager]copyItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tmp/XBPrivate.framework"] toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/XBPrivate.framework"] error:nil];
        }
        [zip UnzipCloseFile];
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tmp"] error:nil];
    }
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tmp.zip"] error:nil];

    
    [[[UIAlertView alloc] initWithTitle:@"" message:@"下载完成" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
}

- (void)downloadFramework2
{
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://7xi9xs.com1.z0.glb.clouddn.com/xb2.zip?attname=&e=1429165233&token=wSmLCtfuHpXvG_r16jRMQNMDOeduvh_12foLm-hY:LiuyB1UUoU7awGyuX4vooT0f2KA"]];
    NSURLResponse* respone = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&respone error:&error];
    
    
    NSString* file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmp2.zip"];
    [data writeToFile:file atomically:YES];
    
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:file] )
    {
        BOOL ret = [zip UnzipFileTo:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmp"] overWrite:YES];
        if( ret )
        {
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/XBPrivate.framework"] error:nil];
            [[NSFileManager defaultManager]copyItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tmp/XBPrivate.framework"] toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/XBPrivate.framework"] error:nil];
        }
        [zip UnzipCloseFile];
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tmp"] error:nil];
    }
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    
    [[[UIAlertView alloc] initWithTitle:@"" message:@"下载完成" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    
    
}

-(void)testFramework
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0)
        documentDirectory = [paths objectAtIndex:0];
    
    //拼接我们放到document中的framework路径
    NSString *libName = @"XBPrivate.framework";
    NSString *destLibPath = [documentDirectory stringByAppendingPathComponent:libName];
    
    //判断一下有没有这个文件的存在　如果没有直接跳出
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:destLibPath]) {
        NSLog(@"There isn't have the file");
        [[[UIAlertView alloc] initWithTitle:@"" message:@"There isn't have the file" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return;
    }
    
    //复制到程序中
    NSError *error = nil;

    NSBundle *frameworkBundle = [NSBundle bundleWithPath:destLibPath];
    if (frameworkBundle && [frameworkBundle load]) {
        NSLog(@"bundle load framework success.");
    }else {
        NSLog(@"bundle load framework err:%@",error);
        [[[UIAlertView alloc] initWithTitle:@"" message:@"bundle load framework error" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return;
    }
    
    Class pacteraClass = NSClassFromString(@"XBTest");
    if (!pacteraClass) {
        NSLog(@"Unable to get TestDylib class");
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Unable to get TestDylib class" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return;
    }

    NSObject *pacteraObject = [pacteraClass new];//必须new
    NSString* test = [pacteraObject performSelector:@selector(getTest) withObject:nil withObject:frameworkBundle];
    [[[UIAlertView alloc] initWithTitle:@"" message:test delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    
    [frameworkBundle unload];
    
}
@end
