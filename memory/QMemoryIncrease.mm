#import "QMemoryIncrease.h"
#import "../utils/NSString+Extention.h"
#import "../utils/PublicDefine.h"
#include <mach/mach.h>

@implementation QMemoryIncrease

- (instancetype)init
{
    if (self = [super init]) {
        flag.tmpCount = 0;
        flag.offset = 0;
        flag.memory = (int**)malloc(sizeof(int*)*1024);//4m
        flag.tmp = sizeof(int)*1024*1024; //4m

        _wShow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 120, PS_IPHONE_SCREEN_WIDTH, 20)];
        _wShow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PS_IPHONE_SCREEN_WIDTH, 20)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor greenColor];
        [_wShow addSubview:_label];
        
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 2;
        [_wShow addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc
{
    int ** memory = flag.memory;
    [self freeAll];
    free(memory);
}

- (void)freeAll
{
    int ** memory = flag.memory;
    for(int i=(flag.offset-1);i>=0;i--){
        int *me = *(memory+i);
        free(me);
        //*me = NULL;
    }
    flag.tmpCount -= flag.offset;
    flag.offset =0;
}

- (void)freeLast
{
    if(flag.offset<=0)return;
    if(flag.offset>=flag.locValue){
        
        int ** memory = flag.memory;
        for(int i=(flag.offset-1);i>=(flag.offset-flag.locValue);i--){
            int *me = *(memory+i);
            free(me);
            //*me = NULL;
        }
        
        flag.tmpCount -= flag.locValue;
        flag.offset-=flag.locValue;
        flag.locValue = 0;
    }
}

- (void)doMemory
{
    int * me = (int *)malloc(flag.tmp);
    memset(me, 2, flag.tmp);
    int ** memory = flag.memory;
    *(memory+flag.offset) = me;
    flag.offset += 1;
}

- (BOOL)start
{
    
    [_timer invalidate];
    _timer = nil;
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showMemory) userInfo:nil repeats:YES];
    }
    
    _wShow.windowLevel = UIWindowLevelStatusBar+100;
    _wShow.hidden = NO;
    flag.start = true;
    return YES;
}

- (BOOL)stop
{
    [_timer invalidate];
    _timer = nil;
    _wShow.hidden = YES;
    flag.start = false;
    [self freeAll];
    return YES;
}

- (BOOL)resuse
{
    return YES;
}

- (bool)status
{
    return flag.start;
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return (vm_page_size *vmStats.free_count);
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    mach_task_basic_info_data_t taskInfo;
    //   task_basic_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    // mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size;
    //  return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (NSString*)curMemoy
{
    double memory = [self availableMemory];
    return [NSString GetByteString:memory];
}

- (NSString*)uMemory
{
    double memory = flag.tmpCount*sizeof(int)*1024*1024;
    return [NSString GetByteString:memory];
}

- (NSString*)meMemory
{
    double memory = [self usedMemory];
    return [NSString GetByteString:memory];
}

- (void)showMemory
{
    //_label.text = [NSString stringWithFormat:@"当前内存:%@  手动吃掉内存:%@  当前任务占有内存:%@  双击设置.", [self curMemoy], [self uMemory], [self meMemory]];
    _label.text = [NSString stringWithFormat:@"当前设备可用内存:%@ 当前任务占用内存:%@", [self curMemoy], [self meMemory]];
}

- (void)tapGesture:(UITapGestureRecognizer*)tap
{
    NSString* message = [NSString stringWithFormat:@"N * %dMB \n 例:输入2时候会吃掉 2*%dMB \n 输入0释放所有内存 \n 输入<0时候释放内存",(int)sizeof(int),(int)sizeof(int)];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Memory" message:message delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNamePhonePad];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.cancelButtonIndex!=buttonIndex){
        int value = [[[alertView textFieldAtIndex:0] text] intValue];
        
        if(value>0){
            double memory = (value)*sizeof(int)*1024*1024;
            if(memory>[self availableMemory]) {
                UIAlertView* alertView1 = [[UIAlertView alloc] initWithTitle:@"Memory" message:@"Q_不能这么任性。" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                [alertView1 show];
                return;
            }
            
            flag.tmpCount += value;
            for(NSUInteger i=0;i<value;i++){
                [self doMemory];
            }
            [self showMemory];
        }else if(0==value){
            [self freeAll];
        }else{
            flag.locValue = ABS(value);
            [self freeLast];
        }
    }
}

@end
