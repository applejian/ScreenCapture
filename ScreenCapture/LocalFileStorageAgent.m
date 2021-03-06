//
//  LocalFileStorageAgent.m
//  ScreenCapture
//
//  Created by Olegs on 28/09/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "LocalFileStorageAgent.h"
#import "LocalFileMenuActionViewBuilder.h"

@implementation LocalFileStorageAgent

- (NSString *)filePathFor:(NSString *)fileName {
    NSString *destinationFolder = [(NSString *)[self->options valueForKey:@"StorePath"] stringByStandardizingPath];
    NSString *filePath = [[NSString stringWithFormat:@"%@/%@",
                           destinationFolder,
                           fileName] stringByStandardizingPath];
    return filePath;
}

- (PMKPromise *)store:(Screenshot *)screenshot {
    
    NSLog(@"Storing file with LocalFile");
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        NSFileHandle *inputFile = [screenshot valueForKey:@"Handle" inDomain:@"Generic"];
        
        NSAssert(inputFile != nil, @"Input file handle can not be nil");
        
        NSLog(@"Calling storeFile on LocalFileStorageAgent");
        
        NSString *destinationFolder = [(NSString *)[self->options valueForKey:@"StorePath"] stringByStandardizingPath];
        
        NSError *createFolderError;
        
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:destinationFolder withIntermediateDirectories:YES attributes:nil error:&createFolderError];
        
        if (!success || createFolderError) {
            NSLog(@"Error creating folder %@", destinationFolder);
        }
        
        NSString *yyyymmddName = [screenshot valueForKey:@"FileName" inDomain:@"Generic"];
        
        NSString *fileName = [self filePathFor:yyyymmddName];
        
        NSFileHandle *outputFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        NSLog(@"Will create a new file: %@", fileName);
        
        NSString *failedAssertMsg = [NSString stringWithFormat:@"Failed to create the destination file, %@", fileName];
        
        if (outputFile == nil) {
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
            outputFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
        }
        
        NSAssert(outputFile != nil, failedAssertMsg);
        
        NSData *buffer;
        
        @try {
            [inputFile seekToFileOffset:0];
            [outputFile seekToFileOffset:0];
            
            while ([(buffer = [inputFile readDataOfLength:1024]) length] > 0) {
                [outputFile writeData:buffer];
            }
            NSLog(@"Done copying the file");
            [screenshot setValue:fileName forKey:@"FileName" inDomain:[self getDomain]];
        }
        @catch (NSException *exception) {
            @throw;
        }
        @finally {
            [inputFile seekToFileOffset:0];
            [outputFile closeFile];
            fulfill(screenshot);
        }
    }];
}


@end
