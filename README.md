### 【概述】

本文档描述了【AgoraSenseTime - 商汤插件】Flutter中的使用

author: peter.liu@ai4geeks.com

version: v1.0

Demo:

```bash
$ flutter pub get
$ flutter run
```

####  【数据结构】

详见flutter project

```dart
enum STEffectBeautyType {
  ST_MOBILE_FACE_DETECT_FULL(0x000000FF, .0, [0, 0]),
  ST_MOBILE_SEG_HAIR(0x20000000, .0, [0, 0]),

  EFFECT_BEAUTY_FILTER(501, .0, [0, 0]),

  // 1. 基础美颜
  EFFECT_BEAUTY_BASE_FACE_SMOOTH(103, .61, [0, 1.0]), // 磨皮
  EFFECT_BEAUTY_BASE_WHITTEN(101, .34, [0, 1.0]), // 美白
  EFFECT_BEAUTY_BASE_REDDEN(102, .37, [0, 1.0]), // 红润
  EFFECT_BEAUTY_RESHAPE_SHRINK_FACE(201, .34, [0, 1.0]), // 瘦脸
  EFFECT_BEAUTY_RESHAPE_NARROW_FACE(204, .24, [0, 1.0]), // 窄脸
  EFFECT_BEAUTY_RESHAPE_SHRINK_JAW(203, .35, [0, 1.0]), // 小脸
  EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE(202, .38, [0, 1.0]), // 大眼
  EFFECT_BEAUTY_TONE_SHARPEN(603, .5, [0, 1.0]), // 锐化
  EFFECT_BEAUTY_TONE_CLEAR(604, .3, [0, 1.0]), //  清晰度

  // 2. 微整形项
  // 2.1 Face
  EFFECT_BEAUTY_PLASTIC_THINNER_HEAD(301, 0, [0, 1.0]), // 小头
  EFFECT_BEAUTY_PLASTIC_THIN_FACE(302, 0, [0, 1.0]), // 瘦脸
  EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH(303, -.15, [-1.0, 1.0]), // 下巴
  EFFECT_BEAUTY_PLASTIC_HAIRLINE_HEIGHT(304, 0, [-1.0, 1.0]), // 额头
  EFFECT_BEAUTY_PLASTIC_HAIRLINE(328, 0, [-1.0, 1.0]), // 发际线
  EFFECT_BEAUTY_PLASTIC_SHRINK_JAWBONE(320, 0, [0, 1.0]), // 下颚骨 (实际不存在)
  EFFECT_BEAUTY_PLASTIC_APPLE_MUSLE(305, 0, [0, 1.0]), // 苹果肌
  EFFECT_BEAUTY_PLASTIC_SHRINK_CHEEKBONE(318, 0, [0, 1.0]), // 颧骨

  // 2.2 Eyes
  EFFECT_BEAUTY_PLASTIC_EYE_DISTANCE(311, -.20, [-1.0, 1.0]), // 眼距
  EFFECT_BEAUTY_PLASTIC_BRIGHT_EYE(314, .25, [0, 1.0]), // 亮眼
  EFFECT_BEAUTY_PLASTIC_EYE_ANGLE(312, 0, [-1, 1]), // 眼睛角度
  EFFECT_BEAUTY_PLASTIC_REMOVE_DARK_CIRCLES(315, .69, [0, 1.0]), // 祛黑眼圈
  EFFECT_BEAUTY_PLASTIC_EYE_HEIGHT(326, 0, [-1, 1]), // 眼睛上下移

  // 2.3 Nose
  EFFECT_BEAUTY_PLASTIC_NARROW_NOSE(306, 0, [0, 1.0]), // 瘦鼻翼
  EFFECT_BEAUTY_PLASTIC_NOSE_LENGTH(307, 0, [-1.0, 1.0]), // 长鼻
  EFFECT_BEAUTY_PLASTIC_PROFILE_RHINOPLASTY(308, 0, [0, 1.0]), // 侧脸隆鼻

  // 2.4 Features
  EFFECT_BEAUTY_PLASTIC_MOUTH_SIZE(309, 0, [-1, 1]),                 // 嘴型
  EFFECT_BEAUTY_PLASTIC_PHILTRUM_LENGTH(310, .20, [-1, 1]),          // 缩人中
  //TYPE_WZH_3D_NEW_2(80127, .0), 3D ignore
  EFFECT_BEAUTY_PLASTIC_WHITE_TEETH(317, .20, [0, 1.0]),             // 白牙
  EFFECT_BEAUTY_PLASTIC_REMOVE_NASOLABIAL_FOLDS(316, .60, [0, 1.0]), // 祛法令纹

  // 3. makeup
  EFFECT_BEAUTY_MAKEUP_HAIR_DYE(401, .0, [.0, .0]),   // 染发
  EFFECT_BEAUTY_MAKEUP_LIP(402, .0, [.0, .0]),        // 口红
  EFFECT_BEAUTY_MAKEUP_CHEEK(403, .0, [.0, .0]),      // 腮红
  EFFECT_BEAUTY_MAKEUP_NOSE(404, .0, [.0, .0]),       // 修容
  EFFECT_BEAUTY_MAKEUP_EYE_BROW(405, .0, [.0, .0]),   // 眉毛
  EFFECT_BEAUTY_MAKEUP_EYE_SHADOW(406, .0, [.0, .0]), // 眼影
  EFFECT_BEAUTY_MAKEUP_EYE_LINE(407, .0, [.0, .0]),   // 眼线
  EFFECT_BEAUTY_MAKEUP_EYE_BALL(409, .0, [.0, .0]),   // 美瞳

  ;

  final int type_value;
  final double default_val;
  final List<double> range;

  const STEffectBeautyType(this.type_value, this.default_val, this.range);
}
```

#### 【证书认证+模型载入】

调用例子如下：

```dart
Future<void> _checklicense() async {
    await _setExtensionProperty("st_mobile_check_activecode", {
      "license_path": await _copyAsset("Resource/license/SenseMARS_Effects.lic"),
    });

    await _setExtensionProperty("st_mobile_human_action_create", {
      "model_path": await _copyAsset("Resource/models/M_SenseME_Face_Video_Template_p_4.0.0.model"),
      "config": STEffectBeautyType.ST_MOBILE_FACE_DETECT_FULL.type_value,
    });

    await _setExtensionProperty("st_mobile_human_action_add_sub_model", {
      "model_path": await _copyAsset("Resource/models/M_SenseME_Segment_Hair_p_4.4.0.model"),
    });

    await _setExtensionProperty("st_mobile_effect_create_handle", {});
}
```



#### 【基础美颜】

调用例子如下：（磨皮 + 默认参数）

```dart
await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_BASE_FACE_SMOOTH.type_value,
      "val": STEffectBeautyType.EFFECT_BEAUTY_BASE_FACE_SMOOTH.default_val
    });
```

| 配置项 | val  | param                                                        |
| ------ | ---- | ------------------------------------------------------------ |
| 磨皮   | 0.61 | STEffectBeautyType.EFFECT_BEAUTY_BASE_FACE_SMOOTH.type_value |
| 美白   | 0.34 | STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN.type_value     |
| 红润   | 0.37 | STEffectBeautyType.EFFECT_BEAUTY_BASE_REDDEN.type_value      |
| 瘦脸   | 0.34 | STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_SHRINK_FACE.type_value |
| 窄脸   | 0.24 | STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_NARROW_FACE.type_value |
| 小脸   | 0.35 | STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_SHRINK_JAW.type_value |
| 大眼   | 0.38 | STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE.type_value |
| 锐化   | 0.50 | STEffectBeautyType.EFFECT_BEAUTY_TONE_SHARPEN.type_value     |
| 清晰度 | 0.30 | STEffectBeautyType.EFFECT_BEAUTY_TONE_CLEAR.type_value       |

#### 【滤镜】

调用例子如下：（babypink + 1.0效果）

```json
await _setExtensionProperty("st_mobile_effect_set_beauty", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_FILTER.type_value,
      "path": await _copyAsset("Resource/filter_portrait/filter_style_babypink.model"),
    });

    await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH.type_value,
      "val": 1.0
    });
```

#### 【贴纸】

调用贴纸如下：

```dart
await _setExtensionProperty("st_mobile_effect_add_package", {
      "path": await _copyAsset("Resource/stickers/2d_flower.zip"),
    });

// 删除
await _setExtensionProperty("st_mobile_effect_remove_package", {
      "path": await _copyAsset("Resource/stickers/2d_flower.zip"),
    });

```

#### 【微整形】

调用例子如下：

```dart
await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_PLASTIC_THINNER_HEAD.type_value,
      "val": 1.0
    });

    // // 2.1 Face
    // EFFECT_BEAUTY_PLASTIC_THINNER_HEAD(301, 0, [0, 1.0]), // 小头
    // EFFECT_BEAUTY_PLASTIC_THIN_FACE(302, 0, [0, 1.0]), // 瘦脸
    // EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH(303, -.15, [-1.0, 1.0]), // 下巴
    // EFFECT_BEAUTY_PLASTIC_HAIRLINE_HEIGHT(304, 0, [-1.0, 1.0]), // 额头
    // EFFECT_BEAUTY_PLASTIC_HAIRLINE(328, 0, [-1.0, 1.0]), // 发际线
    // EFFECT_BEAUTY_PLASTIC_SHRINK_JAWBONE(320, 0, [0, 1.0]), // 下颚骨 (实际不存在)
    // EFFECT_BEAUTY_PLASTIC_APPLE_MUSLE(305, 0, [0, 1.0]), // 苹果肌
    // EFFECT_BEAUTY_PLASTIC_SHRINK_CHEEKBONE(318, 0, [0, 1.0]), // 颧骨
    //
    // // 2.2 Eyes
    // EFFECT_BEAUTY_PLASTIC_EYE_DISTANCE(311, -.20, [-1.0, 1.0]), // 眼距
    // EFFECT_BEAUTY_PLASTIC_BRIGHT_EYE(314, .25, [0, 1.0]), // 亮眼
    // EFFECT_BEAUTY_PLASTIC_EYE_ANGLE(312, 0, [-1, 1]), // 眼睛角度
    // EFFECT_BEAUTY_PLASTIC_REMOVE_DARK_CIRCLES(315, .69, [0, 1.0]), // 祛黑眼圈
    // EFFECT_BEAUTY_PLASTIC_EYE_HEIGHT(326, 0, [-1, 1]), // 眼睛上下移
    //
    // // 2.3 Nose
    // EFFECT_BEAUTY_PLASTIC_NARROW_NOSE(306, 0, [0, 1.0]), // 瘦鼻翼
    // EFFECT_BEAUTY_PLASTIC_NOSE_LENGTH(307, 0, [-1.0, 1.0]), // 长鼻
    // EFFECT_BEAUTY_PLASTIC_PROFILE_RHINOPLASTY(308, 0, [0, 1.0]), // 侧脸隆鼻
    //
    // // 2.4 Features
    // EFFECT_BEAUTY_PLASTIC_MOUTH_SIZE(309, 0, [-1, 1]), // 嘴型
    // EFFECT_BEAUTY_PLASTIC_PHILTRUM_LENGTH(310, .20, [-1, 1]), // 缩人中
    // //TYPE_WZH_3D_NEW_2(80127, .0), 3D ignore
    // EFFECT_BEAUTY_PLASTIC_WHITE_TEETH(317, .20, [0, 1.0]), // 白牙
    // EFFECT_BEAUTY_PLASTIC_REMOVE_NASOLABIAL_FOLDS(316, .60, [0, 1.0]), // 祛法令纹
```

#### 【美妆】

调用例子如下：

注意，有些美妆需要载入分割模型，详见【证书认证+模型载入】

```dart
await _setExtensionProperty("st_mobile_effect_set_beauty", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_MAKEUP_HAIR_DYE.type_value,
      "path": await _copyAsset("Resource/red_rBBj0WB89tmAL9GPAADD1Nch9Os329_50202204281925350377.zip")
    });

    await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_MAKEUP_HAIR_DYE.type_value,
      "val": 0.8
    });
```

* 美妆资源下载链接【已分析完整】
* 【染发】EFFECT_BEAUTY_MAKEUP_HAIR_DYE：

"name: purple - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/purple_rBBj0WB89smAOCpRAAAHhNdw6k4712_50202204281925356577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=289d4bce9fd794e0e49fd723e35ee61cfa45d306af5c56c4c8cf18fbe7dc6679"
"name: red - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/red_rBBj0WB89tmAL9GPAADD1Nch9Os329_50202204281925350377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=e0363d009e20cad7a0ac5ad510d3746c98199cbec6d9bb61e9c488aa6627fc8a"
"name: winered - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/winered_rBBj0WB89uaAPKvIAABZJMaWSwA970_50202204281925358777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=3afa30bf68eec712da520a84435ef04a6dcc69d271edb89599b76dd1c019d19a"
"name: yellow - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/yellow_rBBj0WB89vGAX_KgAAAT9O8crKs965_50202204281925366277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=a3f97b05638a9f472eb11ac56c9bc526899b49907d1451a5012deed18a22475c"
"name: blue - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/blue_rBBiLWB89hOAVdLZAAAHVK1imoY313_50202204281925342577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=d1aaeafec7d558a8db0c03e5f48095f49673b9817c90eb3c8fa8f31231f74b26"
"name: green - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/green_rBBj0WB89quAanNfAAAIBCMCOp8123_50202204281925347777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=984f5768afec19c17abf65e989ab8ce6a62e600d91095bc58b31cebd8124053e"
"name: grey - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/grey_rBBj0WB89r6ANrygAAAH9DWKVwk942_50202204281925348377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=fea7c349d96c657988fdbbea543a18222e0aa361731469656c47b8b0b344c8a9"

* 【口红】EFFECT_BEAUTY_MAKEUP_LIP：

"name: 10自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/10%E8%87%AA%E7%84%B6_rBBiLWAahTKADciFAABVBEc3u9k088_50202204281925304077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=584100ddef41ed4234249df8c10e23724c4fb071e3b189d84790f348dac196ad"
"name: 13自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/13%E8%87%AA%E7%84%B6_rBBiLWAaf-yAGibCAABWhKzRXmA751_50202204281925307777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=53b6628a79ec56521c388aad256b811c2a956d3c3f99fcb752f2dde385522933"
"name: 10闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/10%E9%97%AA%E7%83%81_rBBiLWAamBuAFQ5MAAAn9EW1z3U583_50202204281925297877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=e61db030c9f07693302c71297f4a42c4e7ec2c5004bb0b21a717692fca1ad65f"
"name: 10水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/10%E6%B0%B4%E6%B6%A6_rBBiLWAah3yAIyxCAAAn9HK63Xo905_50202204281925290877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=518229b688e1be5d44a2f65e8102782572bf285c59d23ae6b73f070613dc69db"
"name: 10雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/10%E9%9B%BE%E9%9D%A2_rBBiLWAahoWAC2tJAAAn5OLHQ5U595_50202204281925291677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=1e1cf7c26f89cf6a3ac4cdc2b9a7c29115e1139ac38b54b8219a8e410f3d037c"
"name: 9水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/9%E6%B0%B4%E6%B6%A6_rBBj0WAai4mAQHRXAAAsBFvxyrE014_50202204281925280177.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=e53a38a44925d4bb55d334e62fa5e1f83339bcfdee1463683e5a84e0f64b9784"
"name: 9雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/9%E9%9B%BE%E9%9D%A2_rBBj0WAai5-AAIUVAAAsBAKd-yY668_50202204281925285277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=887e79667d2c6f5ef2eb30f9c17bad342be2d63f0853655cfa1db1e7223d8dc1"
"name: 9自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/9%E8%87%AA%E7%84%B6_rBBj0WAai7WAe3udAAAr9F2alG8254_50202204281925285877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=3df70c0c17c5340eae21f3062f080e48cd3ef7c22883fede513fa230586ed087"
"name: 10金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/10%E9%87%91%E5%B1%9E_rBBiLWAbYKyAQZSgAAAn5DUSUpQ284_50202204281925293477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=5fd41f91fcef277f1caf9234dbbac0bcd8bcb3e8c4849f781216d9ebdd8020f4"
"name: 8雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/8%E9%9B%BE%E9%9D%A2_rBBiLWAaj12ADRhZAAAslMwsnPk277_50202204281925279277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=69120f8d76238b9d9c2f2a0923132f87bc3b13b25d080af29a8e747b7cbd0ce5"
"name: 8自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/8%E8%87%AA%E7%84%B6_rBBj0WAaj3iAYR-DAAAslJgXMqQ695_50202204281925273077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=2fcf3a28408c085ef33adafd2a63b51676fd50a60992b6c11dfeab21c8625681"
"name: 9金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/9%E9%87%91%E5%B1%9E_rBBj0WAb3S-AROdTAAAsBHDcRl0522_50202204281925272977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=18ac13f77dd660c691e057d325e6053f8dd88f7ba7deb7b7d84732208ef0fc4a"
"name: 9闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/9%E9%97%AA%E7%83%81_rBBiLWAai2mATll_AAAsFPJR-PM351_50202204281925287977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=0b89fd9de080a55498d59b1e88d48c0970df87e080c66c9637fa0ab5526d83a1"
"name: 7自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/7%E8%87%AA%E7%84%B6_rBBiLWAaimqAA2E-AAAshHG_tn4723_50202204281925268977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=669e976769dc77b6ba5d9f0b6587bab3bca246d410c9d530dcd556abc3645e3e"
"name: 8金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/8%E9%87%91%E5%B1%9E_rBBj0WAajxaAGrlyAAAslC3W_XQ815_50202204281925269877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=8319672ceb4d559b3941f3e7931a0df457b5a0cba5a7d5d0d19f8f33ed398dfd"
"name: 8闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/8%E9%97%AA%E7%83%81_rBBiLWAajzKADjweAAAspEyMsoQ342_50202204281925262977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=343cf84b28f9357d111ccc652fd795c65735f2cbebd7818ddcf7e1a6bac93647"
"name: 8水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/8%E6%B0%B4%E6%B6%A6_rBBiLWAaj0iAGT7zAAAspOkEndM887_50202204281925267277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=64f55b57a5d454ef398513b11dbb00652c7b1097e50929884047be322528c3a5"
"name: 7闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/7%E9%97%AA%E7%83%81_rBBj0WAaiieARg1gAAAslCO0FNs925_50202204281925258777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=06675a3da28ef0591db7b0a1464156c8a0ccff028c89f29efb2f9ffb3feb8305"
"name: 7水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/7%E6%B0%B4%E6%B6%A6_rBBj0WAaij6AOrzSAAAslKKllxo608_50202204281925253577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=6dd3da914d2c1d6b403414bf9512528c61ff2a16f27ac1d56e0da21e44f02360"
"name: 7雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/7%E9%9B%BE%E9%9D%A2_rBBiLWAaileAeOvoAAAshBb9XIk768_50202204281925250377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=280273f121f68751f1d1a46d1662756fee317ff7fe9f4cf37a096433d486f9c0"
"name: 7金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/7%E9%87%91%E5%B1%9E_rBBiLWAb3PKAVNb4AAAshB4Sels730_50202204281925254477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=65084157ad18f7915afd4b02af70d69e816b3d4ccde26468547c4753eb652061"
"name: 6闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/6%E9%97%AA%E7%83%81_rBBj0WAaiI2AGGqRAAAvtHdCksU955_50202204281925243577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=ec560d3da10137e2d8faf241b97ac59515d191921f02bc8658021e8eb67f034e"
"name: 6水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/6%E6%B0%B4%E6%B6%A6_rBBiLWAaiKWAMVIIAAAvtKklsBI163_50202204281925241577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=3cd251dcc13e18ef254cd0aee37d6c2a19945aad7a912320cf2fdea60c81a26a"
"name: 6雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/6%E9%9B%BE%E9%9D%A2_rBBj0WAaiNCAVIPqAAAvpE_LecE253_50202204281925245777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=1fffae14369268d599d0fe263089330bdc1a8d164244e432221b9931d371ffa0"
"name: 5水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/5%E6%B0%B4%E6%B6%A6_rBBiLWAahn2ANMIUAAAhhDK7__Y418_50202204281925232977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=992742477e0793aa6e12729fbb642fab4350dfab0b489bc906bb29a17570a4a3"
"name: 5雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/5%E9%9B%BE%E9%9D%A2_rBBiLWAahpGAOIPAAAAhdAijfJk356_50202204281925233277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=7c49bae1b6d2b61133e7bf3ad08452dbefde3ff081a575f044a8389a8d8ce326"
"name: 5自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/5%E8%87%AA%E7%84%B6_rBBiLWAb3NaAMquNAAAhdEbzfuk583_50202204281925231577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=d1f9a1ba521375f4827836cbfa81ef1b890c54084ad2fcb709b5adfef3c901ad"
"name: 6金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/6%E9%87%91%E5%B1%9E_rBBj0WAaiHiACAb3AAAvpCeCY10839_50202204281925242277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=2431165d92bd2a4085eeb895e139cd2c7fa886c18edd0180a8c5c0d7ce22762d"
"name: 4雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/4%E9%9B%BE%E9%9D%A2_rBBiLWAahEKASTt6AAAqZDKDbbA348_50202204281925225377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=3672b62cdb480bfc4a5c45b434ee79271bbd41a7b173d8b0b1ee403cac939295"
"name: 4自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/4%E8%87%AA%E7%84%B6_rBBiLWAahFOAEjGtAAAqZGL1ccw674_50202204281925226077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=0ce430ce5a8d6e6d15d1b9312c840bc331eae9a8f7a8827bc9f15f470f45084b"
"name: 5金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/5%E9%87%91%E5%B1%9E_rBBj0WAahlKAESvmAAAhdFOf7Qw612_50202204281925220577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=6c6c851473072934bdc77041f85a9c3b2206acba09b2a2c4727f5b84a195e1fd"
"name: 5闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/5%E9%97%AA%E7%83%81_rBBj0WAahmeAZ6HOAAAhhJhTzQ4243_50202204281925220377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=6b79607e35a333cb8d25ea7e53e7f1a0979da2502d799a25103e70498e3ac4c8"
"name: 4金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/4%E9%87%91%E5%B1%9E_rBBiLWAahBKAYhbDAAAqZGckLzk300_50202204281925216677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=cee22a0cbc34f6a32e77852bb8b5addd2b7e48517b7de63e5b9a87f2beb21cdd"
"name: 4闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/4%E9%97%AA%E7%83%81_rBBiLWAb3MGATnv4AAAqdOypDbc190_50202204281925218077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=9c12b1c7f764a2627ec8be293055872054a22e9d4301e1f1f07f3ec28e3ef1bc"
"name: 4水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/4%E6%B0%B4%E6%B6%A6_rBBiLWAahCmAJjMXAAAqdPHzA_k052_50202204281925214977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=052b75f22ea4726839d236455af72c14dae9fbfdff349b8e306611ce1946a788"
"name: 3闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/3%E9%97%AA%E7%83%81_rBBj0WAb3J-AEN6WAAAmdMtVJnM451_50202204281925204077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=77c314dabeedd844b025065233b2f058af1670f7944dc1ceb6fbb4c093477465"
"name: 3水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/3%E6%B0%B4%E6%B6%A6_rBBiLWAagoSAaB4JAAAmdFvztfo119_50202204281925203677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=1e2d5faf4ce996d6d4ba9f7ecb0ed86c14d4dbde2f09f16b0d8e255ef1794d5c"
"name: 3雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/3%E9%9B%BE%E9%9D%A2_rBBiLWAagpeAWx9nAAAmZKRIV0w348_50202204281925207777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=cc5156b043ad5a98e8667e00ebf9cea2dcc181b861b3394695d832303715d48d"
"name: 3自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/3%E8%87%AA%E7%84%B6_rBBj0WAagqyAeYkOAAAmZEZEfpc748_50202204281925215077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=fda656770ef1e91657095478041f25cd3af174198e36d384a67b55cc598d5df5"
"name: 2水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/2%E6%B0%B4%E6%B6%A6_rBBiLWAagF-AT3SJAAAqRDP40zo829_50202204281925193977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=e12aeb9c9638c29c50b31d97c034dc0259219f9801f2dcf12b9d44ef9ae7d96d"
"name: 2雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/2%E9%9B%BE%E9%9D%A2_rBBiLWAagHaAfBGqAAAqNPP3aqM735_50202204281925193877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=730469e313ebd34eb2165141ab01b0ecfab1f294f6571d66e4416f66c5e942b7"
"name: 2自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/2%E8%87%AA%E7%84%B6_rBBj0WAagImAWOthAAAqNGbf6vQ619_50202204281925191677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=bce38b89068a2552e26d8ac64bc221ea8c4035d1fa7f422f94de741eede85130"
"name: 3金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/3%E9%87%91%E5%B1%9E_rBBiLWAagmuAQuQtAAAmZNDgl4o918_50202204281925201577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=dbe2d67620ca793f579fccc2bd4bbf1e18fee0388ab53edfc92d161c255143e7"
"name: 1自然 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/1%E8%87%AA%E7%84%B6_rBBj0WAakJKATFytAABg9M117lE698_50202204281925189377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=7c25bdf0be8c2efbf72ae94f1cfc55fb112519e62897bb83c5534c69bb10dac0"
"name: 2金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/2%E9%87%91%E5%B1%9E_rBBj0WAacs6ANS4zAABjJOTZBY4079_50202204281925181477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604798&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=edb0c844a0147c57dc6cc78dd171c2d38e6371106955413b030716ee18c37dbe"
"name: 2闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/2%E9%97%AA%E7%83%81_rBBj0WAagEuAHb9dAAAqRIdcmgo626_50202204281925183277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=f2067b19a689456a51b2575cf798fd5e11876218509f897761cb789cb8fb5d1e"
"name: 1金属 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/1%E9%87%91%E5%B1%9E_rBBj0WAZQFaALi9mAABgxEoTh4o368_50202204281925177477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=aee20bc6b38bfe3816c19750e4ba801f90c73ed905b5e420b1ef19bae199ea05"
"name: 1闪烁 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/1%E9%97%AA%E7%83%81_rBBiLWAakB-AB4mlAABhdLwjCFI062_50202204281925175277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=f5b2d9cfda6db9a545ac7d86ed59d900499dca6e973a24dec9ba5986cab5827c"
"name: 1水润 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/1%E6%B0%B4%E6%B6%A6_rBBiLWAace6AV8tNAABaFPYqPuM471_50202204281925172477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=c53da39043e90937d91e74d55ce46d5e6570b58b545b264cfcb2a4a656d07d66"
"name: 1雾面 - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/1%E9%9B%BE%E9%9D%A2_rBBiLWAach6ANMwIAABjJMhvfeI350_50202204281925188677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604798&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=9341fab6c8dd930c0d9ddf9f5caaabf6ad7c0138ba66aadd314b5b3d16dc9c79"

* 【腮红】EFFECT_BEAUTY_MAKEUP_CHEEK：

"name: blushd - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/material/77/blushd_50202204282009301777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T084846Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=f1c0e3692c57ffd3ce053cd32136ef916921d3a42cb4e11d9dfda711ede95a8a"
"name: blushc - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/blushc_rBBiLWARKOuAcphyAAA5VBMTHSI144_50202204281925363677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T084846Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=5b604418b5d344166f0388968298d58dde8eb67963472bbe2589c8f6bdd005e9"
"name: blushb - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/blushb_rBBiLWARJ4uALnWKAABtxNKmxX0655_50202204281925364477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T084846Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=fe6701c0a79963b57b8999ea5d06114b28f82a936aaa3eba36f9ec3a69c7b49d"
"name: blushg - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/blushg_rBBiLWARKeWAaYNTAABeZG0uMDw682_50202204281925373577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T084846Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=4e29733519b85ba7202e2a9bcfa6c3c199aa0bacb2d846d5916f66bef263c40f"
"name: blushf - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/blushf_rBBiLWARKc-AK-ppAACE1NgtLK8626_50202204281925375877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T084846Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=70917e55d37074bee9fde471daec4fcd42b62ff4273c3082cf857ecea0f9edfc"
"name: blushe - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/blushe_rBBiLWARKbSAKd-OAAB-BFrJZ1I316_50202204281925374477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T084846Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=c81ea1662c62af53f512947c1edc5dd5a5a3a71d09f44f4053bd0ca3b9c6f2eb"

* 【修容】EFFECT_BEAUTY_MAKEUP_NOSE：

"name: faceb - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/faceb_rBBiLWARSoiAUXMPAABlhIh0jXk602_50202204281925380477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=dcd851c6570c187141a616073d64c7d33803cecc133c451b30918a1a3c228d87"
"name: facec - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/facec_rBBiLWARSqaAFAqoAACDlEaZHVc582_50202204281925382577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=d9b9fd3cc3a3e97476c182bdefbf84e983b794f3a5513f658aef14d64affb5da"
"name: faced - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/faced_rBBiLWARSxCAdULdAABapPOHSzk211_50202204281925389777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=6e1453ed4e46d9f25a91c136c5fd1e37f1e871ed43457545d7ac990638e4e291"
"name: facea - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/facea_rBBiLWGx0QmAeilpAABypCgVRqo992_50202204281925374077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=a83a8de1daad95d8989da0c6fd65edec87c8bf2ed9b9dd51118b9dc61f2ab57a"

* 【眉毛】EFFECT_BEAUTY_MAKEUP_EYE_BROW

"name: browh - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browh_rBBj0WARK8qALOnxAAA1lNUWSlU517_50202204281925324477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=d32f94bb1d8147155c597eab91819073517e14729ba624aed65b1693c25555b6"
"name: browd - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browd_rBBj0WARKx-AeU9bAABHRDVw0_8456_50202204281925310277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=bd65b8b6c66803efcffc3ed0cabd7292018d38fd4c5c8508f27181c53ecb2642"
"name: browe - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browe_rBBj0WARKzaAXpLDAAA-xF6n19U402_50202204281925310777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604798&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=46b9e4243c582b6430e6793c033933729b108740cc632d160d5d4ae47b23f8a6"
"name: browf - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browf_rBBiLWARK3SAfhrIAAA1dITxSNk722_50202204281925315577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=e1c0d7a27387e2a08f8926d88a473c155a979a64696b15128cf047659e857fe9"
"name: browg - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browg_rBBiLWARK5eAXx9jAAA-1D0juak552_50202204281925322377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=a517159793891d1514b48c96dc7e6579290925eb779e1c10dadce5846d4d9fe8"
"name: browa - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browa_rBBj0WGxpXWAZGDSAAANZDR1l9w911_50202204281925305577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=2d609b2bb8c4350ba305a3eebcd7857599c5b3743f14224d9d3324b3303c952d"
"name: browc - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/browc_rBBj0WARKt2ATghRAAANlGGwmrI561_50202204281925317677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=83dffd0bb20024c069e4ad7f960a7df8ae0727b649192a670bc537555cd96744"

* 【眼影】EFFECT_BEAUTY_MAKEUP_EYE_SHADOW

"name: eyeshadowl - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowl_rBBj0WARPCiAUujdAACmNGuCbMM752_50202204281925450477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=62cd71179fd185a2fbf1315b04cdf810f63583ca0b05ff2d4b15c826603f081b"
"name: eyeshadowg - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowg_rBBiLWAROVGAKEH2AAAkdPyoz54599_50202204281925443177.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=c14046715085addff621390c93a9e50a020f02c097af5d37df5f925e3ede6e94"
"name: eyeshadowh - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowh_rBBj0WAROa6ALZyNAABMdDZ80KE735_50202204281925444677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=bc22c4b8eab2355954c140e050dd160a68f826f2ef30d54426680bdc78e684c9"
"name: eyeshadowi - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowi_rBBiLWARO4OARbW9AABNJE-H48w047_50202204281925445077.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=05a2e4b83fb4d6be0f856c82c630b84ce45c332f7395c593e2d48f2b7d301b1b"
"name: eyeshadowj - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowj_rBBj0WARO8yADkOgAABpdG_9QcM687_50202204281925450377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=287bad63595dba6f6ad7b36843fcab893be9229e5727baa87accb3d90fee9f1a"
"name: eyeshadowc - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowc_rBBiLWAROJyABz_GAABDJKKW4-8783_50202204281925436477.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=bf9a9c212e340f41b6b12af9587b7ee8b08fcc68c46d3e865b1534b6134e7dfd"
"name: eyeshadowd - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowd_rBBiLWAROMSADklvAAAhpHSHcxQ948_50202204281925438177.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=9e2032626f44f644008459e866c4110f862083a3f11cba91fbcca58f54d9ffeb"
"name: eyeshadowe - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowe_rBBj0WAROP6AU69MAAAxVG09Arw964_50202204281925439677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=980effd52db33b2693a5a00e0db3ea9360deeeb40fb3e04b53b140248f7290fa"
"name: eyeshadowf - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowf_rBBj0WARORiAKZqUAAAiZJfeBbg722_50202204281925434977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=9fe587fa05af0e3f45bd738344039b677797c60ac6c58272ce01c543292cbc80"
"name: eyeshadowb - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeshadowb_rBBj0WAROA-ASd9TAACpBBfqz_Y554_50202204281925426277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=a169868f44232dca3004160b598d37573c7af89c14125c0d63e360112f7c2710"

* 【眼线】EFFECT_BEAUTY_MAKEUP_EYE_LINE

"name: eyelinerj - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelinerj_rBBiLWARNsOABfG3AAAdtEVZXr8205_50202204281925426177.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=ec7ce12804f2fccca3d4c2dbf2a3bce86fc72f3e579d483b52f26535bc88d379"
"name: eyelinern - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelinern_rBBiLWARN72Aa_icAAAxZF9979c621_50202204281925428877.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=f5956df5c5adab6ff4ac615fc94bbcdd56708da24d44d30675a34a1bacebef25"
"name: eyelinerb - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelinerb_rBBiLWARNVCAWVNAAAAfxMyRLV4821_50202204281925412277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=8ad14baebcab59da8190191333f2f546c6ae6e124280fd359c48f4d32f53470c"
"name: eyelinerd - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelinerd_rBBiLWARNYiADzcpAAAZJFrzpGY986_50202204281925413577.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=4a48eb3c6ae6beee2b78433264cf38c514b8987b4103f5cb7473b4296e58601d"
"name: eyelinerg - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelinerg_rBBj0WARNjeAZ6XcAAAlRDSzmhk952_50202204281925410677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=31f56b51387d6e83fa7fa86f9c64ebfbf31a577781df4196bb1fe49e943801f0"
"name: eyelineri - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelineri_rBBiLWARNp-Ad9L4AAAf1OTDcqA021_50202204281925423777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=edd42094d1b3d006cf5677f9031e74f77b1d5cc1572093da5f1c1979df7797f6"
"name: eyelinera - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyelinera_rBBiLWARN5-AIoilAAAnFPX9qNE074_50202204281925410777.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=aefc4adc13a84c26d23e48f6eddcee9e33f38437a048f870b70960a07c066d42"

* 【睫毛】EFFECT_BEAUTY_MAKEUP_EYE_LASH ：

"name: eyelashK - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/material/104/eyelashK_502023032121315891104.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=26df3d093346eff95647c8c6cc15d30be444b0fac3b171e4cd33e06dbf819956"
"name: eyelashG - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/material/104/eyelashG_502023032121314240104.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=76da14dbfe9278b691a757be6ace325aa67e2c9fa4614853136d488987c8efc8"
"name: eyelashF - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/material/104/eyelashF_502023032121293509104.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=5da60d6768e6765e4f90f28c40d3f0e8419f6fceba0099cec15ecb454ef9255a"
"name: eyelashE - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/material/104/eyelashE_502023032121274892104.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=f55b634d14dec5b7ef99612f198a835486b0ab3cb9d04299204b88a59ff97ff2"
"name: eyelash - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/material/104/eyelash_502023032121271081104.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=efc41d517aa5634cadf571ba6bc80e736dc5dea360535200a5eafd34405d48e3"

* 【美瞳】EFFECT_BEAUTY_MAKEUP_EYE_BALL：

"name: eyeballd - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeballd_rBBj0WARNBmAG5roAACsBN8bRDs905_50202204281925338677.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=25993260e8d5751334b71ec7dd9c9bf5e356ca12514d2b5103cefdc764f42514"
"name: eyeballe - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeballe_rBBj0WARNDKAYICmAAC5lCLgc40955_50202204281925332377.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=bc62747379a78dd4d6e300adda154891b7f53cb3bcf0a786621edd866b62ff8b"
"name: eyeballf - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeballf_rBBiLWARM-6AU0IOAAAihP__jDE866_50202204281925346977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=33b13fc444d2167d20c3b94c17d35b32e5403d7638d3d896eb85646db3970430"
"name: eyeballa - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeballa_rBBj0WGxpY2ALRAvAADlRLA9ZQc435_50202204281925324977.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=aaffccfe16b81b1241f23b03986dd5b9d19e6b9576cff41aab7ec577cb1f4f4e"
"name: eyeballb - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeballb_rBBj0WARLDWAax_4AAGTxDqYgU4422_50202204281925329277.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604798&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=79006a51ae49f9b93155d60dead0d6c3fa52c46041d84297de44b039f71afd93"
"name: eyeballc - pkgURL: https://effects-studio.oss-cn-hangzhou.aliyuncs.com/effects/material/77/eyeballc_rBBj0WARLGKARt56AACghBKnQjc239_50202204281925335177.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240220T071917Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604799&X-Amz-Credential=LTAI5t9H73Da2LgWAksj1FYB%2F20240220%2Foss%2Fs3%2Faws4_request&X-Amz-Signature=e71e711b08787f61c50797bed3f93923bc1455a743539423ea98392190067993"
