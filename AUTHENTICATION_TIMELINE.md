# ONVIF Authentication Timeline and History
# ONVIF 认证方式的时间线与历史

## 📅 时间顺序总结 / Timeline Summary

### **重要结论：两种认证方式同时引入！**
**Key Finding: Both authentication methods were introduced simultaneously!**

WSSE (WS-Security UsernameToken) 和 HTTP Digest 这两种认证方式**没有先后顺序**，它们从ONVIF规范诞生之初就**同时存在**。

Both WSSE (WS-Security UsernameToken) and HTTP Digest **do not have a sequence order** - they have **coexisted since the birth of ONVIF specification**.

---

## 🕐 详细时间线 / Detailed Timeline

### **2008年11月 - ONVIF诞生 / November 2008 - ONVIF Founded**

**ONVIF Core Specification v1.0 发布**

✅ **WS-Security UsernameToken** - 已包含 / Included
✅ **HTTP Digest (RFC 2617)** - 已包含 / Included

**关键信息 / Key Information:**
- ONVIF于2008年11月25日正式注册为非营利性公司
- ONVIF was officially incorporated as a non-profit corporation on November 25, 2008
- Core Specification 1.0同步发布
- Core Specification 1.0 was released simultaneously
- **从第一版规范开始，就要求设备支持这两种认证方式**
- **From the first specification, devices were required to support both authentication methods**

---

### **2009年 - ONVIF Core Specification v1.01**

两种认证方式继续并存，没有变化。

Both authentication methods continued to coexist without changes.

---

### **2011年12月 - Profile S v1.0 正式发布 / December 2011 - Profile S v1.0 Released**

这是第一个正式的ONVIF Profile，**明确规范了两种认证方式的要求**：

This was the first official ONVIF Profile, which **clearly specified the requirements for both authentication methods**:

#### **对设备的要求 / Device Requirements:**

| 认证方式 / Method | 要求 / Requirement | 说明 / Description |
|------------------|-------------------|-------------------|
| **WS-UsernameToken** | 强制 (M - Mandatory) | 必须实现 / Must implement |
| **HTTP Digest** | 可选 (O - Optional) | 可以实现 / May implement |

#### **对客户端的要求 / Client Requirements:**

| 认证方式 / Method | 要求 / Requirement |
|------------------|-------------------|
| **WS-UsernameToken** | 必须实现 / Must implement |
| **HTTP Digest** | 必须实现 / Must implement |

**关键规范 / Key Specifications:**
```
设备必须实现 WS-Usernametoken (根据 WS-Security)
客户端必须实现 WS-Usernametoken 和 HTTP Digest

Devices shall implement WS-Usernametoken according to WS-security
Clients shall implement both WS-Usernametoken and HTTP Digest
```

---

### **2016年 - ONVIF Core Specification v16.06**

两种认证方式持续支持，规范更加完善。

Both authentication methods continued to be supported with more refined specifications.

**新增说明 / New Guidelines:**
- 如果服务器同时支持两种认证方式，Web服务请求可以在HTTP层级（Digest）或Web服务层级（WS-Security）进行认证
- If a server supports both authentication methods, a web service request can be authenticated at HTTP level (Digest) or web service level (WS-Security)
- **客户端不应同时在两个层级提供认证凭据**
- **Clients should not simultaneously supply authentication credentials at both levels**
- 如果服务器在两个层级都收到凭据，应首先验证HTTP层凭据，然后验证WS层凭据
- If a server receives credentials at both levels, it shall first validate HTTP layer credentials, then WS layer credentials

---

### **2017年 - ONVIF Core Specification v17.12**

继续支持两种认证方式，增强安全建议。

Continued support for both authentication methods with enhanced security recommendations.

**安全建议 / Security Recommendations:**
- Digest认证和UsernameToken仅提供基本的安全级别
- Both digest authentication and user name token profile give only a rudimentary level of security
- **强烈建议在安全要求高的系统中使用TLS**
- **Strongly recommended to configure TLS-based access in security-critical systems**

---

### **2022年 - ONVIF Core Specification v22.12**

两种传统认证方式继续支持，规范持续更新。

Both traditional authentication methods continued to be supported with ongoing specification updates.

---

### **2023年12月 - 新认证方式引入 / December 2023 - New Authentication Added**

**OAuth2 & OpenID Connect** 支持添加

OAuth2 and OpenID Connect support added

- 引入授权服务器配置
- Authorization Server configuration introduced
- 支持现代企业级认证
- Support for modern enterprise authentication

---

### **2024年6月 - ONVIF Core Specification v24.06**

**JWT Token 认证** 添加

JWT Token authentication added

新增内容 / New Additions:
```
- JWT客户端授权（基于RFC 6750，通过HTTPS）
- JWT client authorization (based on RFC 6750 over HTTPS)
- 不同于HTTP Digest和WS-UsernameToken
- Unlike HTTP Digest and WS-UsernameToken
- JWT规范定义了如何将客户端与不同用户级别关联
- JWT specification defines how to associate clients with different User Levels
```

---

### **2025年6月 - ONVIF Core Specification v25.06 (最新版 / Latest)**

**所有认证方式并存 / All Authentication Methods Coexist:**

| 认证方式 / Method | 状态 / Status | 引入时间 / Introduced |
|------------------|--------------|---------------------|
| **WS-Security UsernameToken** | ✅ 活跃支持 / Active | 2008年11月 / Nov 2008 |
| **HTTP Digest (RFC 2617)** | ✅ 活跃支持 / Active | 2008年11月 / Nov 2008 |
| **OAuth2 & OpenID Connect** | ✅ 活跃支持 / Active | 2023年12月 / Dec 2023 |
| **JWT Token** | ✅ 活跃支持 / Active | 2024年6月 / Jun 2024 |

---

## 📊 认证方式对比 / Authentication Method Comparison

### 原始认证方式 (2008年引入) / Original Methods (Introduced 2008)

#### **1. WS-Security UsernameToken**
```
优先级: ⭐⭐⭐⭐⭐ (设备强制要求)
安全性: ⭐⭐⭐ (基本安全)
使用层级: SOAP/Web Service层
特点:
  - Password Digest (SHA-1)
  - Nonce + Timestamp
  - 防重放攻击
  - ONVIF强烈推荐

Priority: ⭐⭐⭐⭐⭐ (Mandatory for devices)
Security: ⭐⭐⭐ (Basic security)
Level: SOAP/Web Service layer
Features:
  - Password Digest (SHA-1)
  - Nonce + Timestamp
  - Replay attack prevention
  - Strongly recommended by ONVIF
```

#### **2. HTTP Digest (RFC 2617)**
```
优先级: ⭐⭐⭐ (设备可选，客户端必须)
安全性: ⭐⭐ (基本安全)
使用层级: HTTP层
特点:
  - MD5哈希
  - Challenge-Response机制
  - 主要用于RTSP/HTTP方法
  - 可与WS-Security配合使用

Priority: ⭐⭐⭐ (Optional for devices, mandatory for clients)
Security: ⭐⭐ (Basic security)
Level: HTTP layer
Features:
  - MD5 hash
  - Challenge-Response mechanism
  - Mainly for RTSP/HTTP methods
  - Can be used with WS-Security
```

### 现代认证方式 (2020s引入) / Modern Methods (Introduced 2020s)

#### **3. JWT Token (2024)**
```
优先级: ⭐⭐⭐⭐ (现代企业推荐)
安全性: ⭐⭐⭐⭐⭐ (高级安全)
使用层级: HTTPS
特点:
  - 基于RFC 6750
  - 无状态令牌
  - 用户级别关联
  - 企业级认证

Priority: ⭐⭐⭐⭐ (Recommended for modern enterprises)
Security: ⭐⭐⭐⭐⭐ (Advanced security)
Level: HTTPS
Features:
  - Based on RFC 6750
  - Stateless tokens
  - User level association
  - Enterprise authentication
```

#### **4. OAuth2 & OpenID Connect (2023)**
```
优先级: ⭐⭐⭐⭐ (企业集成推荐)
安全性: ⭐⭐⭐⭐⭐ (高级安全)
使用层级: HTTPS
特点:
  - 标准OAuth2流程
  - 授权服务器支持
  - 单点登录(SSO)
  - 企业目录集成

Priority: ⭐⭐⭐⭐ (Recommended for enterprise integration)
Security: ⭐⭐⭐⭐⭐ (Advanced security)
Level: HTTPS
Features:
  - Standard OAuth2 flow
  - Authorization server support
  - Single Sign-On (SSO)
  - Enterprise directory integration
```

---

## 🔍 重要发现 / Key Findings

### 1. **没有先后顺序 / No Sequential Order**

```
❌ 错误理解 / Wrong Understanding:
  "HTTP Digest先出现，然后ONVIF才加入WS-Security"
  "HTTP Digest came first, then ONVIF added WS-Security"

✅ 正确理解 / Correct Understanding:
  "两种认证方式从2008年ONVIF诞生就同时存在"
  "Both authentication methods have coexisted since ONVIF's inception in 2008"
```

### 2. **优先级差异 / Priority Differences**

虽然两者同时引入，但ONVIF从一开始就明确：

Although introduced simultaneously, ONVIF made it clear from the start:

```
设备侧 / Device Side:
  WS-Security UsernameToken: 强制 (Mandatory)
  HTTP Digest: 可选 (Optional)

客户端侧 / Client Side:
  WS-Security UsernameToken: 强制 (Mandatory)
  HTTP Digest: 强制 (Mandatory)
```

**原因 / Reason:**
- WS-Security在SOAP层提供更好的安全性
- WS-Security provides better security at SOAP layer
- HTTP Digest主要用于兼容传统HTTP/RTSP访问
- HTTP Digest mainly for compatibility with traditional HTTP/RTSP access

### 3. **实际使用建议 / Practical Usage Recommendations**

```
2008-2023期间 / 2008-2023 Period:
  推荐: WS-Security UsernameToken + TLS
  Recommended: WS-Security UsernameToken + TLS

2024年至今 / 2024-Present:
  推荐: JWT Token (HTTPS) 或 OAuth2/OIDC
  Recommended: JWT Token (HTTPS) or OAuth2/OIDC

  兼容: WS-Security UsernameToken (向后兼容)
  Compatible: WS-Security UsernameToken (backward compatibility)
```

---

## 📚 规范版本变更记录 / Specification Version Change Log

| 版本 / Version | 发布日期 / Release Date | 认证相关变化 / Auth Changes |
|---------------|------------------------|---------------------------|
| v1.0 | 2008年11月 / Nov 2008 | ✅ 引入WS-Security和HTTP Digest |
| v1.01 | 2009年 / 2009 | - 持续支持 / Continued support |
| Profile S v1.0 | 2011年12月 / Dec 2011 | 📋 明确设备/客户端要求 |
| v16.06 | 2016年6月 / Jun 2016 | 📝 完善双认证处理规则 |
| v17.12 | 2017年12月 / Dec 2017 | 🔒 增强TLS安全建议 |
| v22.12 | 2022年12月 / Dec 2022 | ♻️ 规范持续更新 |
| v23.12 | 2023年12月 / Dec 2023 | 🆕 添加OAuth2/OIDC |
| v24.06 | 2024年6月 / Jun 2024 | 🆕 添加JWT Token |
| v25.06 | 2025年6月 / Jun 2025 | ✅ 四种方式并存 |

---

## 💡 为什么有这两种认证方式？ / Why Two Authentication Methods?

### **设计理念 / Design Philosophy**

ONVIF从诞生之初就考虑了两种使用场景：

ONVIF considered two usage scenarios from its inception:

#### **场景1：SOAP Web Services (主要场景)**
```
使用: WS-Security UsernameToken
优点:
  ✓ SOAP层面的安全
  ✓ 更好的消息完整性
  ✓ 符合Web Services标准
  ✓ 防重放攻击

Usage: WS-Security UsernameToken
Advantages:
  ✓ SOAP-level security
  ✓ Better message integrity
  ✓ Compliant with Web Services standards
  ✓ Replay attack prevention
```

#### **场景2：传统HTTP/RTSP访问**
```
使用: HTTP Digest
优点:
  ✓ HTTP层面的认证
  ✓ 兼容传统HTTP客户端
  ✓ RTSP流媒体认证
  ✓ 简单直接

Usage: HTTP Digest
Advantages:
  ✓ HTTP-level authentication
  ✓ Compatible with traditional HTTP clients
  ✓ RTSP streaming authentication
  ✓ Simple and straightforward
```

### **为什么WS-Security是强制的？**
**Why is WS-Security Mandatory?**

1. **ONVIF的核心是SOAP Web Services**
   - ONVIF's core is SOAP Web Services

2. **更适合设备管理和配置**
   - More suitable for device management and configuration

3. **提供更完整的安全特性**
   - Provides more comprehensive security features

4. **行业最佳实践**
   - Industry best practice

---

## 🎯 总结 / Conclusion

### **关键要点 / Key Takeaways**

1. ⏰ **时间顺序**：WS-Security和HTTP Digest **同时引入**（2008年11月）
   - **Timeline**: WS-Security and HTTP Digest were **introduced simultaneously** (November 2008)

2. 🎖️ **优先级**：WS-Security是强制的，HTTP Digest是可选的（设备侧）
   - **Priority**: WS-Security is mandatory, HTTP Digest is optional (device side)

3. 🔄 **发展**：两种认证方式持续并存17年（2008-2025）
   - **Evolution**: Both methods have coexisted for 17 years (2008-2025)

4. 🆕 **现代化**：2023-2024年引入JWT和OAuth2，但旧方式仍支持
   - **Modernization**: JWT and OAuth2 introduced in 2023-2024, but legacy methods still supported

5. 💻 **实践**：对于新项目，优先考虑JWT/OAuth2，保留WS-Security向后兼容
   - **Practice**: For new projects, prioritize JWT/OAuth2, maintain WS-Security for backward compatibility

---

## 📖 参考文献 / References

- [ONVIF Core Specification v1.0](https://www.onvif.org/specs/core/) (2008)
- [ONVIF Profile S Specification v1.0](https://www.onvif.org/profiles/profile-s/) (2011)
- [ONVIF Core Specification v25.06](https://www.onvif.org/specs/core/ONVIF-Core-Specification.pdf) (2025)
- [ONVIF Specification History](https://www.onvif.org/profiles/specifications/specification-history/)
- [RFC 2617 - HTTP Digest Authentication](https://tools.ietf.org/html/rfc2617)
- [WS-Security UsernameToken Profile 1.0](http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0.pdf)

---

**文档版本 / Document Version**: 1.0
**更新日期 / Last Updated**: 2025-06-XX
**维护者 / Maintainer**: ONVIF_WSDL Project
