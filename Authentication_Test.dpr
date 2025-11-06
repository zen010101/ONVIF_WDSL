program Authentication_Test;

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

procedure WriteLog(const Funzione, Descrizione: String; Livello: TPONVIFLivLog; IsVerboseLog: Boolean = False);
begin
  if not IsVerboseLog then
  begin
    case Livello of
      tpLivInfo:       WriteLn('[INFO] ', Funzione, ': ', Descrizione);
      tpLivError:      WriteLn('[ERROR] ', Funzione, ': ', Descrizione);
      tpLivWarning:    WriteLn('[WARNING] ', Funzione, ': ', Descrizione);
      tpLiveException: WriteLn('[EXCEPTION] ', Funzione, ': ', Descrizione);
    end;
  end;
end;

procedure TestAuthentication(const URL, Username, Password: String);
begin
  WriteLn('========================================');
  WriteLn('Testing ONVIF Authentication');
  WriteLn('测试ONVIF认证');
  WriteLn('========================================');
  WriteLn;
  WriteLn('Connection Details:');
  WriteLn('  URL:      ', URL);
  WriteLn('  Username: ', Username);
  WriteLn('  Password: ', StringOfChar('*', Length(Password)));
  WriteLn;
  WriteLn('Authentication Method:');
  WriteLn('  WS-Security UsernameToken with Password Digest');
  WriteLn('  认证方式：WS-Security UsernameToken（密码摘要）');
  WriteLn;

  try
    WriteLn('Attempting connection...');
    WriteLn('尝试连接...');
    WriteLn;

    ONVIFManager := TONVIFManager.Create(URL, Username, Password);
    try
      ONVIFManager.OnWriteLog := WriteLog;
      ONVIFManager.SaveResponseOnDisk := True;

      WriteLn('========================================');
      WriteLn('Authentication Result');
      WriteLn('认证结果');
      WriteLn('========================================');

      // Check last status code
      if ONVIFManager.LastStatusCode = 200 then
      begin
        WriteLn('✅ Authentication SUCCESSFUL!');
        WriteLn('✅ 认证成功！');
        WriteLn;
        WriteLn('Device Information:');
        WriteLn('  Manufacturer: ', ONVIFManager.Device.Manufacturer);
        WriteLn('  Model:        ', ONVIFManager.Device.Model);
        WriteLn('  Firmware:     ', ONVIFManager.Device.FirmwareVersion);
        WriteLn('  Serial:       ', ONVIFManager.Device.SerialNumber);
        WriteLn;
        WriteLn('Capabilities:');
        WriteLn('  Device XAddr:  ', ONVIFManager.Capabilities.Device.XAddr);
        WriteLn('  Media XAddr:   ', ONVIFManager.Capabilities.Media.XAddr);
        WriteLn('  PTZ XAddr:     ', ONVIFManager.Capabilities.PTZ.XAddr);
        WriteLn('  Events XAddr:  ', ONVIFManager.Capabilities.Events.XAddr);
        WriteLn;
        WriteLn('Profiles Found: ', Length(ONVIFManager.Profiles));
      end
      else if ONVIFManager.LastStatusCode = 401 then
      begin
        WriteLn('❌ Authentication FAILED!');
        WriteLn('❌ 认证失败！');
        WriteLn;
        WriteLn('Possible reasons:');
        WriteLn('  1. Invalid username or password');
        WriteLn('     用户名或密码错误');
        WriteLn('  2. Account is disabled');
        WriteLn('     账户已被禁用');
        WriteLn('  3. Camera requires different authentication method');
        WriteLn('     摄像机需要不同的认证方式');
        WriteLn;
        WriteLn('Response: ', ONVIFManager.LastResponse);
      end
      else if ONVIFManager.LastStatusCode = 403 then
      begin
        WriteLn('❌ Access FORBIDDEN!');
        WriteLn('❌ 访问被禁止！');
        WriteLn;
        WriteLn('Possible reasons:');
        WriteLn('  1. Account does not have sufficient permissions');
        WriteLn('     账户权限不足');
        WriteLn('  2. IP address is blocked');
        WriteLn('     IP地址被封锁');
        WriteLn;
        WriteLn('Response: ', ONVIFManager.LastResponse);
      end
      else if ONVIFManager.LastStatusCode = 500 then
      begin
        WriteLn('❌ Server Error!');
        WriteLn('❌ 服务器错误！');
        WriteLn;
        WriteLn('Possible reasons:');
        WriteLn('  1. Time synchronization issue');
        WriteLn('     时间同步问题');
        WriteLn('  2. Camera internal error');
        WriteLn('     摄像机内部错误');
        WriteLn;
        WriteLn('Response: ', ONVIFManager.LastResponse);
      end
      else if ONVIFManager.LastStatusCode < 0 then
      begin
        WriteLn('❌ Internal Library Error!');
        WriteLn('❌ 库内部错误！');
        WriteLn;
        WriteLn('Error Code: ', ONVIFManager.LastStatusCode);
        WriteLn('Response: ', ONVIFManager.LastResponse);
      end
      else
      begin
        WriteLn('⚠️  Unexpected Status Code: ', ONVIFManager.LastStatusCode);
        WriteLn('Response: ', ONVIFManager.LastResponse);
      end;

      WriteLn;
      WriteLn('========================================');
      WriteLn('Authentication Details');
      WriteLn('认证详情');
      WriteLn('========================================');
      WriteLn('Protocol: WS-Security');
      WriteLn('Method:   UsernameToken with Password Digest');
      WriteLn('Digest:   Base64(SHA1(Nonce + Created + Password))');
      WriteLn;
      WriteLn('Security Features:');
      WriteLn('  ✓ Password not sent in plain text');
      WriteLn('    密码不以明文发送');
      WriteLn('  ✓ Unique nonce for each request');
      WriteLn('    每个请求使用唯一的随机数');
      WriteLn('  ✓ Timestamp prevents replay attacks');
      WriteLn('    时间戳防止重放攻击');
      WriteLn('  ✓ SHA-1 hash ensures integrity');
      WriteLn('    SHA-1哈希确保完整性');
      WriteLn;
      WriteLn('Note: All SOAP messages saved to DumpResponse.log');
      WriteLn('注意：所有SOAP消息已保存到 DumpResponse.log');

    finally
      ONVIFManager.Free;
    end;

  except
    on E: Exception do
    begin
      WriteLn('========================================');
      WriteLn('Exception Occurred');
      WriteLn('发生异常');
      WriteLn('========================================');
      WriteLn('Type:    ', E.ClassName);
      WriteLn('Message: ', E.Message);
      WriteLn;
      WriteLn('Possible reasons:');
      WriteLn('  1. Network connection failed');
      WriteLn('     网络连接失败');
      WriteLn('  2. Invalid URL format');
      WriteLn('     URL格式无效');
      WriteLn('  3. Camera is unreachable');
      WriteLn('     摄像机无法访问');
    end;
  end;
end;

procedure ShowUsage;
begin
  WriteLn('========================================');
  WriteLn('ONVIF Authentication Test Tool');
  WriteLn('ONVIF 认证测试工具');
  WriteLn('========================================');
  WriteLn;
  WriteLn('Usage:');
  WriteLn('  Authentication_Test.exe <URL> <Username> <Password>');
  WriteLn;
  WriteLn('Example:');
  WriteLn('  Authentication_Test.exe http://192.168.1.100:80/ admin password123');
  WriteLn;
  WriteLn('Supported Authentication:');
  WriteLn('  ✓ WS-Security UsernameToken with Password Digest');
  WriteLn('  ✗ HTTP Digest (not implemented)');
  WriteLn('  ✗ HTTP Basic (not implemented)');
  WriteLn;
end;

begin
  try
    if ParamCount < 3 then
    begin
      ShowUsage;

      // Interactive mode
      WriteLn('Enter connection details (or press Ctrl+C to exit):');
      WriteLn('输入连接信息（或按Ctrl+C退出）：');
      WriteLn;

      Write('Camera URL: ');
      var URL := '';
      ReadLn(URL);

      if URL.Trim.IsEmpty then
      begin
        WriteLn('Using default: http://192.168.1.100:80/');
        URL := 'http://192.168.1.100:80/';
      end;

      Write('Username: ');
      var Username := '';
      ReadLn(Username);

      if Username.Trim.IsEmpty then
      begin
        WriteLn('Using default: admin');
        Username := 'admin';
      end;

      Write('Password: ');
      var Password := '';
      ReadLn(Password);

      if Password.Trim.IsEmpty then
      begin
        WriteLn('Using default: password');
        Password := 'password';
      end;

      WriteLn;
      TestAuthentication(URL, Username, Password);
    end
    else
    begin
      // Command line mode
      TestAuthentication(ParamStr(1), ParamStr(2), ParamStr(3));
    end;

  except
    on E: Exception do
      WriteLn('[EXCEPTION] ', E.ClassName, ': ', E.Message);
  end;

  WriteLn;
  WriteLn('Press Enter to exit...');
  ReadLn;
end.
