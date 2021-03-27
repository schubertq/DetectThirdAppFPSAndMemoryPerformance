@interface QMemoryIncrease : NSObject {
    struct _flag {
        float curMemory;
        float tmp;
        float tmpCount;
        int   count;
        bool  start;
        int ** memory;
        int offset;
        int locValue;
    } flag;
    
    UIWindow* _wShow;
    UILabel* _label;
    NSTimer* _timer;
}

- (BOOL)start;

@end
