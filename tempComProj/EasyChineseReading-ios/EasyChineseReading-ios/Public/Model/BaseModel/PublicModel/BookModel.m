//
//  BookModel.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BookModel.h"
#import "ECRDownloadManager.h"

@implementation BookModel

- (NSString *)contentValidity{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_contentValidity;
    }else{
        return _contentValidity;
    }
}
- (NSString *)author{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_author;
    }else{
        return _author;
    }
}
- (NSString *)bookName{

    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        _bookName = _en_bookName;
    }
    return _bookName;
}
- (NSString *)downloadURL{
    if (self.owendType == 0) {
        return _academicProbationUrl;
    }else{
        return _locationUrl;
    }
}
- (NSString *)localURL{
    if (_localURL == nil) {
        _localURL = [ECRDownloadManager localURLWithUserId:self.userId bookId:self.bookId try:modelTry(self.owendType) format:self.eBookFormat];
    }
    return _localURL;
}
- (NSString *)localEpubEncodePath{
    if (_localEpubEncodePath == nil) {
        _localEpubEncodePath = [ECRDownloadManager localURLWithUserId:self.userId bookId:self.bookId try:modelTry(self.owendType) format:0];
    }
    return _localEpubEncodePath;
}
- (NSString *)localIdentify{
    if (_localIdentify == nil) {
        _localIdentify = [ECRDownloadManager localIdentifyWithUserId:self.userId bookId:self.bookId try:modelTry(self.owendType) format:self.eBookFormat];
    }
    return _localIdentify;
}
- (NSString *)tempLocalURL{
    if (_tempLocalURL == nil) {
        _tempLocalURL = [ECRDownloadManager tempLocalURLWithUserId:self.userId bookId:self.bookId try:modelTry(self.owendType) format:self.eBookFormat];
    }
    return _tempLocalURL;
}

- (NSInteger)userId{
    return [UserRequest sharedInstance].user.userId;
}


BOOL modelTry(NSInteger oweType){
    if(oweType == 0){
        return YES;
    }else{
        return NO;
    }
}

@end
