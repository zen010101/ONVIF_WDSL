program Demo_Profiles_StreamUri_OSD;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ONVIF in 'ONVIF.pas',
  ONVIF.Structure.Device in 'ONVIF.Structure.Device.pas',
  ONVIF.Structure.Profile in 'ONVIF.Structure.Profile.pas',
  ONVIF.Structure.Capabilities in 'ONVIF.Structure.Capabilities.pas';

var
  ONVIFManager: TONVIFManager;
  I: Integer;
  StreamUri: String;
  OSDInfo: String;

procedure WriteLog(const Funzione, Descrizione: String; Livello: TPONVIFLivLog; IsVerboseLog: Boolean = False);
begin
  if not IsVerboseLog then
  begin
    case Livello of
      tpLivInfo:      WriteLn('[INFO] ', Funzione, ': ', Descrizione);
      tpLivError:     WriteLn('[ERROR] ', Funzione, ': ', Descrizione);
      tpLivWarning:   WriteLn('[WARNING] ', Funzione, ': ', Descrizione);
      tpLiveException: WriteLn('[EXCEPTION] ', Funzione, ': ', Descrizione);
    end;
  end;
end;

begin
  try
    WriteLn('========================================');
    WriteLn('ONVIF Demo: Profiles, StreamUri & OSD');
    WriteLn('========================================');
    WriteLn;

    // Replace these values with your camera's settings
    // 请将以下值替换为您的摄像机设置
    ONVIFManager := TONVIFManager.Create(
      'http://192.168.1.100:80/',  // Camera URL - 摄像机URL
      'admin',                      // Username - 用户名
      'password'                    // Password - 密码
    );

    try
      // Set up logging callback - 设置日志回调
      ONVIFManager.OnWriteLog := WriteLog;
      ONVIFManager.SaveResponseOnDisk := True;  // Save responses to DumpResponse.log

      WriteLn('Connecting to camera...');
      WriteLn('连接摄像机...');
      WriteLn;

      // Step 1: Display Device Information - 显示设备信息
      WriteLn('========================================');
      WriteLn('Device Information - 设备信息');
      WriteLn('========================================');
      WriteLn('Manufacturer:     ', ONVIFManager.Device.Manufacturer);
      WriteLn('Model:            ', ONVIFManager.Device.Model);
      WriteLn('Firmware Version: ', ONVIFManager.Device.FirmwareVersion);
      WriteLn('Serial Number:    ', ONVIFManager.Device.SerialNumber);
      WriteLn('Hardware ID:      ', ONVIFManager.Device.HardwareId);
      WriteLn;

      // Step 2: Display Profiles - 显示Profiles信息
      WriteLn('========================================');
      WriteLn('Profiles Information - Profiles信息');
      WriteLn('========================================');
      WriteLn('Total Profiles Found: ', Length(ONVIFManager.Profiles));
      WriteLn('找到的Profiles总数: ', Length(ONVIFManager.Profiles));
      WriteLn;

      if Length(ONVIFManager.Profiles) = 0 then
      begin
        WriteLn('No profiles found! Check your camera connection and credentials.');
        WriteLn('未找到Profiles！请检查摄像机连接和凭据。');
        Exit;
      end;

      // Iterate through all profiles - 遍历所有Profiles
      for I := 0 to High(ONVIFManager.Profiles) do
      begin
        WriteLn('----------------------------------------');
        WriteLn('Profile #', I + 1);
        WriteLn('----------------------------------------');
        WriteLn('  Token:       ', ONVIFManager.Profiles[I].token);
        WriteLn('  Name:        ', ONVIFManager.Profiles[I].Name);
        WriteLn('  Fixed:       ', BoolToStr(ONVIFManager.Profiles[I].fixed, True));
        WriteLn;

        // Video Source Configuration - 视频源配置
        WriteLn('  Video Source Configuration:');
        WriteLn('    Token:        ', ONVIFManager.Profiles[I].VideoSourceConfiguration.token);
        WriteLn('    Name:         ', ONVIFManager.Profiles[I].VideoSourceConfiguration.Name);
        WriteLn('    Source Token: ', ONVIFManager.Profiles[I].VideoSourceConfiguration.SourceToken);
        WriteLn('    Use Count:    ', ONVIFManager.Profiles[I].VideoSourceConfiguration.UseCount);
        WriteLn('    Bounds:       ',
                Format('X=%d, Y=%d, Width=%d, Height=%d',
                [ONVIFManager.Profiles[I].VideoSourceConfiguration.Bounds.x,
                 ONVIFManager.Profiles[I].VideoSourceConfiguration.Bounds.y,
                 ONVIFManager.Profiles[I].VideoSourceConfiguration.Bounds.width,
                 ONVIFManager.Profiles[I].VideoSourceConfiguration.Bounds.height]));
        WriteLn;

        // Video Encoder Configuration - 视频编码配置
        WriteLn('  Video Encoder Configuration:');
        WriteLn('    Token:      ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.token);
        WriteLn('    Name:       ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.Name);
        WriteLn('    Encoding:   ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.Encoding);
        WriteLn('    Quality:    ', Format('%.1f', [ONVIFManager.Profiles[I].VideoEncoderConfiguration.Quality]));
        WriteLn('    Resolution: ',
                Format('%d x %d',
                [ONVIFManager.Profiles[I].VideoEncoderConfiguration.Resolution.width,
                 ONVIFManager.Profiles[I].VideoEncoderConfiguration.Resolution.height]));
        WriteLn('    Frame Rate: ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.RateControl.FrameRateLimit, ' fps');
        WriteLn('    Bitrate:    ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.RateControl.BitrateLimit, ' kbps');
        if ONVIFManager.Profiles[I].VideoEncoderConfiguration.Encoding = 'H264' then
        begin
          WriteLn('    H264 Profile: ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.H264.H264Profile);
          WriteLn('    GOP Length:   ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.H264.GovLength);
        end;
        WriteLn;

        // Step 3: Get Stream URI for this profile - 获取此Profile的StreamUri
        WriteLn('  Stream URI - 流媒体地址:');
        if ONVIFManager.GetStreamUri(ONVIFManager.Profiles[I].token, StreamUri) then
        begin
          WriteLn('    ', StreamUri);
          WriteLn('    [SUCCESS] Stream URI retrieved successfully!');
        end
        else
        begin
          WriteLn('    [ERROR] Failed to get Stream URI!');
          WriteLn('    Status Code: ', ONVIFManager.LastStatusCode);
          WriteLn('    Response: ', ONVIFManager.LastResponse);
        end;
        WriteLn;

        // PTZ Configuration (if available) - PTZ配置（如果可用）
        if ONVIFManager.Profiles[I].PTZConfiguration.token <> '' then
        begin
          WriteLn('  PTZ Configuration:');
          WriteLn('    Token:      ', ONVIFManager.Profiles[I].PTZConfiguration.token);
          WriteLn('    Name:       ', ONVIFManager.Profiles[I].PTZConfiguration.Name);
          WriteLn('    Node Token: ', ONVIFManager.Profiles[I].PTZConfiguration.NodeToken);
          WriteLn;
        end;
      end;

      // Step 4: Get OSD Information - 获取OSD水印信息
      WriteLn('========================================');
      WriteLn('OSD (On-Screen Display) Information');
      WriteLn('OSD水印信息');
      WriteLn('========================================');

      // Try to get OSD for each video source configuration
      // 尝试获取每个视频源配置的OSD信息
      for I := 0 to High(ONVIFManager.Profiles) do
      begin
        if ONVIFManager.Profiles[I].VideoSourceConfiguration.token <> '' then
        begin
          WriteLn('Getting OSD for Video Source Token: ',
                  ONVIFManager.Profiles[I].VideoSourceConfiguration.token);

          if ONVIFManager.GetOSDs(ONVIFManager.Profiles[I].VideoSourceConfiguration.token, OSDInfo) then
          begin
            WriteLn('[SUCCESS] OSD information retrieved!');
            WriteLn('OSD Configuration:');
            WriteLn(OSDInfo);
            WriteLn;
          end
          else
          begin
            WriteLn('[WARNING] Failed to get OSD information for this video source.');
            WriteLn('Status Code: ', ONVIFManager.LastStatusCode);
            WriteLn;
          end;

          // Only try the first profile to avoid redundant requests
          // 只尝试第一个profile以避免重复请求
          Break;
        end;
      end;

      WriteLn('========================================');
      WriteLn('Demo Completed Successfully!');
      WriteLn('演示完成！');
      WriteLn('========================================');
      WriteLn;
      WriteLn('Note: All SOAP responses have been saved to DumpResponse.log');
      WriteLn('注意：所有SOAP响应已保存到 DumpResponse.log');

    finally
      ONVIFManager.Free;
    end;

  except
    on E: Exception do
    begin
      WriteLn('[EXCEPTION] ', E.ClassName, ': ', E.Message);
    end;
  end;

  WriteLn;
  WriteLn('Press Enter to exit...');
  ReadLn;
end.
