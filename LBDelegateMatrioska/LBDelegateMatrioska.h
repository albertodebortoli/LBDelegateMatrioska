//
//  LBDelegateMatrioska.h
//  LBDelegateMatrioska
//
//  Created by Luca Bernardi on 30/05/13.
//  Modified by Alberto De Bortoli on 07/11/13.
//
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBDelegateMatrioska : NSProxy

/**
 *	The array of delegate objects that should all conform to a specific protocol.
 */
@property (readonly, nonatomic, strong) NSArray *delegates;

/**
 *	Designated initializer.
 *
 *	@param	delegates	An array of delegate objects that should all conform to a specific protocol.
 *
 *	@return	A LBDelegateMatrioska instance containing the given delegates.
 */
- (instancetype)initWithDelegates:(NSArray *)delegates;

/**
 *	Add a delegate object to the receiver.
 *
 *	@param	delegates	A delegate object that should conform to a specific protocol.
 */
- (void)addDelegate:(id)delegate;

@end