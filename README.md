# 🎈 气球飞行游戏 - MyBalloonGame

<div align="center">

[![Made with Phaser](https://img.shields.io/badge/Made%20with-Phaser-blue)](https://phaser.io)
[![Powered by Supabase](https://img.shields.io/badge/Powered%20by-Supabase-green)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**一个功能丰富的多人实时热气球飞行游戏**

[🎮 立即游戏](#) | [📖 快速开始](./快速开始.md) | [📚 完整文档](./完整功能列表.md) | [⚙️ 管理员指南](./管理员设置说明.md)

</div>

---

## ✨ 核心特性

### 🎮 游戏玩法
- 🎨 **精美像素风热气球** - 手绘红白条纹气球 + 吊篮
- ☁️ **动态天空背景** - 分层蓝天 + 缓慢移动的白云
- 🎯 **点击飞行控制** - 点击屏幕，气球平滑飞过去
- 💫 **流畅动画效果** - 呼吸浮动 + 飞行倾斜

### 👥 多人在线
- 🌐 **实时同步** - Supabase Realtime 技术
- 👤 **玩家标识** - 气球上方显示玩家名称
- 🔄 **自动更新** - 实时看到其他玩家移动
- 🧹 **智能清理** - 自动移除离线玩家

### 🎁 游戏系统
- 🪙 **金币系统** - 收集金币，积累财富（100金币=1钻石）
- 💎 **钻石系统** - 游戏积分，可充值获得
- ⚡ **障碍物系统** - 闪电云（-10HP）、小鸟（-5HP）
- 💊 **加血包系统** - 随机出现，恢复生命值
- ❤️ **生命值系统** - 初始100HP，受伤减少
- 💀 **死亡复活** - 钻石复活 或 充值复活

### 💰 经济系统
- 💳 **充值功能** - 支持多种支付方式
- 📱 **支付宝支付** - 扫码支付
- 💚 **微信支付** - 扫码支付
- 💳 **Visa/Mastercard** - 演示模式
- 💎 **钻石兑换** - 1元 = 1000钻石

### ⚙️ 管理系统
- 🔐 **管理员面板** - 统一设置中心
- 🎮 **游戏参数配置** - 调整难度和生成速度
- 💳 **支付设置** - 上传收款码
- 🎯 **广告管理** - 添加背景广告气球

---

## 🚀 快速开始

### 在线游戏（推荐）
直接访问 Vercel 部署地址：
```
https://your-vercel-app.vercel.app
```

### 本地运行
```bash
# 克隆仓库
git clone https://github.com/terminusys/MyBalloonGame.git

# 进入目录
cd MyBalloonGame

# 在浏览器中打开 index.html
```

详细教程请查看：[快速开始指南](./快速开始.md)

---

## 🎮 游戏玩法

### 基础操作
1. **移动**: 点击屏幕任意位置，气球飞过去
2. **收集**: 碰到金币/钻石自动收集
3. **躲避**: 避开闪电云和小鸟
4. **治疗**: 收集加血包恢复生命值

### 游戏目标
- 🪙 收集尽可能多的金币
- 💎 兑换和积累钻石
- ❤️ 保持生命值不归零
- 🏆 成为顶尖飞行员

---

## 📊 游戏数据

### 经济系统
```
充值兑换：
  1元 = 1000钻石

金币兑换：
  100金币 = 1钻石

钻石道具：
  每个道具 = +10钻石
  每100秒生成5个

复活消耗：
  钻石复活：100钻石
  充值复活：0.1元（100钻石）
```

### 生命系统
```
初始生命：100 HP
最大生命：100 HP

伤害：
  闪电云：-10 HP
  小鸟：-5 HP

治疗：
  加血包：+20 HP
  每100秒生成2个
```

### 金币系统
```
生成：随机位置，每帧0.02概率
价值：每个 +10 分
寿命：12秒（最后2秒闪烁）
上限：屏幕最多20个
```

---

## 🛠️ 技术栈

### 前端
- **游戏引擎**: [Phaser.js 3](https://phaser.io/)
- **UI框架**: 原生 HTML5 + CSS3
- **编程语言**: JavaScript (ES6+)

### 后端
- **数据库**: [Supabase](https://supabase.com/) PostgreSQL
- **实时通信**: Supabase Realtime
- **数据存储**: Browser localStorage

### 部署
- **托管平台**: [Vercel](https://vercel.com/)
- **版本控制**: GitHub
- **自动部署**: Git Push 自动触发

---

## 📚 文档导航

| 文档 | 说明 |
|------|------|
| [快速开始.md](./快速开始.md) | 5分钟上手指南 |
| [完整功能列表.md](./完整功能列表.md) | 所有功能详细说明 |
| [管理员设置说明.md](./管理员设置说明.md) | 管理员功能指南 |
| [管理员面板测试指南.md](./管理员面板测试指南.md) | 测试步骤和检查清单 |
| [更新日志.md](./更新日志.md) | 版本历史和更新记录 |
| [钻石系统说明.md](./钻石系统说明.md) | 钻石经济详解 |
| [支付功能使用指南.md](./支付功能使用指南.md) | 支付系统说明 |

---

## ⚙️ 管理员功能

### 登录信息
```
账号: DDKJ
密码: DDKJ88888888
```

### 功能模块
1. **🎮 游戏参数设置**
   - 金币生成速度和数量
   - 钻石道具生成配置
   - 障碍物难度调整
   - 加血包生成频率

2. **💳 支付设置**
   - 支付宝收款码上传
   - 微信收款码上传
   - Visa/Mastercard配置

3. **🎯 广告管理**
   - 添加背景广告气球
   - 设置广告位置和透明度
   - 管理现有广告

详细说明：[管理员设置说明.md](./管理员设置说明.md)

---

## 🎯 路线图

### ✅ 已完成（v2.0）
- [x] 基础游戏玩法
- [x] 多人实时同步
- [x] 金币/钻石系统
- [x] 障碍物和加血包
- [x] 生命值系统
- [x] 死亡复活机制
- [x] 充值系统
- [x] 管理员设置中心
- [x] 响应式设计

### 🔄 进行中（v2.1）
- [ ] 排行榜系统
- [ ] 成就系统
- [ ] 皮肤商店

### 📋 计划中（v3.0）
- [ ] 好友系统
- [ ] 聊天功能
- [ ] 关卡系统
- [ ] 道具系统
- [ ] 服务端验证
- [ ] 反作弊系统

---

## 🐛 已知问题

### 当前限制
1. **支付系统**: 
   - 支付宝/微信为收款码展示，需手动核验
   - Visa/Mastercard为演示模式，需接入真实支付网关

2. **性能优化**: 
   - 建议同时在线玩家 < 50人
   - 大量元素可能影响性能

3. **浏览器兼容**: 
   - 不支持 IE11 及以下版本
   - 推荐使用 Chrome/Edge/Safari

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发指南
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 👥 团队

- **开发团队**: DDKJ Team
- **维护者**: [@terminusys](https://github.com/terminusys)

---

## 🙏 致谢

- [Phaser.js](https://phaser.io/) - 强大的游戏引擎
- [Supabase](https://supabase.com/) - 优秀的后端服务
- [Vercel](https://vercel.com/) - 便捷的部署平台

---

## 📞 联系方式

- **GitHub**: https://github.com/terminusys/MyBalloonGame
- **Issues**: https://github.com/terminusys/MyBalloonGame/issues

---

<div align="center">

**⭐ 如果觉得有趣，请给个 Star！⭐**

Made with ❤️ by DDKJ Team

</div>
