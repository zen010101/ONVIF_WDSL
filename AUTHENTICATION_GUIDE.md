# TONVIFManager Authentication Guide
# TONVIFManager 认证方式指南

## 当前支持的认证方式 / Currently Supported Authentication

### ✅ WS-Security UsernameToken with Password Digest (WSSE)

这是当前**唯一实现和支持**的认证方式，也是ONVIF标准推荐的认证方法。

This is the **only implemented and supported** authentication method, and is the ONVIF standard recommended authentication.

#### 实现细节 / Implementation Details

**位置 / Location:** `ONVIF.pas:683-733`

```delphi
function TONVIFManager.GetSoapXMLConnection:String;
const XML_SOAP_CONNECTION: String =
    '<soap:Header>' +
    '<Security xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" s:mustUnderstand="1"> ' +
    '<UsernameToken> ' +
    '<Username>%s</Username> ' +
    '<Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">%s</Password> ' +
    '<Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">%s</Nonce> ' +
    '<Created xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">%s</Created> ' +
    '</UsernameToken> ' +
    '</Security> ' +
    '</soap:Header>';
```

#### 认证流程 / Authentication Process

1. **生成随机Nonce** / Generate Random Nonce
   ```delphi
   SetLength(LRaw_nonce, 20);
   for i := 0 to High(LRaw_nonce) do
     LRaw_nonce[i]:= Random(256);
   ```

2. **创建时间戳** / Create Timestamp
   ```delphi
   aCreated := DateTimeToXMLTime(Now, False);
   ```

3. **计算Password Digest** / Calculate Password Digest
   ```
   PasswordDigest = Base64(SHA1(Nonce + Created + Password))
   ```

   ```delphi
   Lraw_digest := SHA1(LRaw_nonce + TEncoding.ANSI.GetBytes(aCreated) + TEncoding.ANSI.GetBytes(FPassword));
   LDigest := TNetEncoding.Base64.Encode(Lraw_digest);
   ```

4. **添加到SOAP Header** / Add to SOAP Header
   - Username: 明文用户名 / Plain text username
   - Password: Base64编码的SHA1摘要 / Base64 encoded SHA1 digest
   - Nonce: Base64编码的随机值 / Base64 encoded random value
   - Created: ISO 8601时间戳 / ISO 8601 timestamp

#### 安全特性 / Security Features

✅ **防重放攻击** / Replay Attack Prevention
   - 使用时间戳和随机Nonce确保每次请求唯一
   - Each request is unique using timestamp and random nonce

✅ **密码保护** / Password Protection
   - 密码不以明文传输，使用SHA1摘要
   - Password is not transmitted in plain text, uses SHA1 digest

✅ **ONVIF标准兼容** / ONVIF Standard Compliant
   - 符合ONVIF Core Specification
   - Complies with ONVIF Core Specification

---

## 不支持的认证方式 / Unsupported Authentication Methods

### ❌ HTTP Digest Authentication

虽然在uses中引入了 `IdAuthenticationDigest`，但**实际上没有实现**。

Although `IdAuthenticationDigest` is imported in uses, it is **not actually implemented**.

**代码位置 / Code Location:** `ONVIF.pas:34`
```delphi
uses
  ...
  IdAuthenticationDigest, ...  // 已引入但未使用 / Imported but not used
```

HTTP Digest认证通常在HTTP层面实现，而ONVIF主要使用SOAP层面的WS-Security认证。

HTTP Digest authentication is typically implemented at the HTTP layer, while ONVIF primarily uses SOAP-level WS-Security authentication.

### ❌ HTTP Basic Authentication

**未实现** / Not Implemented

HTTP Basic认证安全性较低（Base64编码明文），不符合ONVIF安全标准。

HTTP Basic authentication has lower security (Base64 encoded plaintext) and does not meet ONVIF security standards.

### ❌ UsernameToken with Plain Password

**未实现** / Not Implemented

虽然WS-Security支持明文密码模式，但出于安全考虑，本库只实现了Password Digest模式。

Although WS-Security supports plain password mode, for security reasons, this library only implements Password Digest mode.

---

## 如何使用认证 / How to Use Authentication

### 基本用法 / Basic Usage

```delphi
var
  ONVIFManager: TONVIFManager;
begin
  // WS-Security认证会自动应用到所有请求
  // WS-Security authentication is automatically applied to all requests
  ONVIFManager := TONVIFManager.Create(
    'http://192.168.1.100:80/',  // ONVIF Service URL
    'admin',                      // Username
    'password123'                 // Password
  );

  try
    // 所有请求都会自动包含WS-Security认证头
    // All requests automatically include WS-Security authentication header
    ONVIFManager.GetProfiles;

    // 检查认证是否成功
    // Check if authentication was successful
    if ONVIFManager.LastStatusCode = 200 then
      WriteLn('Authentication successful!')
    else if ONVIFManager.LastStatusCode = 401 then
      WriteLn('Authentication failed - check username/password')
    else
      WriteLn('Error: ', ONVIFManager.LastStatusCode);

  finally
    ONVIFManager.Free;
  end;
end;
```

### 调试认证问题 / Debugging Authentication Issues

```delphi
ONVIFManager := TONVIFManager.Create(url, username, password);
ONVIFManager.SaveResponseOnDisk := True;  // 保存响应到 DumpResponse.log

// 检查认证失败
if ONVIFManager.LastStatusCode = 401 then
begin
  WriteLn('认证失败，可能原因:');
  WriteLn('1. 用户名或密码错误');
  WriteLn('2. 摄像机禁用了该账户');
  WriteLn('3. 时间戳同步问题');
  WriteLn('Response: ', ONVIFManager.LastResponse);
end;
```

---

## 认证错误代码 / Authentication Error Codes

| HTTP状态码 / HTTP Status | 说明 / Description |
|-------------------------|-------------------|
| 200 | ✅ 认证成功 / Authentication successful |
| 401 | ❌ 认证失败 - 用户名或密码错误 / Authentication failed - invalid credentials |
| 403 | ❌ 权限不足 - 账户被禁用或无权限 / Forbidden - account disabled or no permission |
| 500 | ❌ 服务器错误 - 可能是时间同步问题 / Server error - possible time sync issue |

---

## 常见问题 / FAQ

### Q1: 为什么不支持HTTP Digest认证？

**A:** ONVIF标准推荐使用WS-Security UsernameToken认证，这是更安全的认证方式。HTTP Digest主要用于非SOAP的HTTP请求。

**A:** The ONVIF standard recommends WS-Security UsernameToken authentication, which is more secure. HTTP Digest is mainly used for non-SOAP HTTP requests.

### Q2: 如果摄像机要求HTTP Digest认证怎么办？

**A:** 大多数支持ONVIF的摄像机都支持WS-Security认证。如果确实需要HTTP Digest，需要修改 `ExecuteRequest` 方法添加Indy的Digest认证支持。

**A:** Most ONVIF-compliant cameras support WS-Security authentication. If HTTP Digest is truly needed, you would need to modify the `ExecuteRequest` method to add Indy's Digest authentication support.

### Q3: 认证信息是否会被缓存？

**A:** 不会。每次请求都会生成新的Nonce和时间戳，重新计算Password Digest，这样可以防止重放攻击。

**A:** No. Each request generates a new Nonce and timestamp, and recalculates the Password Digest, which prevents replay attacks.

### Q4: 时区问题会影响认证吗？

**A:** 可能会。如果摄像机和客户端的时间差距过大（通常超过5分钟），认证可能失败。确保双方时间同步。

**A:** Possibly. If the time difference between the camera and client is too large (usually more than 5 minutes), authentication may fail. Ensure both sides are time-synchronized.

---

## 扩展认证支持 / Extending Authentication Support

如果需要添加其他认证方式，可以在 `ExecuteRequest` 方法中添加：

If you need to add other authentication methods, you can add them in the `ExecuteRequest` method:

### 添加HTTP Digest示例 / Adding HTTP Digest Example

```delphi
function TONVIFManager.ExecuteRequest(const Addr: String; const InStream, OutStream: TStringStream): Boolean;
Var
  LIdhtp1: TIdHTTP;
  LUri: TIdURI;
  LAuthDigest: TIdDigestAuthentication;  // HTTP Digest认证
begin
  LIdhtp1 := TIdHTTP.Create;
  LUri := TIdURI.Create(Addr);
  try
    // 配置HTTP Digest认证（可选）
    if FUseHTTPDigest then  // 需要添加这个标志
    begin
      LAuthDigest := TIdDigestAuthentication.Create;
      try
        LAuthDigest.Username := FLogin;
        LAuthDigest.Password := FPassword;
        LIdhtp1.Request.Authentication := LAuthDigest;
      finally
        LAuthDigest.Free;
      end;
    end;

    // ... 其余代码
  finally
    LUri.Free;
    LIdhtp1.Free;
  end;
end;
```

---

## 参考文档 / References

- [ONVIF Core Specification](https://www.onvif.org/specs/core/ONVIF-Core-Specification.pdf)
- [WS-Security UsernameToken Profile](http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0.pdf)
- [SOAP Message Security](http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0.pdf)

---

## 总结 / Summary

**TONVIFManager当前只支持一种认证方式：**
- ✅ WS-Security UsernameToken with Password Digest (WSSE)

**这是最安全且符合ONVIF标准的认证方式，适用于绝大多数ONVIF摄像机。**

**TONVIFManager currently supports only one authentication method:**
- ✅ WS-Security UsernameToken with Password Digest (WSSE)

**This is the most secure and ONVIF-standard-compliant authentication method, suitable for the vast majority of ONVIF cameras.**
