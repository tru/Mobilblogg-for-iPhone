//
//  UploaderSecretViewController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-26.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface UploaderSecretViewController : TTTableViewController {
	UITextField	*_secretWord;
	UISwitch *_save;
	id _delegate;
	NSString *_secWord;
}

-(void)SecretControllerIsDone:(UploaderSecretViewController*)secretCtrl;

@property (nonatomic, retain) id delegate;
@property (nonatomic, readonly, copy) NSString *secretWord;

@end
