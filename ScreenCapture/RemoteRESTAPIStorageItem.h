//
//  RemoteRESTAPIStorage.h
//  ScreenCapture
//
//  Created by Olegs on 29/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PrimaryStorageItem.h"

@interface RemoteRESTAPIStorageItem : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) PrimaryStorageItem *primary_storage_item;

@end
