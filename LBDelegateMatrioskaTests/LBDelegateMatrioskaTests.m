//
//  LBDelegateMatrioskaTests.m
//  LBDelegateMatrioskaTests
//
//  Created by Luca Bernardi on 30/05/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <Kiwi/NSProxy+KiwiVerifierAdditions.h>

#import "LBDelegateMatrioska.h"


@protocol CannedProtocol <NSObject>
@optional
- (void)didSelect;
- (void)didDeselect;
- (NSInteger)didReturnValue;
@end

@interface TestDelegateSelect : NSObject <CannedProtocol>
@end
@implementation TestDelegateSelect
- (void)didSelect {}
- (NSInteger)didReturnValue { return 0; }
@end

@interface TestDelegateDeselect : NSObject <CannedProtocol>
@end
@implementation TestDelegateDeselect
- (void)didDeselect {}
@end


SPEC_BEGIN(LBDelegateMatrioskaSpec)

describe(@"The delegate matrioska", ^{
    id firstObject  = [TestDelegateSelect mock];
    id secondObject = [TestDelegateSelect mock];
    id thirdObject  = [TestDelegateDeselect mock];
    
    LBDelegateMatrioska *matrioska = [[LBDelegateMatrioska alloc] initWithDelegates:@[firstObject, secondObject, thirdObject]];

    context(@"when created", ^{
        it(@"return a valid instance", ^{
            [matrioska shouldNotBeNil];
        });
        it(@"should contain the object", ^{
            [[matrioska.delegates should] haveCountOf:3];
        });
    });
    
    context(@"when asked if respond to an implemented selector", ^{
        it(@"should respond YES", ^{
            BOOL respondToDidSelect = [matrioska respondsToSelector:@selector(didSelect)];
            [[theValue(respondToDidSelect) should] beYes];
            
            BOOL respondToDidDeselect = [matrioska respondsToSelector:@selector(didDeselect)];
            [[theValue(respondToDidDeselect) should] beYes];
        });
    });
    
    context(@"when asked if respond to a not implemented selector", ^{
        it(@"should respond to NO", ^{
            BOOL respondToDidNotExist = [matrioska respondsToSelector:@selector(didNotExist)];
            [[theValue(respondToDidNotExist) should] beNo];
        });
    });
    
    context(@"when a method is called", ^{
        it(@"should be received by all the delegate that receive the message", ^{
            
            SEL testSelector = @selector(didSelect);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [[firstObject   should]     receive:testSelector];
            [[secondObject  should]     receive:testSelector];
            [[thirdObject   shouldNot]  receive:testSelector];
            [(id <CannedProtocol>)matrioska performSelector:testSelector];
            
            testSelector = @selector(didDeselect);
            [[firstObject   shouldNot]  receive:testSelector];
            [[secondObject  shouldNot]  receive:testSelector];
            [[thirdObject   should]     receive:testSelector];
            [(id <CannedProtocol>)matrioska performSelector:testSelector];
#pragma clang diagnostic pop
        });
    });

    context(@"when a method with a return type is called", ^{
        SEL testSelector = @selector(didReturnValue);
        
        it(@"should be called only the first method", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [[firstObject   should]     receive:testSelector];
            [[secondObject  shouldNot]  receive:testSelector];
            [[thirdObject   shouldNot]  receive:testSelector];
            [(id <CannedProtocol>)matrioska performSelector:testSelector];
        });
        it(@"should return the return value of the firs method", ^{
            [firstObject stub:testSelector andReturn:theValue(42)];
            [secondObject stub:testSelector andReturn:theValue(1)];
            [[matrioska should] receive:@selector(didReturnValue) andReturn:theValue(42)];
            [(id <CannedProtocol>)matrioska performSelector:testSelector];
        });
    });
    
});

SPEC_END
