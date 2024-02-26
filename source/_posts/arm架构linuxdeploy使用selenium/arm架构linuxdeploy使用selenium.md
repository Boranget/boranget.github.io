---
title: arm架构linuxdeploy使用selenium
date: 2021-08-15 16:50:30
updated: 2023-05-31 16:50:30
tags:
  - 服务器
categories:
  - 经验
---

# linuxdeploy使用selenium
参考文章[https://blog.csdn.net/nopname/article/details/99484475](https://blog.csdn.net/nopname/article/details/99484475)
1. 由于我的手机是arm架构，而谷歌浏览器没有提供arm版本，所以使用firefox
2.系统：Ubuntu
3. 安装
	1. apt install firefox-esr # 安装火狐浏览器
	2. sudo apt-get install iceweasel xvfb -y # 虚拟显示
	3. sudo pip3 install selenium==2.53.6 pyvirtualdisplay pytest 
	4. 安装驱动
		i. 驱动下载：Release v0.23.0 · mozilla/geckodriver (github.com)
		ii. 其中v0.23.0还提供arm版本，后面的版本就没有arm的了
		iii. 使用wget 下载：
			1) 没有wget：apt-get install wget
		iv. 
		```
		wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-arm7hf.tar.gz
		tar -xf geckodriver-v0.19.1-arm7hf.tar.gz
		rm geckodriver-v0.19.1-arm7hf.tar.gz
		sudo chmod a+x geckodriver
		sudo mv geckodriver /usr/local/bin/
		```
4. 测试
	1. 新建一个文件
		vim test.py
		内容：
		```python
		from selenium import webdriver
		from pyvirtualdisplay import Display
		display = Display(visible=0, size=(800, 600))
		display.start()
		profile = webdriver.FirefoxProfile()
		profile.native_events_enabled = False
		driver = webdriver.Firefox(profile)
		driver.set_page_load_timeout(60)
		```
		执行 python3 test.py
跑完不报错即正常