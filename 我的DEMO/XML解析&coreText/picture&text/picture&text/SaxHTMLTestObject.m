//
//  SaxHTMLTestObject.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "SaxHTMLTestObject.h"
#import "TFHpple.h"
#import <UIKit/UIKit.h>

@interface SaxHTMLTestObject ()<NSXMLParserDelegate>

/** 属性数组 */
@property (strong,nonatomic) NSMutableArray *listData;

/** 当前标签名 */
@property (copy,nonatomic) NSString *currentTagName;

/** */
@property (strong,nonatomic) NSMutableArray *attrStrings;

/** */
@property (copy,nonatomic) isolateBlock islBlock;

@end

@implementation SaxHTMLTestObject

#pragma mark - NSXMLParserDelegate
// MARK: 1.开始文档解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
//    NSLog(@"1.开始解析文档");
    self.listData = [NSMutableArray arrayWithCapacity:10];
    self.attrStrings = [NSMutableArray arrayWithCapacity:10];
}
// MARK: 2.开始解析标签
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    /**
     elementName:   当前标签名
     namespaceURI:  命名空间
     qName:         限定名
     */
    self.currentTagName = elementName;
    NSLog(@"2.didStartElement: %@",elementName);
    /// 需要特殊处理的标签
    /// 1.带有属性的,如字体样式,颜色等,如果 属性字典有值,则建立 ns mutable attributed string
    if (attributeDict.allKeys.count) {
        if ([self elementIsImg:elementName]) {
            /// 这里不处理图片标签
        }else{
            NSLog(@"2.not_img_attributeDict -- %@",attributeDict);
            /// 字号: font-size,颜色: color,字体样式
//            id style = attributeDict[@"style"];
//            NSLog(@"styleclass: %@ style: %@",[style class],style);
//            NSArray *styleArray = [style componentsSeparatedByString:@";"];
//            for (NSInteger i = 0; i < styleArray.count; i++) {
//                id styleElement = styleArray[i];
//                NSLog(@"styleElement -- %@",styleElement);
//            }
            [self.listData addObject:attributeDict];
            
        }
        
    }
    
    /// 2.图片标签,如果标签是图片,则记录图片的尺寸
    if ([self elementIsImg:elementName]) {
        NSLog(@"2.img_attributeDict -- %@",attributeDict);
        /// TODO: 加载图片,计算尺寸, 加载图片是异步的,如何正确返回尺寸?
    }
}

// MARK: 3.获取标签内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    /// 过滤换行
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    
    /// 取属性数组的最后一个元素,就是现在 string 的 属性字典
    
    NSDictionary *attrDict = self.listData.lastObject;
    
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:data options:importParams documentAttributes:&attrDict error:nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrDict];
    NSLog(@"目标attstring -- %@",attrString);
    [self.attrStrings addObject:attrString];
    
    NSLog(@"3.foundCharacters:--%@--",string);
}

// MARK: 4.结束标签解析
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    NSLog(@"4.didEndElement:   %@",elementName);
    self.currentTagName = nil;
}

// MARK: 5.结束文档解析
- (void)parserDidEndDocument:(NSXMLParser *)parser{
//    NSLog(@"5.结束文档解析__");
    /// 传递数据
    if (self.islBlock) {
        self.islBlock(self.attrStrings.copy);
    }
}

// MARK: 6.解析错误
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    /// 该方法仅做调试用
    NSLog(@"6.parseError:%@",parseError);
}

- (void)lg_sax:(isolateBlock)isolateBlock{
    self.islBlock = isolateBlock;
    /// 获取 html 数据
    NSString *testPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSData *testData = [NSData dataWithContentsOfFile:testPath];
    
    // MARK: NSXMLParser
    /// 创建xml解析对象
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:testData];

    /// 设置代理
    xmlParser.delegate = self;
    NSLog(@"%s -- ",__func__);
    /// 开始解析
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        BOOL parse = [xmlParser parse];
        NSLog(@"parse -- %d",parse);
    }];

    // MARK: Hpple
//    NSData  * data      = [NSData dataWithContentsOfFile:testPath];
//
//    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
//    NSArray * elements  = [doc searchWithXPathQuery:@"//span"];
////    NSArray * elements  = [doc search:@"//a[@class='sponsor']"];
//
////    TFHppleElement * element = [elements objectAtIndex:0];
////    [element text];                       // The text inside the HTML element (the content of the first text node)
////    [element tagName];                    // "a"
////    [element attributes];                 // NSDictionary of href, class, id, etc.
////    [element objectForKey:@"href"];       // Easy access to single attribute
////    [element firstChildWithTagName:@"b"]; // The first "b" child node
//    NSLog(@"节点个数：%ld",elements.count);
//    for (int i = 0; i < elements.count; i++) {
//        TFHppleElement * e = [elements objectAtIndex:i];
//        NSLog(@"1：%@",[e text]);          // The text inside the HTML element (the content of the first text node)
//        NSLog(@"2：%@",[e tagName]);       // "a"
//        NSLog(@"3：%@",[e attributes]);    // NSDictionary of href, class, id, etc.
//        NSLog(@"4：%@",[e objectForKey:@"href"]);       // Easy access to single attribute
//        NSLog(@"5：%@",[e firstChildWithTagName:@"img"]); // The first "b" child node
//        NSLog(@"===========解析完毕一次===========");
//    }
    
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (BOOL)elementIsImg:(NSString *)elementName{
    return [elementName isEqualToString:@"img"];
}

@end
