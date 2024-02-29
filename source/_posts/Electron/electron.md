---
title: electron
date: 2022-11-28 16:50:30
updated: 2023-05-31 10:35:19
tags:
  - electron
categories:
  - notes
---

# 入门

## 项目准备

### 拓展

### ()=>{} 与()=>的区别

不加{}时,后面直接加返回值,加大括号,需要在其中加入返回语句

### const{a} = b与 const a= b的区别

个人理解:

const{a} = b 是 获取 b中一个叫a的属性

const a = b 是把b赋给a

#### npm install

```bash
npm install moduleName # 安装模块到项目目录下
 
npm install -g moduleName # -g 的意思是将模块安装到全局，具体安装到磁盘哪个位置，要看 npm config prefix 的位置。
 
npm install -save moduleName # -save 的意思是将模块安装到项目目录下，并在package文件的dependencies节点写入依赖。
 
npm install -save-dev moduleName # -save-dev 的意思是将模块安装到项目目录下，并在package文件的devDependencies节点写入依赖。

```

![image-20221103092647748](electron/image-20221103092647748.png)

#### npm 文件夹权限问题：

右键属性，安全页面给所有用户完全访问权限

[【Node.js】Node.js安装及环境配置 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1572591)

### 主体

#### 初始化脚手架

```bash
# 新建项目文件夹
npm init
```

参数类似于

```json
{
  "name": "my-electron-app",
  "version": "1.0.0",
  "description": "Hello World",
  "main": "main.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Boranget",
  "license": "MIT",
  "devDependencies": {
    "electron": "^21.2.2"
  }
}

```

修改package.json,在scripts字段下新增:

```json
{
  "scripts": {
    "start": "electron ."
  }
}
```

#### 运行主进程

在根目录下创建main.js,并运行npm start

#### 最后文件结构

**index.html**

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <!-- https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP -->
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self'">
    <title>Hello World!</title>
  </head>
  <body>
    <h1>Hello World!</h1>
    We are using Node.js <span id="node-version"></span>,
    Chromium <span id="chrome-version"></span>,
    and Electron <span id="electron-version"></span>.
    <script src="./render.js"></script>
  </body>
</html>
```

**main.js**

```js
// 引入依赖
const {app, BrowserWindow} = require('electron')
const path = require('path')


const createWinddow = ()=>{
    // 创建一个新的浏览器窗口
    const win = new BrowserWindow({
        width: 800,
        height:600,
        webPreferences:{
            // 预加载js
            preload: path.join(__dirname, 'preload.js')
        }
        
    })
    // 加载index.html
    win.loadFile('index.html')
}
// 在Electron结束初始化和创建浏览器窗口时调用
app.whenReady().then(
    ()=>{
        createWinddow()
        // 在mac系统上, 需要在用户点击图标后(若无已创建窗口)新建一个窗口
        app.on('activate',()=>{
            if(BrowserWindow.getAllWindows().length === 0){
                createWinddow()
            }
        })
    }
) 
// 除mac外,在所有窗口被关闭后,退出程序
app.on('window-all-closed', ()=>{
    if(process.platform !== 'darwin'){
        app.quit()
    }
})
```

**preload.js**

```js
window.addEventListener('DOMContentLoaded', ()=>{
    const replaceText = (selector,text)=>{
        const element = document.getElementById(selector)
        if(element){
            element.innerText = text
        }
    }
    for(const dependency of ['chrome', 'node', 'electron']){
        replaceText(`${dependency}-version`,process.versions[dependency])
    }
})
```

注意这里为何要用预加载:

> 在网页中我们需要获取node 版本号,这些信息在Node的全局变量process中,只能在主进程访问,但我们在主进程中无法直接编辑DOM,所以我们需要通过预加载脚本来控制DOM
>
> ```txt
> 现在，最后要做的是输出Electron的版本号和它的依赖项到你的web页面上。
> 
> 在主进程通过Node的全局 process 对象访问这个信息是微不足道的。 然而，你不能直接在主进程中编辑DOM，因为它无法访问渲染器 文档 上下文。 它们存在于完全不同的进程！
> 
> 注意：如果您需要更深入地了解Electron进程，请参阅 进程模型 文档。
> 
> 这是将 预加载 脚本连接到渲染器时派上用场的地方。 预加载脚本在渲染器进程加载之前加载，并有权访问两个 渲染器全局 (例如 window 和 document) 和 Node.js 环境。
> ```

一些node.js中的概念

>- **__dirname**字符串指向当前正在执行脚本的路径 (在本例中，它指向你的项目的根文件夹)。
>
>- **path.joinAPI** 将多个路径联结在一起，创建一个跨平台的路径字符串。

**总结**

- 我们启动了一个Node.js程序，并将Electron添加为依赖。
- 我们创建了一个 `main.js` 脚本来运行我们的主要进程，它控制我们的应用程序 并且在 Node.js 环境中运行。 在此脚本中， 我们使用 Electron 的 `app` 和 `BrowserWindow` 模块来创建一个浏览器窗口，在一个单独的进程(渲染器)中显示网页内容。
- 为了访问渲染器中的Node.js的某些功能，我们在 `BrowserWindow` 的构造函数上附加了一个预加载脚本。

#### 打包

使用 electron forge

**安装**

```bash
npm install --save-dev @electron-forge/cli
npx electron-forge import
```

**打包**

```bash
npm run make
```

