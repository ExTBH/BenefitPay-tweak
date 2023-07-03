#import <substrate.h>
#import <Foundation/Foundation.h>
static NSData *makeSynchronousGETRequestWithTimeout(NSURL *url, NSTimeInterval timeout) {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSData *responseData = nil;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        responseData = data;
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    
    dispatch_time_t dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_semaphore_wait(semaphore, dispatchTimeout);
    
    return responseData;
}

// replacement for + (void)load
static void NullLoader() {}

/* 
    json format is 
    {
        "versions: [
            {
                "version": "2.0.2",
                "classes": ["class1","class2"]
            }
        ]
    }
    sorted from first supported version at top
    and newer version at bottom
*/
void dynamicHooker(NSData* jsonData) {
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error != nil) {
        NSLog(@"[ExTLogger] Error Parsing versions JSON %@", error.description);
        return;
    }

    NSArray *versions = jsonDict[@"versions"];

    if (versions == nil) {
        NSLog(@"[ExTLogger] No versions key found %@", jsonDict.description);
        return;
    }

    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSArray *classes = nil;

    for (NSDictionary *version in versions) {
        if ([version[@"version"] isEqualToString:currentVersion]) {
            classes = version[@"classes"];
            break;
        }
    }
    if (classes == nil) {
        NSLog(@"[ExTLogger] Can't find classes to hook [%@] %@",currentVersion, versions);
        return;
    }

    for (NSString *clazzString in classes) {
        Class clz = objc_getMetaClass(clazzString.UTF8String);
        MSHookMessageEx(clz, @selector(load), (IMP) NullLoader, NULL);
    }

}

static void __attribute__((constructor)) init(void) {
    NSURL *url = [NSURL URLWithString:@"https://repo.extbh.dev/dev.extbh.benefitpay/versions.json"];
    NSData *resp = makeSynchronousGETRequestWithTimeout(url, 5);
    if (resp == nil) {
        NSLog(@"[ExTLogger] Can't connent to server");
        return;
    }
    dynamicHooker(resp);
}