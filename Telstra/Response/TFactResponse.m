//
//  TFactResponse.m
//  Telstra
//
//  Created by Anupam Rao on 22/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import "TFactResponse.h"
#import " TConstant.h"
#import "TFactModel.h"
#import <AFNetworking.h>
@implementation TFactResponse
- (id)init {
    self = [super init];
    if (self) {
        _factsArray = [[NSMutableArray alloc] init];
        _navTitleString = [[NSString alloc] init];
    }
    return(self);
}

- (void)getFactsDataWithCompletionHandler:(void (^)(NSError *error))completionHandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer = serializer;
    NSURL *URL = [NSURL URLWithString: K_TSERVICE_BASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_factsArray removeAllObjects];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    if (!error)  {
                                                        NSString *iso = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
                                                        NSData *dataUsingTF8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
                                                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:dataUsingTF8 options:NSJSONReadingMutableContainers error:nil];
                                                        NSArray *factsDictionaryArray = [responseDictionary objectForKey:@"rows"];
                                                        NSMutableArray *factsMutableArray = [[NSMutableArray alloc] init];
                                                        NSError *jsonError = nil;
                                                        for(NSDictionary *factDictionary in factsDictionaryArray) {
                                                            TFactModel *factModel = [[TFactModel alloc] initWithDictionary:factDictionary error:&jsonError];
                                                            if (factModel) {
                                                                [factsMutableArray addObject:factModel];
                                                            }
                                                        }
                                                        _factsArray = factsMutableArray;
                                                        _navTitleString = [responseDictionary objectForKey:@"title"];;
                                                    }
                                                    completionHandler(error);
                                                }];
    [dataTask resume];
}


@end
