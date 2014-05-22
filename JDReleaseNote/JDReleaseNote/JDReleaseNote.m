//
//  BKReleaseNote.m
//  Connect
//
//  Created by Jean-Baptiste Denoual on 23/01/2014.
//  Copyright (c) 2014 Dexem. All rights reserved.
//

#import "JDReleaseNote.h"
#import "JDReleaseNoteView.h"

NSString * const kJDInstallVersion      = @"com.jaydlabs.releasenote.installVersion";
NSString * const kJDLastReleaseNoteSeen = @"com.jaydlabs.releasenote.lastReleaseNoteSeen";

@implementation JDReleaseNote

#pragma mark - Class methods
#pragma mark -

+ (void)displayReleaseNoteBandIfNeeded
{
    if ([JDReleaseNote needDisplayReleaseNote]) {
        [JDReleaseNoteView showBand];
        [JDReleaseNote updateLastReleaseNoteSeen];
    }
}

+ (BOOL)needDisplayReleaseNote
{
    NSString * versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    if ([versionString isEqualToString:[JDReleaseNote installVersion]]) {
        //Same version as install version, don't show release note
        return NO;
    } else if ([versionString isEqualToString:[JDReleaseNote lastReleaseNoteSeen]]) {
        //Release note for this version has already been displayed
        return NO;
    } else {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:kJDFileName ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filepath];
        NSArray *noteArray = [[NSArray alloc]initWithArray:[dict objectForKey:kJDRootNotes]];
        NSString *maxReleaseNoteVersion = [[noteArray firstObject] valueForKey:kJDVersion];
        
        if ([versionString isEqualToString:maxReleaseNoteVersion]) {
            //There is a release note for this version and it has not been displayed
            return YES;
        } else {
            //There is no release note for this version
            return NO;
        }
    }
}

+ (void)updateLastReleaseNoteSeen
{
    NSString * versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    [JDReleaseNote setLastReleaseNoteSeen:versionString];
}

+ (void)saveInstallVersionAsAnteriorIfNeeded;
{
    if (![JDReleaseNote hasInstallVersion]) {
        [JDReleaseNote setInstallVersion:@"0.0.0"];
    }
}

+ (BOOL)hasInstallVersion;
{
    NSString *installVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kJDInstallVersion];
    return installVersion!=nil;
}


+ (void)displayReleaseNoteBand
{
    [JDReleaseNoteView showBand];
}

+ (void)displayReleaseNotesFullScreen
{
    [JDReleaseNoteView showFullScreen];
}


#pragma mark - UserDefaults

+ (NSString*)installVersion
{
    NSString *installVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kJDInstallVersion];
    if (!installVersion) {
        installVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:installVersion forKey:kJDInstallVersion];
    }
    
    return installVersion;
}

+ (void)setInstallVersion:(NSString*)newInstallVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:newInstallVersion forKey:kJDInstallVersion];
}

+ (NSString*)lastReleaseNoteSeen
{
    NSString *lastReleaseNoteSeen = [[NSUserDefaults standardUserDefaults] objectForKey:kJDLastReleaseNoteSeen];
    if (!lastReleaseNoteSeen) {
        lastReleaseNoteSeen = @"";
    }
    
    return lastReleaseNoteSeen;
}

+ (void)setLastReleaseNoteSeen:(NSString*)newLastReleaseNoteSeen
{
    [[NSUserDefaults standardUserDefaults] setObject:newLastReleaseNoteSeen forKey:kJDLastReleaseNoteSeen];
}

@end
