//
//  BqsPdfRenderView.h
//  iMobeeBook
//
//  Created by ellison on 11-9-5.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsPdfRenderView : UIView {
    CGPDFDocumentRef _pdfDocument;
    int _pageId;
//    CGPDFPageRef _pdfPage;
    
    float _fZoomScale;
}

@property (nonatomic, assign) float fZoomScale;

-(void)setPdf:(CGPDFDocumentRef)pdf Page:(int)pageId;
@end
