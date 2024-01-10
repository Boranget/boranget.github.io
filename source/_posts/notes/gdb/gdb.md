---
title: gdb
date: 2023-01-05 13:35:19
tags:
  - gdb
categories:
  - 笔记
---

# 参考资料

[手把手教你拆解 CSAPP 的 炸弹实验室 BombLab - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/451623574)

# 打开gdb中的历史记录

使用命令

```bash
echo 'set history save on' >> ~/.gdbinit && chmod 600 ~/.gdbinit
```

但在layout regs和layout asm下无法使用

# 运行

- gdb bomb：使用gdb调试可执行文件bomb
- r：run，运行程序，遇到断点时停止
- c：continue，继续执行，到下一个断点停止
- q：quit，退出gdb调试
- si：单指令执行，每次只执行一条指令
- n：next，单步跟踪程序，遇到函数调用时，不会进入函数体内部
- s：step，单步调试，遇到函数调用时，会进入函数体内部
- until：运行到退出循环体
- until + 行号：运行至行号处

# 设置断点

- b n：break n，在第n行设置断点
- b func：在函数func的入口处设置断点
- b *地址：在地址处设置断点如b *0xffff
- i b：info b，显示当前程序的断点设置情况，会给出各个断点的断点号，类型等信息
- delete 断点号：删除第n个断点
- disable 断点号：暂停该个断点生效
- enable 断点号：生效该断点
- delete breakpoints：删除所有断点

# 分割窗口

- layout regs：显示寄存器和反汇编窗口
- layout asm：显示反汇编窗口

# 显示内容

- `x/[count][format][address]` ：打印内存值，从所给address开始，以指定格式（format）显示count个值。常见的format：d decimal，x hex，t binary，f floating point，i instruction，c character，s string（以8bit字符串形式显示数据）
- i r 寄存器名：info registers 寄存器名，查看当前某个寄存器的内容，寄存器名前不需要%，例如i r rsi
- ctrl+l：清屏，linux自带的清屏命令
- print 变量名 打印变量中存储的内容