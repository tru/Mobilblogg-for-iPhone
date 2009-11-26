//
//  UploaderDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-24.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "UploaderDataSource.h"

@implementation UploaderImageCell

+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	TTTableImageItem *item = object;
		
	return ((TTImageStyle*)item.imageStyle).size.height + 20;
}

-(void)layoutSubviews {
	CGFloat width = self.contentView.width;
	
	if (self.imageView2) {
		self.imageView2.frame = CGRectMake((width/2)-(_imageSize.width/2), 10, _imageSize.width, _imageSize.height);
	}
}

- (void)setObject:(id)object {
	if (_item != object) {
		[_item release];
		_item = [object retain];
		
		TTTableImageItem *item = object;

		if (item.imageURL) {
			self.imageView2.URL = item.imageURL;
		}
		
		_imageSize = ((TTImageStyle*)item.imageStyle).size;
	}
}

- (TTImageView*)imageView2 {
	if (!_imageView2) {
		_imageView2 = [[TTImageView alloc] init];
		//    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
		//    _imageView2.style = TTSTYLE(threadActorIcon);
		[self.contentView addSubview:_imageView2];
	}
	return _imageView2;
}


@end


@implementation UploaderDataSource

-(Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[TTTableImageItem class]]) {
		return [UploaderImageCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

