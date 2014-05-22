//
//  BKReleaseNoteViewController.m
//  Connect
//
//  Created by Jean-Baptiste Denoual on 23/01/2014.
//  Copyright (c) 2014 Dexem. All rights reserved.
//

#import "JDReleaseNoteView.h"
#import "UIColor+HexString.h"

//View
NSInteger const kJDBandHeight               = 86;
NSInteger const kJDBandFadeArea             = 100;

CGFloat const kJDDisplayAnimationDuration   = 0.3;

//Root keys
NSString * const kJDFileName   = @"ReleaseNotes";
NSString * const kJDFileNameExample   = @"ReleaseNotes-Example";
NSString * const kJDRootFonts   = @"fonts";
NSString * const kJDRootColors   = @"colors";
NSString * const kJDRootNotes   = @"notes";

//Fonts key
NSString * const kJDBandTitleFontName   = @"bandTitleFontName";
NSString * const kJDBandTitleFontSize   = @"bandTitleFontSize";
NSString * const kJDBandMessageFontName    = @"bandMessageFontName";
NSString * const kJDBandMessageFontSize    = @"bandMessageFontSize";
NSString * const kJDNoteTitleFontName   = @"noteTitleFontName";
NSString * const kJDNoteTitleFontSize   = @"noteTitleFontSize";
NSString * const kJDNoteContentFontName    = @"noteContentFontName";
NSString * const kJDNoteContentFontSize    = @"noteContentFontSize";

//Colors key
NSString * const kJDBackgroundColorHex  = @"backgroundColorHex";
NSString * const kJDTextsColorHex       = @"textsColorHex";
NSString * const kJDStatusBarStyleIndex      = @"statusBarStyleIndex";

//Texts key
NSString * const kJDBandTitleText       = @"bandTitleText";
NSString * const kJDBandMessageText     = @"bandMessageText";
NSString * const kJDNoteTitleText       = @"noteTitleText";
NSString * const kJDNoteContentText     = @"noteContentText";
NSString * const kJDVersion             = @"version";


@interface JDReleaseNoteView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *fullView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIButton *bandView;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) NSMutableAttributedString *content;

@property (nonatomic, strong) NSDictionary *releaseNotesDictionary;

@property (nonatomic) UIStatusBarStyle initialStatusBarStyle;

@property (nonatomic) CGFloat verticalTranslationOrigin;

@property (nonatomic) BOOL fullScreen;

@end

@implementation JDReleaseNoteView

#pragma mark - Class methods
#pragma mark -

+ (void)showBand
{
    [JDReleaseNoteView showReleaseNotes:NO];
}

+ (void)showFullScreen
{
    [JDReleaseNoteView showReleaseNotes:YES];
}

+ (void)showReleaseNotes:(BOOL)fullScreen
{
    //TODO gerer les orientations
    //TODO verifier property status bar vc, à setter à NO
    
    CGFloat applicationHeight = ([[UIScreen mainScreen] applicationFrame].size.height+[[UIApplication sharedApplication] statusBarFrame].size.height);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JDReleaseNoteView class]) owner:nil options:nil];
    JDReleaseNoteView *releaseNoteView = [nib firstObject];
    releaseNoteView.fullScreen = fullScreen;
    
    CGRect newFrame = releaseNoteView.frame;
    newFrame.origin.y = -applicationHeight;
    newFrame.size.height = applicationHeight;
    releaseNoteView.frame = newFrame;
    
    [window addSubview:releaseNoteView];
    
    [UIView animateWithDuration:kJDDisplayAnimationDuration animations:^{
        CGRect newFrame = releaseNoteView.frame;
        if (fullScreen) {
            newFrame.origin.y = 0.0;
        }
        else {
            newFrame.origin.y = newFrame.origin.y+kJDBandHeight;
        }
        releaseNoteView.frame = newFrame;
    }];
}


#pragma mark - Instance methods
#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [self configureColors];
    [self configureFonts];
    [self configureBandTexts];
    [self configureFullViewTexts];

    //Add gesture recognizer
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
}


#pragma mark - Plist Configuration

- (void)configureFonts
{
    NSDictionary *fontsDictionary = [[NSDictionary alloc] initWithDictionary:self.releaseNotesDictionary[kJDRootFonts]];
    
    NSNumber *titleFontSize = (NSNumber *)fontsDictionary[kJDBandTitleFontSize];
    _titleLabel.font = [UIFont fontWithName:fontsDictionary[kJDBandTitleFontName] size:titleFontSize.floatValue];
    
    NSNumber *messageFontSize = (NSNumber *)fontsDictionary[kJDBandMessageFontSize];
    _messageLabel.font = [UIFont fontWithName:fontsDictionary[kJDBandMessageFontName] size:messageFontSize.floatValue];
}

- (void)configureColors
{
    NSDictionary *colorsDictionary = [[NSDictionary alloc] initWithDictionary:self.releaseNotesDictionary[kJDRootColors]];
    
    //Texts
    NSString *textHexColor = colorsDictionary[kJDTextsColorHex];
    UIColor *textsColor = [UIColor colorWithHexString:textHexColor];
    
    _titleLabel.textColor = textsColor;
    _messageLabel.textColor = textsColor;
    _textView.textColor = textsColor;
    
    //Background
    NSString *backgroundHexColor = colorsDictionary[kJDBackgroundColorHex];
    UIColor *backgroundColor = [UIColor colorWithHexString:backgroundHexColor];
    self.backgroundColor = backgroundColor;
    
    //StatusBar
    _initialStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    NSNumber* statusBarStyle = colorsDictionary[kJDStatusBarStyleIndex];
    [UIApplication sharedApplication].statusBarStyle =  (UIStatusBarStyle)statusBarStyle.integerValue;
}

- (void)configureBandTexts
{
    NSString * versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    NSArray *releaseNotesArray = [[NSArray alloc]initWithArray:self.releaseNotesDictionary[kJDRootNotes]];
    
    NSString *bandTitle = [releaseNotesArray firstObject][kJDBandTitleText];
    if ([bandTitle rangeOfString:@"%@"].location!=NSNotFound) {
        _titleLabel.text = [NSString stringWithFormat:bandTitle, versionString];
    }
    else {
        _titleLabel.text = bandTitle;
    }
    
    NSString *bandMessage = [releaseNotesArray firstObject][kJDBandMessageText];
    if ([bandMessage rangeOfString:@"%@"].location!=NSNotFound) {
        _messageLabel.text = [NSString stringWithFormat:bandMessage, versionString];
    }
    else {
        _messageLabel.text = bandMessage;
    }
}

- (void)configureFullViewTexts
{
    NSArray *releaseNotesArray = [[NSArray alloc]initWithArray:self.releaseNotesDictionary[kJDRootNotes]];
    
    _content = [[NSMutableAttributedString alloc] init];
    for (NSDictionary* releaseNoteDictionary in releaseNotesArray) {
        [self addTitle:releaseNoteDictionary[kJDNoteTitleText]];
        [self addContent:releaseNoteDictionary[kJDNoteContentText]];
    }
    
    _textView.attributedText = _content;
}

- (void)addTitle:(NSString*)title
{
    NSDictionary *fontsDictionary = [[NSDictionary alloc] initWithDictionary:self.releaseNotesDictionary[kJDRootFonts]];
    
    NSNumber *titleFontSize = (NSNumber *)fontsDictionary[kJDNoteTitleFontSize];
    NSString *titleWithNewLine = [NSString stringWithFormat:@"\n\n%@\n\n", title];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributesDictionary = @{NSFontAttributeName:[UIFont fontWithName:fontsDictionary[kJDNoteTitleFontName] size:titleFontSize.floatValue], NSParagraphStyleAttributeName: paragraph, NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attrbutedTitle = [[NSAttributedString alloc] initWithString:titleWithNewLine attributes:attributesDictionary];
    
    [_content appendAttributedString:attrbutedTitle];
}

- (void)addContent:(NSString*)content
{
    NSDictionary *fontsDictionary = [[NSDictionary alloc] initWithDictionary:self.releaseNotesDictionary[kJDRootFonts]];
    
    NSNumber *contentFontSize = (NSNumber *)fontsDictionary[kJDNoteContentFontSize];
    NSString *contentWithNewLine = [NSString stringWithFormat:@"%@\n\n", content];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    NSDictionary *attributesDictionary = @{NSFontAttributeName:[UIFont fontWithName:fontsDictionary[kJDNoteContentFontName] size:contentFontSize.floatValue],NSParagraphStyleAttributeName: paragraph, NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attrbutedTitle = [[NSAttributedString alloc] initWithString:contentWithNewLine attributes:attributesDictionary];
    
    [_content appendAttributedString:attrbutedTitle];
}


#pragma mark - Properties

- (void)setFullScreen:(BOOL)isFullScreen
{
    _fullScreen = isFullScreen;
    
    if (isFullScreen) {
        _bandView.alpha = 0.0;
        _fullView.alpha = 1.0;
        
        [self removeGestureRecognizer:_panGestureRecognizer];
    }
}

- (NSDictionary *)releaseNotesDictionary
{
    if (!_releaseNotesDictionary) {
        
        NSString *releaseNotesPath = [[NSBundle mainBundle] pathForResource:kJDFileName ofType:@"plist"];
        _releaseNotesDictionary = [[NSDictionary alloc] initWithContentsOfFile:releaseNotesPath];
        
        if (!_releaseNotesDictionary) {
            
            NSString *releaseNotesPathExample = [[NSBundle mainBundle] pathForResource:kJDFileNameExample ofType:@"plist"];
            _releaseNotesDictionary = [[NSDictionary alloc] initWithContentsOfFile:releaseNotesPathExample];
        }
    }
    
    return _releaseNotesDictionary;
}


#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    //Catch only vertical changes
    CGPoint translation = [panGestureRecognizer velocityInView:self];
    return fabs(translation.y) > fabs(translation.x);
}

- (void)onPanGesture:(UIPanGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        _verticalTranslationOrigin = [sender locationInView:self].y;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat newVerticalTranslationY = [sender locationInView:self].y;
        
        //Move the view
        CGRect newFrame = self.frame;
        newFrame.origin.y += newVerticalTranslationY-_verticalTranslationOrigin;
        if (newFrame.origin.y>0) newFrame.origin.y = 0;
        self.frame = newFrame;
        
        if (!_fullScreen) {
            //Progressive fading of the band view
            CGFloat percentFade;
            CGFloat verticalDifference = _verticalTranslationOrigin-newVerticalTranslationY;
            BOOL hasPassedOriginPoint = self.frame.origin.y+self.frame.size.height-verticalDifference>kJDBandHeight;
            if (hasPassedOriginPoint) {
                percentFade = (self.frame.origin.y+self.frame.size.height-verticalDifference-kJDBandHeight)/kJDBandFadeArea;
            } else {
                percentFade = 0.0;
            }
            if (_bandView.alpha > 0.0) {
                _bandView.alpha = (1.0-percentFade)>0.0?1.0-percentFade:0.0;
                _fullView.alpha = percentFade;
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [sender velocityInView:self];
        
        if (translation.y>0.0) {
            [self onBand:sender];
        }
        else {
            [self onClose:sender];
        }
    }
}


#pragma mark - Actions

- (IBAction)onBand:(id)sender
{
    [self removeGestureRecognizer:_panGestureRecognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bandView.alpha = 0.0;
        _fullView.alpha = 1.0;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = 0;
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        _bandView.hidden = YES;
    }];
}

- (IBAction)onClose:(id)sender
{
    [UIView animateWithDuration:kJDDisplayAnimationDuration animations:^{
        CGRect newFrame = self.frame;
        newFrame.origin.y = -newFrame.size.height;
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self updateStatusBarColorToInitial];
    }];
}


#pragma mark - UIStatusBar

- (void)updateStatusBarColorToInitial
{
    [UIApplication sharedApplication].statusBarStyle = _initialStatusBarStyle;
}


@end
