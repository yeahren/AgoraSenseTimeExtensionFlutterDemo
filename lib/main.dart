import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

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


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RtcEngine _rtcEngine = createAgoraRtcEngine();
  final RtcEngineEventHandler _rtcEngineEventHandler = RtcEngineEventHandler(
    onExtensionStarted: (String provider, String extension) {
      debugPrint('[onExtensionStarted] provider: $provider, extension: $extension');
    },

    onExtensionStopped: (String provider, String extension) {
      debugPrint('[onExtensionStopped] provider: $provider, extension: $extension');
    },

    onExtensionError: (String provider, String extension, int error, String message) {
      debugPrint('[onExtensionError] provider: $provider, extension: $extension');
    },

    onExtensionEvent: (String provider, String extension, String key, String value) {
      debugPrint('[onExtensionEvent] provider: $provider, extension: $extension, key: $key, value: $value');
    },
  );

  static const String _appId = "826dd9230eac428aba2e532b5d2fbdb4";

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _copyAsset(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    Directory appDocDir = await getApplicationDocumentsDirectory();

    final dirname = path.dirname(assetPath);

    Directory dstDir = Directory(path.join(appDocDir.path, dirname));
    if (!(await dstDir.exists())) {
      await dstDir.create(recursive: true);
    }

    String p = path.join(appDocDir.path, path.basename(assetPath));
    final file = File(p);
    if (!(await file.exists())) {
      await file.create();
      await file.writeAsBytes(bytes);
    }

    return file.absolute.path;
  }

  Future<void> _requestPermissionIfNeed() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await [Permission.microphone, Permission.camera].request();
    }
  }

  Future<void> _init() async {
    await _requestPermissionIfNeed();

    await _rtcEngine.initialize(const RtcEngineContext(
      appId: _appId,
      logConfig: LogConfig(level: LogLevel.logLevelNone),
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _rtcEngine.registerEventHandler(_rtcEngineEventHandler);

    await _initExtension();


    await _rtcEngine.enableVideo();
    await _rtcEngine.startPreview();

    // 0. 证书验证 + 模型载入
    await _checklicense();

    // 1. 基础美颜 演示
    await _baseBeautyDemo();

    // 2. 滤镜 演示
    await _filterBeautyDemo();

    // 3. 贴纸 演示
    await _stickerBeautyDemo();

    // 4. 微整形 演示
    await _plasticBeautyDemo();

    // 5. 美妆 演示
    await _makeupDemo();
  }


  Future<void> _initExtension() async {
    await _rtcEngine.enableExtension(
        provider: "SenseTime", extension: "Effect", enable: true);
  }

  Future<void> _setExtensionProperty(String key, Object value) async {
    await _rtcEngine.setExtensionProperty(
        provider: 'SenseTime',
        extension: 'Effect',
        key: key,
        value: jsonEncode(value));
  }

  Future<void> _checklicense() async {
    await _setExtensionProperty("st_mobile_check_activecode", {
      "license_path": await _copyAsset("Resource/license/SenseMARS_Effects.lic"),
    });

    await _setExtensionProperty("st_mobile_human_action_create", {
      "model_path": await _copyAsset("Resource/models/M_SenseME_Face_Video_Template_p_4.0.0.model"),
      "config": STEffectBeautyType.ST_MOBILE_FACE_DETECT_FULL.type_value,
    });

    await _setExtensionProperty("st_mobile_effect_create_handle", {
    });

  }

  Future<void> _baseBeautyDemo() async {
    await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_BASE_FACE_SMOOTH.type_value,
      "val": STEffectBeautyType.EFFECT_BEAUTY_BASE_FACE_SMOOTH.default_val
    });

    // // 1. 基础美颜
    // EFFECT_BEAUTY_BASE_FACE_SMOOTH(103, .61, [0, 1.0]), // 磨皮
    // EFFECT_BEAUTY_BASE_WHITTEN(101, .34, [0, 1.0]), // 美白
    // EFFECT_BEAUTY_BASE_REDDEN(102, .37, [0, 1.0]), // 红润
    // EFFECT_BEAUTY_RESHAPE_SHRINK_FACE(201, .34, [0, 1.0]), // 瘦脸
    // EFFECT_BEAUTY_RESHAPE_NARROW_FACE(204, .24, [0, 1.0]), // 窄脸
    // EFFECT_BEAUTY_RESHAPE_SHRINK_JAW(203, .35, [0, 1.0]), // 小脸
    // EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE(202, .38, [0, 1.0]), // 大眼
    // EFFECT_BEAUTY_TONE_SHARPEN(603, .5, [0, 1.0]), // 锐化
    // EFFECT_BEAUTY_TONE_CLEAR(604, .3, [0, 1.0]), //  清晰度
  }

  Future<void> _filterBeautyDemo() async {
    await _setExtensionProperty("st_mobile_effect_set_beauty", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_FILTER.type_value,
      "path": await _copyAsset("Resource/filter_portrait/filter_style_babypink.model"),
    });

    await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH.type_value,
      "val": 1.0
    });
  }

  Future<void> _stickerBeautyDemo() async {
    await _setExtensionProperty("st_mobile_effect_add_package", {
      "path": await _copyAsset("Resource/stickers/2d_flower.zip"),
    });

    // 删除
    // await _setExtensionProperty("st_mobile_effect_remove_package", {
    //   "path": await _copyAsset("Resource/stickers/2d_flower.zip"),
    // });
  }

  Future<void> _plasticBeautyDemo() async {
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

  }

  Future<void> _makeupDemo() async {
    // await _setExtensionProperty("st_mobile_human_action_create", {
    //   "model_path": await _copyAsset("Resource/models/M_SenseME_Segment_Hair_p_4.4.0.model"),
    //   "config": STEffectBeautyType.ST_MOBILE_SEG_HAIR.type_value | STEffectBeautyType.ST_MOBILE_FACE_DETECT_FULL.type_value,
    // });

    await _setExtensionProperty("st_mobile_effect_set_beauty", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_MAKEUP_HAIR_DYE.type_value,
      "path": await _copyAsset("Resource/red_rBBj0WB89tmAL9GPAADD1Nch9Os329_50202204281925350377.zip")
    });

    await _setExtensionProperty("st_mobile_effect_set_beauty_strength", {
      "param": STEffectBeautyType.EFFECT_BEAUTY_MAKEUP_HAIR_DYE.type_value,
      "val": 1.0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _rtcEngine,
              canvas: const VideoCanvas(uid: 0),
            )),
      ],
    );
  }
}
