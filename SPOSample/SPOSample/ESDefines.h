//
//  ESDefines.h
//  SPOSample
//
//  Created by Elf Sundae on 13-5-7.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#ifndef SPOSample_ESDefines_h
#define SPOSample_ESDefines_h

#if __has_feature(objc_arc)
#define __es_arc_enabled        1
#define ES_AUTORELEASE(exp)
#define ES_RELEASE(exp)
#define ES_RETAIN(exp)
#else
#define __es_arc_enabled        0
#define ES_AUTORELEASE(exp) [exp autorelease]
#define ES_RELEASE(exp)  { [exp release]; exp = nil; }
#define ES_RETAIN(exp) [exp retain]
#endif

#if TARGET_OS_IPHONE && defined(__IPHONE_5_0) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) && __clang__ && (__clang_major__ >= 3)
#define ES_SDK_SUPPORTS_WEAK 1
#elif TARGET_OS_MAC && defined(__MAC_10_7) && (MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_7) && __clang__ && (__clang_major__ >= 3)
#define ES_SDK_SUPPORTS_WEAK 1
#else
#define ES_SDK_SUPPORTS_WEAK 0
#endif

#if ES_SDK_SUPPORTS_WEAK
#define __es_weak        __weak
#define es_weak_property weak
#else
#if __clang__ && (__clang_major__ >= 3)
#define __es_weak __unsafe_unretained
#else
#define __es_weak
#endif

#define es_weak_property assign
#endif

#endif
