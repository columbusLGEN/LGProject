//
//  ECRPDFRelateder.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRPDFRelateder.h"

@implementation ECRPDFRelateder

+ (UIImage *)getPDFCoverWithPath:(NSString *)path{
    CGPDFDocumentRef pdfDocuRef = [self pdfRefByFilePath:path];
    return [self imageFromPDFWithDocumentRef:pdfDocuRef];
}

+ (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef {
    return [[self sharedInstance] imageFromPDFWithDocumentRef:documentRef];
}
- (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef {
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

+ (CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath {
    return [[self sharedInstance] pdfRefByFilePath:aFilePath];
}
- (CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath {
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString(NULL, [aFilePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    document = CGPDFDocumentCreateWithURL(url);
    
    CFRelease(path);
    CFRelease(url);
    
    return document;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
