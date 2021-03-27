#import "NSString+Extention.h"

@implementation NSString (Extention)

+ (NSString *)GetByteString:(long long)number {
    NSString * byteString = nil;
    if(number < 1024){
        byteString = [NSString stringWithFormat:@"%lldB",number]; //visonzheng确认小于1K显示1K
    }
    else if(number < pow(1024, 2)){
        byteString = [NSString stringWithFormat:@"%0.2fKB",(float)number / 1024.0f];
    }
    else if(number < pow(1024,3)){
        byteString = [NSString stringWithFormat:@"%0.2fMB",(float)number / pow(1024, 2)];
    }
    else if(number < pow(1024, 4)){
        byteString = [NSString stringWithFormat:@"%0.2fGB",(float)number / pow(1024, 3)];
    }
    else if(number < pow(1024, 5)){
        byteString = [NSString stringWithFormat:@"%0.2fTB",(float)number / pow(1024, 4)];
    }
    
    return byteString;
}

@end