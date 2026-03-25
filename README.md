# hsnips

HyperSnips snippets repo.

## 配置方案

**源文件位置**: Windows `Documents/hsnips-repo`  
**WSL 访问**: 通过符号链接  
**Windows 编辑器**: 通过 Junction 链接

## 一键配置（WSL 环境）

```bash
./scripts/setup_hsnips.sh --mode windows-source
```

这会：
1. 将仓库克隆到 Windows `Documents/hsnips-repo`
2. 在 WSL HyperSnips 路径创建符号链接
3. 在 Windows 编辑器路径创建 Junction

## WSL 插件读取问题解决

由于 WSL 跨文件系统限制，HyperSnips 插件可能无法直接读取 Windows 路径的符号链接。请使用**方案 1**：

在 WSL 的 VS Code 中修改 `settings.json`：

```json
{
  "hsnips.hsnipsDirectory": "/mnt/c/Users/$USER/Documents/hsnips-repo"
}
```

或者通过 UI 设置：
1. `Ctrl + Shift + P` → `Preferences: Open User Settings (JSON)`
2. 添加上述配置

## 自然语言提示词（复制给 AI）

```
请帮我配置 HyperSnips，使用以下方案：

方案：源文件放在 Windows 本地，WSL 通过配置直接访问

要求：
1) 克隆仓库到 Windows Documents 目录：
   C:\Users\<用户名>\Documents\hsnips-repo

2) 创建 Windows Junction（供编辑器直接访问）：
   - Code: %APPDATA%\Code\User\globalStorage\draivin.hsnips\hsnips
   - Antigravity: %APPDATA%\Antigravity\User\globalStorage\draivin.hsnips\hsnips

3) 【关键】配置 WSL 的 VS Code 指向 Windows 路径：
   在 WSL 的 settings.json 中添加：
   "hsnips.hsnipsDirectory": "/mnt/c/Users/<用户名>/Documents/hsnips-repo"

4) 完成后验证：
   - Windows 路径能列出所有 .hsnips 文件
   - WSL VS Code 能正常使用 HyperSnips 片段
   - git remote -v 显示正确

请直接执行，不需要我手动操作中间步骤。
```

## HyperSnips 官方路径

- Windows: `%APPDATA%\Code\User\globalStorage\draivin.hsnips\hsnips\(language).hsnips`
- macOS: `$HOME/Library/Application Support/Code/User/globalStorage/draivin.hsnips/hsnips/(language).hsnips`
- Linux: `$HOME/.config/Code/User/globalStorage/draivin.hsnips/hsnips/(language).hsnips`
