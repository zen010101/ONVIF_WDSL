unit QuickStart_Example;

{
  快速开始示例 - Quick Start Example

  这个文件展示了如何快速使用ONVIF库获取Profiles、StreamUri和OSD信息
  This file demonstrates how to quickly use the ONVIF library to get Profiles, StreamUri, and OSD information
}

interface

uses
  System.SysUtils,
  ONVIF,
  ONVIF.Structure.Device,
  ONVIF.Structure.Profile,
  ONVIF.Structure.Capabilities;

procedure Example_GetProfiles;
procedure Example_GetStreamUri;
procedure Example_GetOSD;
procedure Example_Complete;

implementation

// 示例1: 获取所有Profiles
// Example 1: Get all Profiles
procedure Example_GetProfiles;
var
  ONVIFManager: TONVIFManager;
  I: Integer;
begin
  ONVIFManager := TONVIFManager.Create(
    'http://192.168.1.100:80/',
    'admin',
    'password'
  );
  try
    // Profiles信息在创建TONVIFManager时自动获取
    // Profiles are automatically retrieved when creating TONVIFManager

    WriteLn('Total Profiles: ', Length(ONVIFManager.Profiles));

    for I := 0 to High(ONVIFManager.Profiles) do
    begin
      WriteLn('Profile #', I + 1);
      WriteLn('  Token: ', ONVIFManager.Profiles[I].token);
      WriteLn('  Name: ', ONVIFManager.Profiles[I].Name);
      WriteLn('  Resolution: ',
              ONVIFManager.Profiles[I].VideoEncoderConfiguration.Resolution.width, ' x ',
              ONVIFManager.Profiles[I].VideoEncoderConfiguration.Resolution.height);
      WriteLn('  Encoding: ', ONVIFManager.Profiles[I].VideoEncoderConfiguration.Encoding);
      WriteLn;
    end;
  finally
    ONVIFManager.Free;
  end;
end;

// 示例2: 获取指定Profile的StreamUri
// Example 2: Get StreamUri for a specific Profile
procedure Example_GetStreamUri;
var
  ONVIFManager: TONVIFManager;
  ProfileToken: String;
  StreamUri: String;
begin
  ONVIFManager := TONVIFManager.Create(
    'http://192.168.1.100:80/',
    'admin',
    'password'
  );
  try
    // 获取第一个Profile的Token
    // Get the token of the first Profile
    if Length(ONVIFManager.Profiles) > 0 then
    begin
      ProfileToken := ONVIFManager.Profiles[0].token;

      // 获取StreamUri
      // Get StreamUri
      if ONVIFManager.GetStreamUri(ProfileToken, StreamUri) then
      begin
        WriteLn('Stream URI: ', StreamUri);
        WriteLn('Success!');
      end
      else
      begin
        WriteLn('Failed to get Stream URI');
        WriteLn('Error: ', ONVIFManager.LastResponse);
      end;
    end;
  finally
    ONVIFManager.Free;
  end;
end;

// 示例3: 获取OSD水印信息
// Example 3: Get OSD watermark information
procedure Example_GetOSD;
var
  ONVIFManager: TONVIFManager;
  VideoSourceToken: String;
  OSDInfo: String;
begin
  ONVIFManager := TONVIFManager.Create(
    'http://192.168.1.100:80/',
    'admin',
    'password'
  );
  try
    // 获取第一个Profile的VideoSourceToken
    // Get VideoSourceToken from the first Profile
    if Length(ONVIFManager.Profiles) > 0 then
    begin
      VideoSourceToken := ONVIFManager.Profiles[0].VideoSourceConfiguration.token;

      // 获取OSD信息
      // Get OSD information
      if ONVIFManager.GetOSDs(VideoSourceToken, OSDInfo) then
      begin
        WriteLn('OSD Information retrieved successfully!');
        WriteLn('OSD Config:');
        WriteLn(OSDInfo);
      end
      else
      begin
        WriteLn('Failed to get OSD information');
        WriteLn('Note: Some cameras may not support OSD');
      end;
    end;
  finally
    ONVIFManager.Free;
  end;
end;

// 示例4: 完整示例 - 获取所有信息
// Example 4: Complete example - Get all information
procedure Example_Complete;
var
  ONVIFManager: TONVIFManager;
  I: Integer;
  StreamUri: String;
  OSDInfo: String;
begin
  ONVIFManager := TONVIFManager.Create(
    'http://192.168.1.100:80/',
    'admin',
    'password'
  );
  try
    WriteLn('=== Device Information ===');
    WriteLn('Manufacturer: ', ONVIFManager.Device.Manufacturer);
    WriteLn('Model: ', ONVIFManager.Device.Model);
    WriteLn('Firmware: ', ONVIFManager.Device.FirmwareVersion);
    WriteLn;

    WriteLn('=== Profiles and Stream URIs ===');
    for I := 0 to High(ONVIFManager.Profiles) do
    begin
      WriteLn('Profile: ', ONVIFManager.Profiles[I].Name);
      WriteLn('  Token: ', ONVIFManager.Profiles[I].token);

      // 获取StreamUri
      // Get StreamUri
      if ONVIFManager.GetStreamUri(ONVIFManager.Profiles[I].token, StreamUri) then
        WriteLn('  Stream: ', StreamUri)
      else
        WriteLn('  Stream: Failed to retrieve');

      WriteLn;
    end;

    WriteLn('=== OSD Information ===');
    // 获取第一个Profile的OSD信息
    // Get OSD information for the first Profile
    if Length(ONVIFManager.Profiles) > 0 then
    begin
      if ONVIFManager.GetOSDs(
           ONVIFManager.Profiles[0].VideoSourceConfiguration.token,
           OSDInfo) then
      begin
        WriteLn('OSD retrieved successfully');
        // 这里可以解析OSD信息
        // Here you can parse OSD information
      end
      else
        WriteLn('OSD not available or not supported');
    end;

  finally
    ONVIFManager.Free;
  end;
end;

end.
