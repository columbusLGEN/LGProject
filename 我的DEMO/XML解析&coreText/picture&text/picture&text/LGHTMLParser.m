//
//  LGHTMLParser.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/29.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LGHTMLParser.h"
#import <DTCoreText/DTCoreText.h>

@interface LGHTMLParser ()<DTHTMLParserDelegate>
/** 解析成功回调 */
@property (copy,nonatomic) ParseSuccess success;

@end

@implementation LGHTMLParser

//#pragma mark - DTHTMLParserDelegate
//- (void)parserDidStartDocument:(DTHTMLParser *)parser{
//    NSLog(@"1.开始解析");
//}
//- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict{
//    NSLog(@"2.didStartElement -- %@ \n attributeDict: %@",elementName,attributeDict);
//}
//- (void)parser:(DTHTMLParser *)parser foundComment:(NSString *)comment{
//    NSLog(@"foundComment -- %@",comment);
//}
//- (void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string{
//    /// 获取标签内容
//    NSLog(@"3.foundCharacters -- %@",string);
//}
//- (void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName{
//    NSLog(@"4.didEndElement -- %@",elementName);
//}
//- (void)parserDidEndDocument:(DTHTMLParser *)parser{
//    NSLog(@"5.结束解析");
//}
//- (void)parser:(DTHTMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//    NSLog(@"6.parseError -- %@",parseError);
//}

- (void)HTMLSax:(ParseSuccess)success{
    _success = success;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    DTHTMLAttributedStringBuilder *builder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:htmlData options:nil documentAttributes:nil];
    
    NSAttributedString *attrString = [builder generatedAttributedString];
//    NSLog(@"attrString -- %@",attrString);
    success(attrString);
    
//    DTHTMLParser *parser = [[DTHTMLParser alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//    parser.delegate = self;
//    [parser parse];
}

@end
