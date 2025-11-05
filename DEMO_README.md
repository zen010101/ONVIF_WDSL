# ONVIF Demo - Profiles, StreamUri & OSD

## 概述 / Overview

这个Demo展示了如何使用ONVIF库获取：
1. IPC的Profiles信息
2. 每个Profile的StreamUri地址
3. IPC的OSD（On-Screen Display）水印信息

This demo shows how to use the ONVIF library to get:
1. IPC Profiles information
2. StreamUri address for each Profile
3. OSD (On-Screen Display) watermark information

## 文件说明 / Files

- `Demo_Profiles_StreamUri_OSD.dpr` - 主要的Demo程序 / Main demo program
- `ONVIF.pas` - ONVIF核心库（已添加GetStreamUri和GetOSDs方法） / Core ONVIF library (with GetStreamUri and GetOSDs methods added)

## 使用方法 / Usage

### 1. 配置连接参数 / Configure Connection Parameters

在 `Demo_Profiles_StreamUri_OSD.dpr` 中修改以下参数：

```delphi
ONVIFManager := TONVIFManager.Create(
  'http://192.168.1.100:80/',  // 摄像机URL / Camera URL
  'admin',                      // 用户名 / Username
  'password'                    // 密码 / Password
);
```

### 2. 编译运行 / Compile and Run

使用Delphi 10.4或更高版本：
1. 打开 `Demo_Profiles_StreamUri_OSD.dpr`
2. 编译项目
3. 运行程序

Using Delphi 10.4 or higher:
1. Open `Demo_Profiles_StreamUri_OSD.dpr`
2. Compile the project
3. Run the program

### 3. 查看输出 / View Output

程序将显示：
- 设备信息（制造商、型号、固件版本等）
- 所有Profiles的详细信息
- 每个Profile的StreamUri地址
- OSD水印配置信息

所有SOAP响应将保存到 `DumpResponse.log` 文件中以供调试。

The program will display:
- Device information (manufacturer, model, firmware version, etc.)
- Detailed information for all Profiles
- StreamUri address for each Profile
- OSD watermark configuration

All SOAP responses will be saved to `DumpResponse.log` for debugging.

## 新增功能 / New Features

### GetStreamUri

获取指定Profile的RTSP流地址：

```delphi
var
  StreamUri: String;
begin
  if ONVIFManager.GetStreamUri(ProfileToken, StreamUri) then
  begin
    WriteLn('Stream URI: ', StreamUri);
    // 使用StreamUri播放视频流 / Use StreamUri to play video stream
  end;
end;
```

### GetOSDs

获取指定视频源的OSD配置：

```delphi
var
  OSDInfo: String;
begin
  if ONVIFManager.GetOSDs(VideoSourceToken, OSDInfo) then
  begin
    WriteLn('OSD Configuration: ', OSDInfo);
    // 解析OSD配置信息 / Parse OSD configuration
  end;
end;
```

## 输出示例 / Sample Output

```
========================================
ONVIF Demo: Profiles, StreamUri & OSD
========================================

Connecting to camera...

========================================
Device Information
========================================
Manufacturer:     ACME Camera Co.
Model:            IPC-2000
Firmware Version: V2.1.0
Serial Number:    SN123456789
Hardware ID:      HW-001

========================================
Profiles Information
========================================
Total Profiles Found: 2

----------------------------------------
Profile #1
----------------------------------------
  Token:       Profile_1
  Name:        MainStream
  Fixed:       True

  Video Source Configuration:
    Token:        VideoSourceToken
    Name:         VideoSource
    Source Token: VideoSource_1
    Use Count:    2
    Bounds:       X=0, Y=0, Width=1920, Height=1080

  Video Encoder Configuration:
    Token:      VideoEncoderToken
    Name:       VideoEncoder
    Encoding:   H264
    Quality:    5.0
    Resolution: 1920 x 1080
    Frame Rate: 25 fps
    Bitrate:    4096 kbps
    H264 Profile: High
    GOP Length:   50

  Stream URI:
    rtsp://192.168.1.100:554/stream1
    [SUCCESS] Stream URI retrieved successfully!

----------------------------------------
Profile #2
----------------------------------------
  Token:       Profile_2
  Name:        SubStream
  ...

========================================
OSD Information
========================================
Getting OSD for Video Source Token: VideoSourceToken
[SUCCESS] OSD information retrieved!
...

========================================
Demo Completed Successfully!
========================================
```

## 依赖项 / Dependencies

- Delphi 10.4 或更高版本 / Delphi 10.4 or higher
- Indy 10 (HTTP组件) / Indy 10 (HTTP components)
- XML 支持 / XML support

## 故障排除 / Troubleshooting

1. **连接失败 / Connection Failed**
   - 检查摄像机IP地址和端口 / Check camera IP address and port
   - 确认用户名和密码正确 / Verify username and password
   - 确保网络连接正常 / Ensure network connectivity

2. **获取StreamUri失败 / Failed to Get StreamUri**
   - 检查摄像机是否支持ONVIF Media服务 / Check if camera supports ONVIF Media service
   - 查看 `DumpResponse.log` 获取详细错误信息 / Check `DumpResponse.log` for detailed error information

3. **获取OSD失败 / Failed to Get OSD**
   - 某些摄像机可能不支持OSD功能 / Some cameras may not support OSD feature
   - 检查SOAP响应中的错误代码 / Check error code in SOAP response

## 技术支持 / Support

如有问题，请查看：
- ONVIF官方文档: https://www.onvif.org/specs/
- 项目GitHub: https://github.com/zen010101/ONVIF_WDSL

For issues, please refer to:
- ONVIF Official Documentation: https://www.onvif.org/specs/
- Project GitHub: https://github.com/zen010101/ONVIF_WDSL

## 许可证 / License

MIT License - 详见 LICENSE 文件 / See LICENSE file for details
