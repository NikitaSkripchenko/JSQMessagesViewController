//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  MIT License
//  Copyright (c) 2014 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import <XCTest/XCTest.h>
#import "JSQMessagesViewController.h"
#import "JSQMessagesCollectionViewCellIncoming.h"
#import "JSQMessagesCollectionViewCellOutgoing.h"


@interface JSQMessagesViewController ()

- (void)jsq_configureMessagesViewController;

@end




@interface JSQMessagesViewControllerTests : XCTestCase
@end



@implementation JSQMessagesViewControllerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testJSQMessagesViewControllerInit
{
    UINib *nib = [JSQMessagesViewController nib];
    XCTAssertNotNil(nib, @"Nib should not be nil");
    
    JSQMessagesViewController *vc = [JSQMessagesViewController messagesViewController];

    [vc beginAppearanceTransition:YES animated:NO];
    [vc endAppearanceTransition];

    XCTAssertNotNil(vc, @"View controller should not be nil");
    XCTAssertNotNil(vc.view, @"View should not be nil");
    XCTAssertNotNil(vc.collectionView, @"Collection view should not be nil");
    XCTAssertNotNil(vc.inputToolbar, @"Input toolbar should not be nil");
    
    XCTAssertEqual(vc.automaticallyAdjustsScrollViewInsets, YES, @"Property should be equal to default value");

    XCTAssertEqualObjects(vc.incomingCellIdentifier, [JSQMessagesCollectionViewCellIncoming cellReuseIdentifier], @"Property should be equal to default value");
    XCTAssertEqualObjects(vc.outgoingCellIdentifier, [JSQMessagesCollectionViewCellOutgoing cellReuseIdentifier], @"Property should be equal to default value");

    XCTAssertEqual(vc.showTypingIndicator, NO, @"Property should be equal to default value");
    XCTAssertEqual(vc.showLoadEarlierMessagesHeader, NO, @"Property should be equal to default value");
}

- (void)testJSQMessagesViewControllerSubclassInitProgramatically
{
    JSQMessagesViewController *demoVC = [JSQMessagesViewController messagesViewController];

    [demoVC beginAppearanceTransition:YES animated:NO];
    [demoVC endAppearanceTransition];

    XCTAssertNotNil(demoVC, @"View controller should not be nil");
    XCTAssertTrue([demoVC isKindOfClass:[JSQMessagesViewController class]], @"View controller should be kind of class: %@", [JSQMessagesViewController class]);
    XCTAssertNotNil(demoVC.view, @"View should not be nil");
    XCTAssertNotNil(demoVC.collectionView, @"Collection view should not be nil");
    XCTAssertNotNil(demoVC.inputToolbar, @"Input toolbar should not be nil");
}

@end
