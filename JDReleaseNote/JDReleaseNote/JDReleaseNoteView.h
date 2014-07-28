//
//  BKReleaseNoteViewController.h
//  Connect
//
//  Created by Jean-Baptiste Denoual on 23/01/2014.
//  Copyright (c) 2014 Dexem. All rights reserved.
//

#import <UIKit/UIKit.h>

//View
NSInteger const kJDBandHeight;
NSInteger const kJDBandFadeArea;

//Root keys
NSString * const kJDFileName;
NSString * const kJDRootFonts;
NSString * const kJDRootColors;
NSString * const kJDRootNotes;

//Fonts key
NSString * const kJDBandTitleFontName;
NSString * const kJDBandTitleFontSize;
NSString * const kJDBandMessageFontName;
NSString * const kJDBandMessageFontSize;
NSString * const kJDNoteTitleFontName;
NSString * const kJDNoteTitleFontSize;
NSString * const kJDNoteContentFontName;
NSString * const kJDNoteContentFontSize;

//Colors key
NSString * const kJDBackgroundColorHex;
NSString * const kJDTextsColorHex;

//Texts key
NSString * const kJDBandTitleText;
NSString * const kJDBandMessageText;
NSString * const kJDNoteTitleText;
NSString * const kJDNoteContentText;
NSString * const kJDVersion;

@interface JDReleaseNoteView : UIView

@property (nonatomic, strong) UIColor *textColor;

+ (void)showBand;
+ (void)showFullScreen;

+ (void)setDisplayBlock:(void (^)(void))completion;

@end
