//
//
// LogFileTestsConfigurationTests.m
//
//
// Copyright (c) 2008-2011 Arne Harren <ah@0xc0.de>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "lcl.h"
#import <SenTestingKit/SenTestingKit.h>


@interface LogFileTestsConfigurationTests : SenTestCase {
    
}

@end


@implementation LogFileTestsConfigurationTests

- (void)testConfigurationMaxLogFileSize {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMaxLogFileSizeInBytes:(size_t)(128 * 1024)];
    [LCLLogFile initialize];
    STAssertEquals([LCLLogFile maxSize], (size_t)(128 * 1024), nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMaxLogFileSizeInBytes:(size_t)(2 * 1024 * 1024)];
    [LCLLogFile initialize];
    STAssertEquals([LCLLogFile maxSize], (size_t)(2 * 1024 * 1024), nil);
    
    [LCLLogFile setMaxSize:4000];
    STAssertEquals([LCLLogFile maxSize], (size_t)(4096), nil);
    
    [LCLLogFile setMaxSize:8000];
    STAssertEquals([LCLLogFile maxSize], (size_t)(8000), nil);
}

- (void)testConfigurationLogFilePaths {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setLogFilePath:@"File.log"];
    [LCLLogFile initialize];
    STAssertEqualObjects([LCLLogFile path], @"File.log", nil);
    STAssertEqualObjects([LCLLogFile path0], @"File.log.0", nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setLogFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"Library/Logs/MyApplication/MyApplication.log"]];
    [LCLLogFile initialize];
    STAssertEqualObjects([LCLLogFile path], [NSTemporaryDirectory() stringByAppendingPathComponent:@"Library/Logs/MyApplication/MyApplication.log"], nil);
    STAssertEqualObjects([LCLLogFile path0], [NSTemporaryDirectory() stringByAppendingPathComponent:@"Library/Logs/MyApplication/MyApplication.log.0"], nil);

    [LCLLogFile setPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"Library/Logs/MyApplication/MyApplication_2.log"]];
    STAssertEqualObjects([LCLLogFile path], [NSTemporaryDirectory() stringByAppendingPathComponent:@"Library/Logs/MyApplication/MyApplication_2.log"], nil);
    STAssertEqualObjects([LCLLogFile path0], [NSTemporaryDirectory() stringByAppendingPathComponent:@"Library/Logs/MyApplication/MyApplication_2.log.0"], nil);
}

- (void)testConfigurationLogFilePathsWithNilPath {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMirrorMessagesToStdErr:NO];
    [LogFileTestsLoggerConfiguration setLogFilePath:nil];
    [LCLLogFile initialize];
    STAssertEquals([LCLLogFile path], (NSString *)nil, nil);
    STAssertEquals([LCLLogFile path0], (NSString *)nil, nil);
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)YES, nil);
    
    lcl_configure_by_component(lcl_cMain, lcl_vTrace);
    lcl_log(lcl_cMain, lcl_vInfo, @"message");
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setLogFilePath:@"File.log"];
    [LCLLogFile initialize];
    STAssertEqualObjects([LCLLogFile path], @"File.log", nil);
    STAssertEqualObjects([LCLLogFile path0], @"File.log.0", nil);
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)NO, nil);

    [LCLLogFile setPath:nil];
    STAssertEquals([LCLLogFile path], (NSString *)nil, nil);
    STAssertEquals([LCLLogFile path0], (NSString *)nil, nil);
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)YES, nil);
}

- (void)testConfigurationLogFilePathsWithBadPath {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMirrorMessagesToStdErr:NO];
    [LogFileTestsLoggerConfiguration setLogFilePath:@"bad-file-path"];
    [LCLLogFile initialize];
    STAssertEquals([LCLLogFile path], (NSString *)nil, nil);
    STAssertEquals([LCLLogFile path0], (NSString *)nil, nil);
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)YES, nil);
    
    lcl_configure_by_component(lcl_cMain, lcl_vTrace);
    lcl_log(lcl_cMain, lcl_vInfo, @"message");
}

- (void)testConfigurationAppendsToExistingLogFile {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setAppendToExistingLogFile:YES];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile appendsToExistingLogFile], (int)YES, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setAppendToExistingLogFile:NO];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile appendsToExistingLogFile], (int)NO, nil);
    
    [LCLLogFile setAppendsToExistingLogFile:YES];
    STAssertEquals((int)[LCLLogFile appendsToExistingLogFile], (int)YES, nil);
    
    [LCLLogFile setAppendsToExistingLogFile:NO];
    STAssertEquals((int)[LCLLogFile appendsToExistingLogFile], (int)NO, nil);
}

- (void)testConfigurationMirrorsToStdErr {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMirrorMessagesToStdErr:YES];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)YES, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMirrorMessagesToStdErr:NO];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)NO, nil);
    
    [LCLLogFile setMirrorsToStdErr:YES];
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)YES, nil);
    
    [LCLLogFile setMirrorsToStdErr:NO];
    STAssertEquals((int)[LCLLogFile mirrorsToStdErr], (int)NO, nil);
}

- (void)testConfigurationEscapesLineFeeds {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setEscapeLineFeeds:YES];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile escapesLineFeeds], (int)YES, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setEscapeLineFeeds:NO];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile escapesLineFeeds], (int)NO, nil);
    
    [LCLLogFile setEscapesLineFeeds:YES];
    STAssertEquals((int)[LCLLogFile escapesLineFeeds], (int)YES, nil);
    
    [LCLLogFile setEscapesLineFeeds:NO];
    STAssertEquals((int)[LCLLogFile escapesLineFeeds], (int)NO, nil);
}

- (void)testConfigurationMaxMessageSize {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMaxMessageSize:0];
    [LCLLogFile initialize];
    STAssertEquals([LCLLogFile maxMessageSize], (NSUInteger)0, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setMaxMessageSize:100];
    [LCLLogFile initialize];
    STAssertEquals([LCLLogFile maxMessageSize], (NSUInteger)100, nil);
    
    [LCLLogFile setMaxMessageSize:200];
    STAssertEquals([LCLLogFile maxMessageSize], (NSUInteger)200, nil);
    
    [LCLLogFile setMaxMessageSize:300];
    STAssertEquals([LCLLogFile maxMessageSize], (NSUInteger)300, nil);
}

- (void)testShowsFileNames {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setShowFileNames:YES];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile showsFileNames], (int)YES, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setShowFileNames:NO];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile showsFileNames], (int)NO, nil);
    
    [LCLLogFile setShowsFileNames:YES];
    STAssertEquals((int)[LCLLogFile showsFileNames], (int)YES, nil);
    
    [LCLLogFile setShowsFileNames:NO];
    STAssertEquals((int)[LCLLogFile showsFileNames], (int)NO, nil);
}

- (void)testShowsLineNumbers {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setShowLineNumbers:YES];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile showsLineNumbers], (int)YES, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setShowLineNumbers:NO];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile showsLineNumbers], (int)NO, nil);
    
    [LCLLogFile setShowsLineNumbers:YES];
    STAssertEquals((int)[LCLLogFile showsLineNumbers], (int)YES, nil);
    
    [LCLLogFile setShowsLineNumbers:NO];
    STAssertEquals((int)[LCLLogFile showsLineNumbers], (int)NO, nil);
}

- (void)testShowsFunctionNames {
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setShowFunctionNames:YES];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile showsFunctionNames], (int)YES, nil);
    
    [LogFileTestsLoggerConfiguration initialize];
    [LogFileTestsLoggerConfiguration setShowFunctionNames:NO];
    [LCLLogFile initialize];
    STAssertEquals((int)[LCLLogFile showsFunctionNames], (int)NO, nil);
    
    [LCLLogFile setShowsFunctionNames:YES];
    STAssertEquals((int)[LCLLogFile showsFunctionNames], (int)YES, nil);
    
    [LCLLogFile setShowsFunctionNames:NO];
    STAssertEquals((int)[LCLLogFile showsFunctionNames], (int)NO, nil);
}

@end

