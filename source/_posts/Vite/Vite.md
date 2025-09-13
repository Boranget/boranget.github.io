---
title: Vite
date: 2023-04-22 10:35:19
updated: 2023-11-11 16:40:19
tags:
  - Vite
categories:
  - 笔记
---

# Vite

用于搭建前端项目的脚手架

npm+vite相当于后端的maven

# 使用Vite创建项目

```bash
npm create vite
```

初次使用会提示下载vite依赖，输入y继续

- 输入工程名
- 选择依赖的框架
- 选择语法 JS or TS

# 下载依赖

vite创建好工程后有package.json，但并没有下载依赖，npm i 下载package.json中的依赖

# path

`path` 模块主要用于生成绝对路径，这样可以在项目代码中使用相对路径别名来引用文件和目录。具体地，`path.resolve` 函数用于将相对路径解析为绝对路径。

下面是代码中 `path` 用法的详细解释：

```javascript
import path from "path";

// ... 其他代码 ...

resolve: {
  alias: {
    '@': path.resolve(__dirname, './src')
  }
}
```

1. **`import path from "path";`**：
   这行代码从 Node.js 的内置模块中导入了 `path` 模块。

2. **`path.resolve`**：
   `path.resolve` 是一个方法，用于将一系列的路径或路径片段解析为绝对路径。

3. **`__dirname`**：
   `__dirname` 是一个 Node.js 中的全局变量，它表示当前执行脚本所在的目录的绝对路径。

4. **`'./src'`**：
   这是一个相对路径，指向当前目录下的 `src` 子目录。

5. **`path.resolve(__dirname, './src')`**：
   这行代码将 `__dirname`（当前脚本的目录）和 `'./src'`（相对路径）解析为绝对路径。这样，无论 Vite 配置文件被放在项目的哪个位置，都能准确地定位到 `src` 目录的绝对路径。

6. **`alias: { '@': ... }`**：
   在 Vite 的 `resolve` 配置中，`alias` 允许我们定义路径别名。在这个例子中，`'@'` 被设置为 `src` 目录的绝对路径。这意味着在项目的其他文件中，可以通过 `'@'` 来引用 `src` 目录下的文件，而不需要写完整的相对路径或绝对路径。

举个例子，如果有一个文件位于 `src/components/MyComponent.vue`，在另一个文件中，你可以这样引用它：

```javascript
import MyComponent from '@/components/MyComponent.vue';
```

而不是使用相对路径，比如：

```javascript
import MyComponent from '../../components/MyComponent.vue';
```

使用别名可以使代码更加清晰，也更容易维护，特别是在大型项目中，目录结构可能相对复杂。通过 `path.resolve` 和路径别名，可以简化路径的引用方式，提高开发效率。

# server

```js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from "path"

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server:{
    hmr: true,
    port: 3001,
    proxy:{
      '/api':{
        target: "http://localhost:8081/",
        secure: false,
        changeOrigin: true,
        pathRewrite:{
          '^/api':'/api',
        }
      }
    }
  },
  resolve: {
    alias:{
      '@' :path.resolve(__dirname, './src')
    }
  }
})

```



配置片段中，`server` 对象包含了 Vite 服务器的配置选项。这些选项用于控制开发服务器的行为，如热模块替换（HMR）、端口设置以及代理配置。下面是对这些配置的详细解释：

## server 配置

1. hmr:
   - **值**: `true`
   - **说明**: 这表示启用了热模块替换（Hot Module Replacement）。HMR 是一种允许在不完全刷新页面的情况下更新模块的技术，它对于提升开发体验非常有用，因为它能够保持应用状态，并在代码更改时实时更新。
2. port:
   - **值**: `3001`
   - **说明**: 这设置了 Vite 开发服务器监听的端口号。在此配置中，服务器将在 `3001` 端口上启动。
3. proxy:
   - **说明**: 代理配置用于将特定路径的请求代理到另一个服务器。这在开发前端应用时非常有用，特别是当你需要访问后端 API 或其他服务时。

## proxy 配置

1. '/api':
   - **说明**: 这是代理的匹配路径。所有以 `/api` 开头的请求都会被代理到指定的目标服务器。
2. target:
   - **值**: `"http://localhost:8081/"`
   - **说明**: 这是代理的目标服务器地址。所有匹配 `/api` 的请求都将被转发到这个地址。
3. secure:
   - **值**: `false`
   - **说明**: 当代理到 HTTPS 站点时，如果不需要验证 SSL 证书，则将此设置为 `false`。由于目标服务器使用的是 `http://`（非安全连接），所以这里设置为 `false`。
4. changeOrigin:
   - **值**: `true`
   - **说明**: 在某些情况下，目标服务器可能期望请求来自与 `target` 相同的主机。设置 `changeOrigin` 为 `true` 将改变请求头的 `Host` 和 `Origin` 字段，以匹配 `target` 的主机。
5. pathRewrite:
   - **说明**: 用于重写请求的路径。在这个配置中，请求的路径实际上没有被重写，因为 `'^/api':'/api'` 实际上是一个恒等映射。通常，你可能会使用这个功能来去除或添加某些路径前缀。

## 总结

此配置片段设置了 Vite 开发服务器以在 `3001` 端口上运行，并启用了热模块替换。它还配置了一个代理，将所有以 `/api` 开头的请求转发到本地运行的 `http://localhost:8081/` 服务器，而不改变请求的路径。这通常用于在前端开发中模拟或访问后端 API。