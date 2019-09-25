//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesInputToolbar.h"

#import "JSQMessagesComposerTextView.h"

#import "JSQMessagesToolbarButtonFactory.h"

#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "UIView+JSQMessages.h"

static void * kJSQMessagesInputToolbarKeyValueObservingContext = &kJSQMessagesInputToolbarKeyValueObservingContext;


@interface JSQMessagesInputToolbar ()

@property (assign, nonatomic) BOOL jsq_isObserving;

@end



@implementation JSQMessagesInputToolbar

@dynamic delegate;

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];// initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 64.0f)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.jsq_isObserving = NO;
        self.sendButtonLocation = JSQMessagesInputSendButtonLocationRight;
        self.enablesSendButtonAutomatically = YES;
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 64.0f);
//        self.insetsLayoutMarginsFromSafeArea = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;

        JSQMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
        toolbarContentView.frame = self.frame;
        [self addSubview:toolbarContentView];
        [NSLayoutConstraint activateConstraints:@[
            [toolbarContentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [toolbarContentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [toolbarContentView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [toolbarContentView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
        ]];
        [self setNeedsUpdateConstraints];
        _contentView = toolbarContentView;

        [self jsq_addObservers];

        JSQMessagesToolbarButtonFactory *toolbarButtonFactory = [[JSQMessagesToolbarButtonFactory alloc] initWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        self.contentView.leftBarButtonItem = [toolbarButtonFactory defaultAccessoryButtonItem];
        self.contentView.rightBarButtonItem = [toolbarButtonFactory defaultSendButtonItem];

        [self updateSendButtonEnabledState];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewTextDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:_contentView.textView];
    }
    return self;
}

- (JSQMessagesToolbarContentView *)loadToolbarContentView
{
    NSArray *nibViews = [[NSBundle bundleForClass:[JSQMessagesInputToolbar class]] loadNibNamed:NSStringFromClass([JSQMessagesToolbarContentView class])
                                                                                          owner:nil
                                                                                        options:nil];
    return nibViews.firstObject;
}

- (void)dealloc
{
    [self jsq_removeObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters

- (void)setEnablesSendButtonAutomatically:(BOOL)enablesSendButtonAutomatically
{
    _enablesSendButtonAutomatically = enablesSendButtonAutomatically;
    [self updateSendButtonEnabledState];
}

#pragma mark - Actions

- (void)jsq_leftBarButtonPressed:(UIButton *)sender
{
    [self.delegate messagesInputToolbar:self didPressLeftBarButton:sender];
}

- (void)jsq_rightBarButtonPressed:(UIButton *)sender
{
    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender];
}

#pragma mark - Input toolbar

- (void)updateSendButtonEnabledState
{
    if (!self.enablesSendButtonAutomatically) {
        return;
    }

    BOOL enabled = [self.contentView.textView hasText];
    switch (self.sendButtonLocation) {
        case JSQMessagesInputSendButtonLocationRight:
            self.contentView.rightBarButtonItem.enabled = enabled;
            break;
        case JSQMessagesInputSendButtonLocationLeft:
            self.contentView.leftBarButtonItem.enabled = enabled;
            break;
        default:
            break;
    }
}

#pragma mark - Notifications

- (void)textViewTextDidChangeNotification:(NSNotification *)notification
{
    [self updateSendButtonEnabledState];
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesInputToolbarKeyValueObservingContext) {
        if (object == self.contentView) {

            if ([keyPath isEqualToString:NSStringFromSelector(@selector(leftBarButtonItem))]) {

                [self.contentView.leftBarButtonItem removeTarget:self
                                                          action:NULL
                                                forControlEvents:UIControlEventTouchUpInside];

                [self.contentView.leftBarButtonItem addTarget:self
                                                       action:@selector(jsq_leftBarButtonPressed:)
                                             forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(rightBarButtonItem))]) {

                [self.contentView.rightBarButtonItem removeTarget:self
                                                           action:NULL
                                                 forControlEvents:UIControlEventTouchUpInside];

                [self.contentView.rightBarButtonItem addTarget:self
                                                        action:@selector(jsq_rightBarButtonPressed:)
                                              forControlEvents:UIControlEventTouchUpInside];
            }

            [self updateSendButtonEnabledState];
        }
    }
}

- (void)jsq_addObservers
{
    if (self.jsq_isObserving) {
        return;
    }

    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];

    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];

    self.jsq_isObserving = YES;
}

- (void)jsq_removeObservers
{
    if (!_jsq_isObserving) {
        return;
    }

    @try {
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];

        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
    }
    @catch (NSException *__unused exception) { }
    
    _jsq_isObserving = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.contentView];
}

- (void) didMoveToWindow {
    [super didMoveToWindow];
    if (@available(iOS 11.0, *)) {
        if (self.window != nil) {
            [self.bottomAnchor constraintLessThanOrEqualToSystemSpacingBelowAnchor:self.window.safeAreaLayoutGuide.bottomAnchor multiplier:1.0].active = YES;
        }
    }
}

@end