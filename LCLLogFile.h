//
//
// LCLLogFile.h
//
//
// Copyright (c) 2008-2009 Arne Harren <ah@0xc0.de>
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

#define _LCLLOGFILE_VERSION_MAJOR  1
#define _LCLLOGFILE_VERSION_MINOR  1
#define _LCLLOGFILE_VERSION_BUILD  0

//
// LCLLogFile
//
// LCLLogFile is a logging back-end implementation which writes log messages to
// an application-specific log file. LCLLogFile can be used as a logging
// back-end for LibComponentLogging, but it is also useable as a standalone
// logging class without the Core files of LibComponentLogging.
//
// The log file is opened automatically when the first log message needs to be
// written to the log file. There is no need to call open, close, reset, etc.
// manually.
//
// The log file gets rotated if a given maximum file size is reached.
//
// LCLLogFile is configured via the following #defines:
//
// - Full path of the log file (type NSString *)
//   #define _LCLLogFile_LogFilePath <definition>
//
// - Append to an existing log file on startup? (type BOOL)
//   #define _LCLLogFile_AppendToExistingLogFile
//
// - Maximum size of the log file in bytes (type size_t)
//   #define _LCLLogFile_MaxLogFileSizeInBytes <definition>
//
// - Mirror log messages to stderr? (type BOOL)
//   #define _LCLLogFile_MirrorMessagesToStdErr <definition>
//
// - Escape special characters in log messages (type BOOL)
//   #define _LCLLogFile_EscapeSpecialCharacters <definition>
//
// - Show file names in the log messages? (type BOOL)
//   #define _LCLLogFile_ShowFileNames <definition>
//
// - Show line numbers in the log messages? (type BOOL)
//   #define _LCLLogFile_ShowLineNumbers <definition>
//
// - Show function names in the log messages? (type BOOL)
//   #define _LCLLogFile_ShowFunctionNames <definition>
//
// When using LCLLogFile as a back-end for LibComponentLogging, these #defines
// should be specified in the lcl_config_logger.h configuration file.
//


//
// LCLLogFile class.
//


@interface LCLLogFile : NSObject {
    
}

// Returns the path of the log file as defined by _LCLLogFile_LogFilePath.
+ (NSString *)path;

// Returns the path of the backup log file.
+ (NSString *)path0;

// Opens the log file.
+ (void)open;

// Closes the log file.
+ (void)close;

// Resets the log file.
+ (void)reset;

// Rotates the log file.
+ (void)rotate;

// Returns the current size of the log file.
+ (size_t)size;

// Returns the maximum size of the log file as defined by
// _LCLLogFile_MaxLogFileSizeInBytes.
+ (size_t)maxSize;

// Returns whether log messages get appended to an existing log file on startup.
+ (BOOL)appendsToExistingLogFile;

// Returns whether log messages are mirrored to stderr.
+ (BOOL)mirrorsToStdErr;

// Returns whether special characters are escaped in log messages.
+ (BOOL)escapesSpecialCharacters;

// Returns whether file names are shown.
+ (BOOL)showsFileNames;

// Returns whether line numbers are shown.
+ (BOOL)showsLineNumbers;

// Returns whether function names are shown.
+ (BOOL)showsFunctionNames;

// Returns the name from the given bundle's Info.plist file. If the name doesn't
// exist, the bundle's identifier is returned. If the identifier doesn't exist,
// nil is returned.
+ (NSString *)nameOrIdentifierFromBundle:(NSBundle *)bundle;

// Returns a default path component for a log file which is based on the given
// bundles' Info.plist files. The returned path has the form
//   <path>/<file>.log
// where
//   <path> is the name (or identifier) of the given path bundle, and
//   <file> is the name (or identifier) of the given file bundle.
// If the name or identifier cannot be retrieved from the path bundle, the
// returned default path has the form
//   <file>/<file>.<pid>.log
// where
//   <pid> is the current process id.
// If the name or identifier cannot be retrieved from the file bundle,
//   nil
// is returned.
+ (NSString *)defaultPathComponentFromPathBundle:(NSBundle *)pathBundle fileBundle:(NSBundle *)fileBundle;

// Returns a default path for a log file which is based on the Info.plist
// files which are associated with this class. The returned path has the form
//   <path>/<main>/<this>.log
// where
//   <path> is the given path prefix,
//   <main> is the name (or identifier) of the application's main bundle, and
//   <this> is the name (or identifier) of the bundle to which this LCLLogFile
//          class belongs.
// If the name or identifier cannot be retrieved from the main bundle, the
// returned default path has the form
//   <path>/<this>/<this>.<pid>.log
// where
//   <pid> is the current process id.
// If the name or identifier cannot be retrieved from the bundle which
// corresponds to this LCLLogFile class,
//   nil
// is returned.
// If the given path prefix <path> is nil,
//   nil
// is returned.
+ (NSString *)defaultPathWithPathPrefix:(NSString *)pathPrefix;

// Returns a default path for a log file which is based on the Info.plist
// files which are associated with this class. The returned path has the form
//   ~/Library/Logs/<main>/<this>.log
// where
//   <main> is the name (or identifier) of the application's main bundle, and
//   <this> is the name (or identifier) of the bundle to which this LCLLogFile
//          class belongs.
// This method is a convenience method which calls defaultPathWithPathPrefix
// with the prefix ~/Library/Logs.
+ (NSString *)defaultPathInHomeLibraryLogs;

// Returns the version of LCLLogFile.
+ (NSString *)version;

// Writes the given log message to the log file.
+ (void)logWithComponent:(const char *)component level:(uint32_t)level
                    path:(const char *)path line:(uint32_t)line
                function:(const char *)function
                  format:(NSString *)format, ... __attribute__((format(__NSString__, 6, 7)));

@end


//
// Integration with LibComponentLogging Core.
//


// Definition of _lcl_logger.
#define _lcl_logger(_component, _level, _format, ...) {                        \
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];                \
    [LCLLogFile logWithComponent:_lcl_component_header[_component]             \
                           level:_level                                        \
                            path:__FILE__                                      \
                            line:__LINE__                                      \
                        function:__FUNCTION__                                  \
                          format:_format,                                      \
                              ## __VA_ARGS__];                                 \
    [pool release];                                                            \
}

