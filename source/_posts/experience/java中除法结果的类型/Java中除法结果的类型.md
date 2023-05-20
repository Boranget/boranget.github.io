---
title: Java中除法结果的类型
date: 2021-02-22 16:50:30
tags:
---

# 代码
```java

public class TTESSTT {
	public static void main(String []args) {
		int i0 = 15;
		int i1 = 10;
		double i2 = 15.0;
		double i3 = 10.0;
		
		Object j0 = i0 / i1;
		Object j1 = i0 / i3;
		Object j2 = i2 / i3;
		Object j3 = i2 / i1;
		
		Object j4 = i1 / i0;
		
		System.out.println(
				"j0:"+j0+" "+j0.getClass()+
				"\nj1:"+j1+" "+j1.getClass()+
				"\nj2:"+j2+" "+j2.getClass()+
				"\nj3:"+j3+" "+j3.getClass()+
				"\nj4:"+j4+" "+j4.getClass()
				);
		
	}

}

```


# 结果
![在这里插入图片描述](Java中除法结果的类型/20210222181248860.png)
# 所以
Java的“ / ” 运算中，只要除数与被除数中有一个是double类型，结果便为double类型。