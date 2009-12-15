//
//  UploaderPermViewController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-12-14.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

@interface UploaderPermItem : TTTableTextItem
{
	BOOL _checkMark;
	NSString *_value;
}

@property (nonatomic) BOOL checkMark;
@property (nonatomic, copy) NSString *value;

@end

@interface UploaderPermItemCell : TTTableTextItemCell

@end

@interface UploaderPermDataSource : TTListDataSource
{
	UploaderPermItem *_currentItem;
}

@property (nonatomic, readonly, retain) UploaderPermItem *currentItem;

@end



@interface UploaderPermViewController : TTTableViewController {
	NSMutableArray *_items;
	id _delegate;
}

@property (nonatomic,readonly,copy) NSString *selectedValue;
@property (nonatomic,readonly,copy) NSString *selectedName;
@property (nonatomic,retain) id delegate;

@end
