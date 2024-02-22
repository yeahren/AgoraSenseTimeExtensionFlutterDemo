﻿/**
*@file st_mobile_verify.h
* \~chinese
* 提供人脸特征提取及比对方法
*
*@attention 该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.
*该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.例如在 detect/reset 没有执行完就执行 process 可能造成crash;在 detect 执行过程中调用 reset 函数可能会造成crash.

* 一般调用步骤：创建句柄->获取特征->特征比对->销毁句柄

* \~english
* Provides face feature extraction and comparison methods

*@attention The APIs in this file do not guarantee thread safety. When calling them in a multi-threaded environment, it is important to ensure safe usage.
* For example, calling destroy before detect or reset has completed may result in a crash.
* Calling the reset function during the execution of detect may also lead to a crash.

* General pipeline: Create a handle -> Extract features -> Compare features -> Destroy the handle.

* st_mobile_verify_create

* st_mobile_verify_get_feature

* st_mobile_verify_get_features_compare_score

* st_mobile_verify_destroy

**/
#ifndef ST_MOBILE_VERIFY_H
#define ST_MOBILE_VERIFY_H

#include "st_mobile_common.h"
/// \~chinese
/// @brief 创建verify句柄
/// @param[in] p_model_path 模型文件路径
/// @param[out] p_handle handle信息，由库负责创建，创建完成供后续接口调用时使用
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
/// \~english
/// @brief Create the verify handle
/// @param[in] p_model_path The path to the model file
/// @param[out] p_handle The handle for face verification, or NULL if creation failed
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_verify_create(const char *p_model_path, st_handle_t *p_handle);

/// \~chinese
/// @brief 创建verify句柄
/// @param[in] p_buffer 模型buffer指针
/// @param[in] buffer_size 模型buffer大小
/// @param[out] p_handle handle信息，由库负责创建，创建完成供后续接口调用时使用
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
/// \~english
/// @brief Create the verify handle
/// @param[in] p_buffer Pointer to the model buffer
/// @param[in] buffer_size Length the model buffer
/// @param[out] p_handle The handle for face verification, or NULL if creation failed
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_verify_create_from_buffer(const unsigned char *p_buffer,
                                    int buffer_len,
                                    st_handle_t *p_handle);

/// \~chinese
/// @brief 根据人脸关键点获取人脸特征
/// @param[in] handle verify句柄
/// @param[in] p_image 图像数据
/// @param[in] p_face_key_points 人脸关键点
/// @param[in] face_key_points_size 人脸关键点数量
/// @param[out] feature 特征数组，用户使用前需要将特征数组拷贝到自己的内存空间
/// @param[out] feature_size 特征数组长度
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
/// \~english
/// @brief Get face features based on face landmarks
/// @param[in] handle The verify handle
/// @param[in] p_image Image data
/// @param[in] p_face_key_points Face landmarks
/// @param[in] face_key_points_size Number of face landmarks
/// @param[out] feature Feature array, allocated by the user
/// @param[out] feature_size Length of the feature array
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_verify_get_feature(st_handle_t handle,
                             const st_image_t *p_image,
                             const st_pointf_t *p_face_key_points,
                             unsigned int face_key_points_size,
                             char **feature,
                             unsigned int *feature_size);

#define ST_MOBILE_FEATURE_MAX_SIZE 5000
/// \~chinese
/// @brief 获取多个人脸的人脸特征
/// @param[in] handle verify句柄
/// @param[in] p_image 图像数据
/// @param[in] p_faces 人脸信息, 必须包含106点
/// @param[in] face_count 人脸个数
/// @param[out] features 特征数组, 由用户分配内存, 需要包含face_count个char数组, 建议分配的每个字符串长度不小于ST_MOBILE_FEATURE_MAX_SIZE
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
/// \~english
/// @brief Get face features for multiple faces
/// @param[in] handle The verify handle
/// @param[in] p_image The image data
/// @param[in] p_faces The face information, must contain 106 keypoints
/// @param[in] face_count Number of faces
/// @param[out] features The feature array, allocated by the user. It is recommended to allocate each string with a length not less than ST_MOBILE_FEATURE_MAX_SIZE
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_verify_get_feature_multi_face(
	st_handle_t handle,
	const st_image_t *p_image,
	const st_mobile_face_t * p_faces,
	unsigned int face_count,
	char** features
);
/// \~chinese
/// @brief 特征比较
/// @param[in] handle verify句柄
/// @param[in] p_feature 第一个特征信息
/// @param[in] feature_size 第一个特征信息长度
/// @param[in] p_other_feature 第二个特征信息
/// @param[in] other_feature_size 第二个特征信息长度
/// @param[out] score 两个特征信息的比较结果分数，有效范围（0,1)
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
/// \~english
/// @brief Compare two features
/// @param[in] handle The verify handle
/// @param[in] p_feature The first feature information
/// @param[in] feature_size The length of the first feature information
/// @param[in] p_other_feature The second feature information
/// @param[in] other_feature_size The length of the second feature information
/// @param[out] score The comparison score between the two feature information, with a valid range of (0, 1)
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_verify_get_features_compare_score(st_handle_t handle,
                                            const char *p_feature,
                                            unsigned int feature_size,
                                            const char *p_other_feature,
                                            unsigned int other_feature_size,
                                            float *score);
/// \~chinese
/// @brief 从一组特征数组中搜索最近的若干特征
/// @param[in] handle 已初始化的句柄
/// @param[in] p_query 待搜索的特征信息
/// @param[in] p_list_feature 特征信息数组
/// @param[in] list_count 特征信息数量
/// @param[in] top_k 最大的特征搜索数量
/// @param[out] top_idxs 搜索到的特征数据库索引值数组(由用户分配和释放)
/// @param[out] top_scores 搜索到的特征相似度得分数组(由用户分配和释放), 范围0-1, 得分越接近1越相似
/// @param[out] result_length 实际搜索到的特征数量
/// @return 成功返回ST_OK, 否则返回错误类型
/// @note 返回的结果以1作为起始索引
/// \~english
/// @brief Search for the nearest features from an array of feature information
/// @param[in] handle The initialized verify handle
/// @param[in] p_query The feature information to search for
/// @param[in] p_list_feature The array of feature information
/// @param[in] list_count The number of feature information in the array
/// @param[in] top_k The maximum number of features to search
/// @param[out] top_idxs The array of indexes of the searched features in the feature database (allocated and released by the user)
/// @param[out] top_scores The array of similarity scores of the searched features (allocated and released by the user), ranging from 0 to 1. The closer the score is to 1, the more similar the features are
/// @param[out] result_length The actual number of features searched
/// @return Return ST_OK on success, or an error code on failure
/// @note The returned results are indexed starting from 1
ST_SDK_API
st_result_t
st_mobile_verify_search_nearest_features(st_handle_t handle,
                                         const char *p_query,
                                         char * const *p_list_feature,
                                         int list_count,
                                         unsigned int top_k,
                                         int *top_idxs,
                                         float *top_scores,
                                         unsigned int *result_length);

/// \~chinese
/// @brief 销毁句柄
/// @param[in] handle 已初始化的句柄
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
/// \~english
/// @brief Destroy handle
/// @param[in] handle The initialized verify handle
/// @return Return ST_OK on success, or an error code on failure. Error codes are defined in st_mobile_common.h, such as ST_E_FAIL, etc
ST_SDK_API st_result_t
st_mobile_verify_destroy(st_handle_t handle);

#endif //ST_MOBILE_VERIFY_H
