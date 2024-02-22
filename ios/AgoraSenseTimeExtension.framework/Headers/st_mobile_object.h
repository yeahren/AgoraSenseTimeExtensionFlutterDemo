﻿#ifndef INCLUDE_STMOBILE_ST_MOBILE_OBJECT_H_
#define INCLUDE_STMOBILE_ST_MOBILE_OBJECT_H_

#include "st_mobile_common.h"
///  \~chinese 该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.例如在 create handle 没有执行完就执行 process 可能造成crash;在 process 执行过程中调用 destroy 函数可能会造成crash.
///  \~english The APIs in this file do not guarantee thread safety. When calling them in a multi-threaded environment, it is important to ensure safe usage. For example, calling create_handle before process is completed may result in a crash. Similarly, calling destroy during the execution of process may also lead to a crash

/// @defgroup st_mobile_object_tracker
/// This set of interhands processing hand tracking routines
///
/// \~chinese
/// @brief 创建通用物体跟踪句柄
/// @param[out] handle 通用物体跟踪句柄,失败返回NULL
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
/// \~english
/// @brief Create a generic object tracking handle
/// @param[out] handle The handle for generic object tracking, or NULL if creation fails
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_object_tracker_create(
    st_handle_t* handle
);


/// \~chinese
/// @brief 重置通用物体跟踪句柄. 清空缓存,删除跟踪目标
/// @param[in] handle 通用物体跟踪句柄
/// \~english
/// @brief Reset the generic object tracking handle, clear and remove internal tracked targets cache
/// @param[in] handle The initialized generic object tracking handle
ST_SDK_API void
st_mobile_object_tracker_reset(
    st_handle_t handle
);

/// \~chinese
/// @brief  设置跟踪目标的矩形
/// @param[in] handle 已初始化的实时通用物体跟踪句柄
/// @param[in] image 用于检测的图像数据
/// @param[in] pixel_format 用于检测的图像数据的像素格式,都支持,不推荐BGRA/BGR/RGBA,速度会慢,内部会统一将图片covert to gray
/// @param[in] image_width 用于检测的图像的宽度(以像素为单位)
/// @param[in] image_height 用于检测的图像的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数;目前仅支持字节对齐的padding,不支持roi
/// @param[in] target_rect 输入指定的目标矩形框,输出实际跟踪的矩形框.目前只能跟踪2^n正方形矩形
/// @return  成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
/// \~english
/// @brief Set the rectangle region for the tracked target
/// @param[in] handle The initialized generic object tracking handle
/// @param[in] image The image data used for detection
/// @param[in] pixel_format The pixel format of the image data, all formats is supported. However, using BGRA/BGR/RGBA formats is not recommended as it may result in slower processing speed. Internally, the image will be converted to gray
/// @param[in] image_width Width of the image used for detection, measured in pixels
/// @param[in] image_height Height of the image, in pixels
/// @param[in] image_stride Stride of the image data, measured in bytes per row. Only byte-aligned padding is supported, and region of interest (ROI) is not supported currently
/// @param[in] target_rect The specified input target rectangle
/// @return  Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_object_tracker_set_target(
    st_handle_t handle,
    const unsigned char *image,
    st_pixel_format pixel_format,
    int image_width,
    int image_height,
    int image_stride,
    st_rect_t* target_rect
);


/// \~chinese
/// @brief 对连续视频帧中的目标进行实时快速跟踪
/// @param[in] handle 已初始化的实时通用物体跟踪句柄
/// @param[in] image 用于检测的图像数据
/// @param[in] pixel_format 用于检测的图像数据的像素格式,都支持,不推荐BGRA/BGR/RGBA,速度会慢,内部会统一将图片covert to gray
/// @param[in] image_width 用于检测的图像的宽度(以像素为单位)
/// @param[in] image_height 用于检测的图像的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数;目前仅支持字节对齐的padding,不支持roi
/// @param[out] rects 输入指定的目标矩形框,输出实际跟踪的矩形框.目前只能跟踪2^n正方形矩形,如果追踪失败则为{0, 0, 0, 0},如果框有一条边移出图片太远会被认为检测失败，这个距离阈值是框边长的0.6倍
/// @param[out] score 置信度，取值范围(0,1)
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
/// \~english
/// @brief Perform real-time and fast tracking of the target in consecutive video frames
/// @param[in] handle The initialized generic object tracking handle
/// @param[in] image The image data used for detection
/// @param[in] pixel_format The pixel format of the image data, all formats is supported. However, using BGRA/BGR/RGBA formats is not recommended as it may result in slower processing speed. Internally, the image will be converted to gray
/// @param[in] image_width Width of the image used for detection, measured in pixels
/// @param[in] image_height Height of the image, in pixels
/// @param[in] image_stride Stride of the image data, measured in bytes per row. Only byte-aligned padding is supported, and region of interest (ROI) is not supported currently
/// @param[out] rects The actual tracked rectangle generated based on the specified input target rectangle. Currently, it can only track rectangular boxes that are 2^n squares. If tracking fails, the output will be {0, 0, 0, 0}. If any side of the box moves too far out of the image, it will be considered a detection failure.
/// @param[out] score The confidence of the tracked rectangle (0,1)
/// @return  Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_object_tracker_track(
    st_handle_t handle,
    const unsigned char *image,
    st_pixel_format pixel_format,
    int image_width,
    int image_height,
    int image_stride,
    st_rect_t *rects,
    float *score
);

/// \~chinese
/// @brief 销毁已初始化的通用物体跟踪句柄
/// @param[in] handle 已初始化的句柄
/// \~english
/// @brief Destroy the initialized generic object tracking handle
/// @param[in] handle The initialized generic object tracking handle
ST_SDK_API void
st_mobile_object_tracker_destroy(
    st_handle_t handle
);

/// \~chinese
/// @brief 设置每隔多少帧做一次跟踪，中间帧使用缓存平滑处理
/// @param[in] handle 已初始化的句柄
/// @param[in] val 有效范围[1,2,3]
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
/// \~english
/// @brief Set the tracking interval to determine how often the tracking is performed. Tracking results of the intermediate frames will be smoothed
/// @param[in] handle The initialized generic object tracking handle
/// @param[in] val Valid range [1,2,3]
/// @return  Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_object_tracker_set_track_interval(
	st_handle_t handle,
	int val
);

/// @}

#endif  // INCLUDE_STMOBILE_ST_MOBILE_OBJECT_H_