# DetectThirdAppFPSAndMemoryPerformance
使用 Tweak 查看第三方 App 的 FPS 和内存表现

## 使用方法

- 修改 Bundles 为你要 hook 的app 的 bundle identifier
```
{ Filter = { Bundles = ( "com.hunantv.imgotv" ); }; }
```

- 使用 Frida 砸壳
```
dump.py -l
dump.py com.hunantv.imgotv
```

- 把目标 App 的头文件 dump 出来
```
class-dump -H /Users/petershu/Desktop/frida-ios-dump/mgtv/Payload/MGTV-iPhone-appstore.app/MGTV-iPhone-appstore -o /Users/petershu/Desktop/frida-ios-dump/mgtv/mgtv_headers
```

- 修改 AppDelegate 为目标 App 的代理类
因为 App 的代理类可能不是这个类，这个就是我们要 hook 的类，需要从上一步 dump 出来的头文件中找到对应的 AppDelegate 类进行替换
```
%hook AppDelegate

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
        [fpsLabel sizeToFit];
        // 当前顶层窗口
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        // 添加到窗口
        [window addSubview:fpsLabel];

        QMemoryIncrease *memory = [QMemoryIncrease new];
        [memory start];
    });

    return %orig;
}

%end
```
- Mac 远程登录到 iPhone
```
python tcprelay.py -t 22:10010
ssh root@localhost -p 10010
```

- 运行脚本，把 deb 包注入到目标 App 里面
```
cd 到项目根目录
. make.sh
```

- 效果图
![image](http://tedshu.com/images/ThirdApp/11.jpg)
