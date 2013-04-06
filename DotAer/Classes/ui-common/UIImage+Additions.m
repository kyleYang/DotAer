//
//  UIImage+Additions.m
//  AppTemplate
//
//  Created by 欧然 Wu on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (UIImage_Additions)

-(UIImage*) scaleImagetoSize:(CGSize) size {
    if (isRetina) {
        size = CGSizeMake(size.width * 2, size.height * 2);
    }
    CGFloat x = 0.0f, y = 0.0f, scale = 1.0f, scaleOrg = 1.0f, scaleNew = 1.0f;
    
    scaleOrg = self.size.width / self.size.height;
    scaleNew = size.width / size.height;
    if (scaleOrg < scaleNew) {
        scale = self.size.height / size.height;
        x = (size.width - self.size.width / scale) / 2;
        y = 0;
    } else {
        scale = self.size.width / size.width;
        y = (size.height - self.size.height / scale) / 2;
        x = 0;
    }
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(x, y, self.size.width / scale, self.size.height / scale)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return newImage;
}

-(UIImage*) cutImagetoSize:(CGSize) size {
    if (isRetina) {
        size = CGSizeMake(size.width * 2, size.height * 2);
    }
    CGFloat x = 0.0f, y = 0.0f, scale = 1.0f, scaleOrg = 1.0f, scaleNew = 1.0f;
    
    scaleOrg = self.size.width / self.size.height;
    scaleNew = size.width / size.height;
    if (scaleOrg < scaleNew) {
        scale = self.size.width / size.width;
        x = 0;
        y = (size.height - self.size.height / scale) / 2;
    } else {
        scale = self.size.height / size.height;
        x = (size.width - self.size.width / scale) / 2;
        y = 0;
    }
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(x, y, self.size.width / scale, self.size.height / scale)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return newImage;
}

-(UIImage*) stretchImagetoSize:(CGSize) size {
    if (isRetina) {
        size = CGSizeMake(size.width * 2, size.height * 2);
    }
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return newImage;
}

-(UIImage*) topLeftImagetoSize:(CGSize) size {
    if (isRetina) {
        size = CGSizeMake(size.width * 2, size.height * 2);
    }
    CGFloat scale = 1.0f, scaleOrg = 1.0f, scaleNew = 1.0f;
    
    scaleOrg = self.size.width / self.size.height;
    scaleNew = size.width / size.height;
    scale = (scaleOrg < scaleNew)? self.size.width / size.width : self.size.height / size.height;
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, self.size.width / scale, self.size.height / scale)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return newImage;
}


- (UIImage *)centreImagetoSize:(CGSize)size{
    
    if (isRetina) {
        size = CGSizeMake(size.width * 2, size.height * 2);
    }
    
    CGFloat x = 0.0f, y = 0.0f, scale = 1.0f, scaleOrg = 1.0f, scaleNew = 1.0f;
    
    scaleOrg = self.size.width / self.size.height;
    scaleNew = size.width / size.height;
    if (scaleOrg < scaleNew) {
        scale = self.size.width / size.width;
        x = 0;
        y = (size.height -self.size.height/scale) / 2;;
    } else {
        scale = self.size.height / size.height;
        y = 0;
        x = (size.width - self.size.width/scale ) / 2;
    }

    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(x, y, self.size.width / scale,self.size.height / scale)];

    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*) grayImage{
    int kRed = 1;  
    int kGreen = 2;  
    int kBlue = 4;  
    int colors = kGreen;  
    int m_width = self.size.width;  
    int m_height = self.size.height;  
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));  
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);  
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);  
    CGContextSetShouldAntialias(context, NO);  
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [self CGImage]);  
    CGContextRelease(context);  
    CGColorSpaceRelease(colorSpace);  
    // now convert to grayscale  
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);  
    for(int y = 0; y < m_height; y++) {  
        for(int x = 0; x < m_width; x++) {  
            uint32_t rgbPixel=rgbImage[y*m_width+x];  
            uint32_t sum=0,count=0;  
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}  
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}  
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}  
            m_imageData[y*m_width+x]=sum/count;  
        }  
    }  
    free(rgbImage);  
    // convert from a gray scale image back into a UIImage  
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    // process the image back to rgb  
    for(int i = 0; i < m_height * m_width; i++) {  
        result[i*4]=0;  
        int val=m_imageData[i];  
        result[i*4+1]=val;  
        result[i*4+2]=val;  
        result[i*4+3]=val;  
    }  
    // create a UIImage  
    colorSpace = CGColorSpaceCreateDeviceRGB();  
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);  
    CGImageRef newimage = CGBitmapContextCreateImage(context);  
    CGContextRelease(context);  
    CGColorSpaceRelease(colorSpace);  
    UIImage *resultUIImage = [UIImage imageWithCGImage:newimage];  
    CGImageRelease(newimage);  
    // make sure the data will be released by giving it to an autoreleased NSData  
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    free(result);
    free(m_imageData);
    return resultUIImage; 
}

@end
