//
//  PhotoPickerController.h
//  MobilBlogg
//
//  Created by Tobias Rundström on 2010-02-26.
//  Copyright 2010 Purple Scout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface PhotoPickerController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
}

-(id)initWithCamera:(BOOL)camera;

@end
