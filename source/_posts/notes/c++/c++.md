---
title: c++
date: 2022-12-2 09:34:30
tags:
  - c++
categories:
  - 笔记
---

# C++数据类型

## 七种基本数据类型

1. bool 布尔型
2. char 字符型
3. int 整型
4. float 浮点型
5. double 双浮点型
6. void 无类型
7. wchar_t 宽字符型

### 修饰符

- signed
- unsigned
- short
- long

### 内存占用

- 不同的系统会有差异
- 默认情况下,int, short, long都是带符号的

## typeof

可使用typeof为已有类型取一个新的名字

```cpp
typedef int feet;
feet distance;
```



## 枚举类型

若干枚举常量的集合

```cpp
enum color{
    red,
    green,
    blue
} c;
c = blue;
```

默认情况下，第一个名称的值为 0，第二个名称的值为 1，第三个名称的值为 2，以此类推。但是，您也可以给名称赋予一个特殊的值，只需要添加一个初始值即可。例如，在下面的枚举中，**green** 的值为 5。

```cpp
enum color{
    red,
    green = 5,
    blue
};
```

需要注意的是,枚举类型中只能赋值整型常量

# 变量

## 变量定义

变量定义指定一个数据类型,并包含了该类型的一个或多个变量的列表

```cpp
int    i, j, k;
char   c, ch;
float  f, salary;
double d;
```

变量可以在声明的时候被初始化

```cpp
extern int d = 3, f = 5;
int d = 3, f = 5;
byte z = 22;
charr x = 'x';
```

## 变量声明

变量声明向编译器保证变量以给定的类型和名称存在，这样编译器在不需要知道变量完整细节的情况下也能继续进一步的编译。变量声明只在编译时有它的意义，在程序连接时编译器需要实际的变量声明。

当您使用多个文件且只在其中一个文件中定义变量时（定义变量的文件在程序连接时是可用的），变量声明就显得非常有用。您可以使用 **extern** 关键字在任何地方声明一个变量。虽然您可以在 C++ 程序中多次声明一个变量，但变量只能在某个文件、函数或代码块中被定义一次。

```cpp
#include <iostream>
using namespace std;
 
// 变量声明
extern int a, b;
extern int c;
extern float f;
  
int main ()
{
  // 变量定义
  int a, b;
  int c;
  float f;
 
  // 实际初始化
  a = 10;
  b = 20;
  c = a + b;
 
  cout << c << endl ;
 
  f = 70.0/3.0;
  cout << f << endl ;
 
  return 0;
}
```

## 函数声明

```cpp
// 函数声明
int func();
 
int main()
{
    // 函数调用
    int i = func();
}
 
// 函数定义
int func()
{
    return 0;
}
```

## 变量作用域

- 全局变量: 所有函数外部声明的变量
- 形式参数: 参数定义
- 局部变量: 函数或代码块内部声明的变量

在程序中，局部变量和全局变量的名称可以相同，但在函数内，局部变量的值会覆盖全局变量的值。

全局变量会被初始化,局部变量不会

| 数据类型 | 初始化默认值 |
| :------- | :----------- |
| int      | 0            |
| char     | '\0'         |
| float    | 0            |
| double   | 0            |
| pointer  | NULL         |

## 常量

### 整数常量

**前缀**：

不带前缀为十进制

0前缀标识八进制

0x前缀表示十六进制

**后缀：**

U表示无符号整数，不带U表示有符号

L表示长整数，

后缀不区分大小写

```cpp
// 212
// 212u
// 0xFeeL
// 30ul
```

### 浮点常量

```cpp
// 3.14
// 314E-2
```

### 布尔常量

```cpp
// true
// false
```

不应将true看为1, 把 false看为0

### 字符常量

在单引号中.

如果常量以 L（仅当大写时）开头，则表示它是一个宽字符常量（例如 L'x'），此时它必须存储在 **wchar_t** 类型的变量中。否则，它就是一个窄字符常量（例如 'x'），此时它可以存储在 **char** 类型的简单变量中。

### 字符串常量

在双引号中.

当有换行需求时,可使用\,这在java中是不被允许的

```cpp
#include <iostream>
#include <string>
using namespace std;

int main() {
    string greeting = "hello, runoob";
    cout << greeting;
    cout << "\n";     // 换行符
    string greeting2 = "hello, \
                       runoob";
    cout << greeting2;
    return 0;
}
```

### 定义常量

- #define 预处理器
- const 关键字

```cpp
#include <iostream>
using namespace std;
 
#define LENGTH 10   
#define WIDTH  5
#define NEWLINE '\n'
 
int main()
{
 
   int area;  
   
   area = LENGTH * WIDTH;
   cout << area;
   cout << NEWLINE;
   return 0;
}
```

```cpp
#include <iostream>
using namespace std;
 
int main()
{
   const int  LENGTH = 10;
   const int  WIDTH  = 5;
   const char NEWLINE = '\n';
   int area;  
   
   area = LENGTH * WIDTH;
   cout << area;
   cout << NEWLINE;
   return 0;
}
```

# c++修饰符

signed 整型 字符型

unsigned 整型 字符型

long 整型 双精度型

short 整型

signed 与 unsigned 也可作为 long或short修饰符的前缀,如 unsigned long int

允许隐含 int:

```cpp
unsigned x;
```

**无符号与有符号的区别**

```cpp
#include <iostream>
using namespace std;
 
/* 
 * 这个程序演示了有符号整数和无符号整数之间的差别
*/
int main()
{
   short int i;           // 有符号短整数
   short unsigned int j;  // 无符号短整数
 
   j = 50000;
 
   i = j;
   cout << i << " " << j;
 
   return 0;
}
```

```text
-15536 50000
```

这里可以看出,将一个无符号变量的值赋给一个有符号变量时,无符号中的非符号位会变为有符号变量值的变量位,从而引起值的变化

## 类型限定符

const 常量

volatile 不要优化此变量

restrict 由 **restrict** 修饰的指针是唯一一种访问它所指向的对象的方式

# 存储类

定义变量或函数的可见性范围和生命周期

- auto
- register
- static
- extern
- mutable
- thread_local

从c++ 17 开始,auto不再是c++存储类说明符,且register关键字被弃用

## auto

自动类型,可用于变量或方法返回值

```cpp
auto f=3.14;
auto z = new auto(9);
// auto x1 = 5,x2 = 'c' 错误用法,必须为同一类型
```

## register

用于定义存储在寄存器中而不是ram中的变量,这意味着它最大尺寸等于寄存器的大学,且他没有内存位置,无法进行医院的&运算

 寄存器只用于需要快速访问的变量，比如计数器。还应注意的是，定义 'register' 并不意味着变量将被存储在寄存器中，它意味着变量可能存储在寄存器中，这取决于硬件和实现的限制。

## static

指示编译器在程序的生命周期内保持局部变量的存在.而不需要在每次它进入和离开作用域时进行创建和销毁. 因此 使用static修饰局部变可以在函数调用之间保持局部变量的值. 

sstatic修饰符也可应用于全局变量, 当static修饰全局变量时, 会使变量的作用域限制在声明它的文件内. 

在类数据或成员上使用static作用类似于java

```cpp
#include <iostream>
using namespace std;
// 函数声明
void func(void);
// 全局变量
static int count = 10;
int main(){
    while(count --){
        func();
    }
    return 0;
}
void func(void){
    static int i =5;
    i ++;
    cout << "变量i为" << i;
    cout << ",变量count为"<< count << endl;
}
```

## extern

用于提供一个全局变量的引用, 全局变量对所有的程序文件都是可见的, 当使用extern时,对于无法初始化的变量, 会把变量名指向一个之前定义过的存储位置.

extern多用于多个文件共享相同的全局变量或函数的时候.

举例:

```cpp
#include <iostream>
int count;
extern void write_extern();
int main(){
    count = 5;
    write_extern();
}
```

```cpp
#include <iostream>

extern int count;

void write_extern(void){
    std::cout << "Count is " << count << std::endl;
}
```

## mutable

mutable成员可以通过const成员函数修改

## thread_local

使用thread_local声明的变量只能在其上创建的线程访问, 变量在创建线程时创建,在销毁线程时销毁,每个线程都有自己的变量副本.

thread_local不能用于函数声明或定义

# 运算符

## 算术运算符

+, -, *, /, %, ++, --

## 关系运算符

==, !=, >, <, >=, <= 

## 逻辑运算符

&&, ||, !

## 位运算符

&, |, ^, ~, >>, <<

## 赋值运算符

各种等于,包括算术运算符与位运算符

如+=,|=,但不包括非运算

## 其他

**sizeof**

返回变量的大小

**Condition?X:Y** 

三目运算符

**,** 

逗号运算符,执行一系列运算,整个表达式的值是最后一个表达式的值,java中没有逗号运算符或者说没有这个作用

**. 和 ->**

成员运算符,用于引用类,结构和共用体的成员

**Cast**

强制转换

**&**

指针运算符,返回变量的实际地址

**\***

指针运算符,指向一个变量,例如*var,将指向变量var

## 运算符优先级

| 类别       | 运算符                            | 结合性   |
| :--------- | :-------------------------------- | :------- |
| 后缀       | () [] -> . ++ - -                 | 从左到右 |
| 一元       | + - ! ~ ++ - - (type)* & sizeof   | 从右到左 |
| 乘除       | * / %                             | 从左到右 |
| 加减       | + -                               | 从左到右 |
| 移位       | << >>                             | 从左到右 |
| 关系       | < <= > >=                         | 从左到右 |
| 相等       | == !=                             | 从左到右 |
| 位与 AND   | &                                 | 从左到右 |
| 位异或 XOR | ^                                 | 从左到右 |
| 位或 OR    | \|                                | 从左到右 |
| 逻辑与 AND | &&                                | 从左到右 |
| 逻辑或 OR  | \|\|                              | 从左到右 |
| 条件       | ?:                                | 从右到左 |
| 赋值       | = += -= *= /= %=>>= <<= &= ^= \|= | 从右到左 |
| 逗号       | ,                                 | 从左到右 |

# 循环

## while

```cpp
while(condition){
    
}
```

## for

```cpp
for(init;condition;increment){
    
}
// 一个无限循环
for(;;){
    
}
```

## do while

```cpp
do{
    
}while(condition);
```

# go to

不建议

```cpp
goto label;
..
.
label: statement;
```

一个例子

```cpp
#include <iostream>
using namespace std;
 
int main ()
{
   // 局部变量声明
   int a = 10;

   // do 循环执行
   LOOP:do
   {
       if( a == 15)
       {
          // 跳过迭代
          a = a + 1;
          goto LOOP;
       }
       cout << "a 的值：" << a << endl;
       a = a + 1;
   }while( a < 20 );
 
   return 0;
}
```



# 判断

## if

## else

## switch

```cp
switch(expression){
    case constant-expression  :
       statement(s);
       break; // 可选的
    case constant-expression  :
       statement(s);
       break; // 可选的
  
    // 您可以有任意数量的 case 语句
    default : // 可选的
       statement(s);
}
```



# 函数/方法

## 定义

```cpp
return_type function_name( parameter list )
{
   body of the function
}
```

## 声明

函数声明主要是为了告诉编译器函数名称及如何调用函数, 函数的实际主体可以单独定义

包括

```cpp
return_type function_name(parameter list);
```

例如

```cpp
int max(int num1, int num2);
// 或者
int max(int, int);
```

当在一个源文件中用一个函数,但该函数的定义在另一个文件中,函数声明是必须的,这种情况下, 应在调用函数的文件顶部声明函数

## 调用

声明或定义一定在调用之前

### 传值调用

把参数的实际值付给形参,在这种情况下, 修改函数内的形式参数对实际参数没有影响

**一个交换例子**

```cpp
// 函数定义
void swap(int x, int y)
{
   int temp;
 
   temp = x; /* 保存 x 的值 */
   x = y;    /* 把 y 赋值给 x */
   y = temp; /* 把 x 赋值给 y */
  
   return;
}
```



```cpp
#include <iostream>
using namespace std;
 
// 函数声明
void swap(int x, int y);
 
int main ()
{
   // 局部变量声明
   int a = 100;
   int b = 200;
 
   cout << "交换前，a 的值：" << a << endl;
   cout << "交换前，b 的值：" << b << endl;
 
   // 调用函数来交换值
   swap(a, b);
 
   cout << "交换后，a 的值：" << a << endl;
   cout << "交换后，b 的值：" << b << endl;
 
   return 0;
}

```



### 指针调用

**目前理解为,指针为直接操作指向的变量**

**x本身存储的是地址, 但*x就是直接操作这个地址中的值了**

将参数的地址赋给形式参数,在函数内使用该地址访问实际要用到的参数,

```cpp
#include <iostream>
using namespace std;
void swap(int *locationA, int *locationB){
    cout << "locationA: " << locationA << endl;
    cout << "locationB: " << locationB << endl;
    cout << "*locationA: " << *locationA << endl;
    cout << "*locationB: " << *locationB << endl;
    int temp;
    temp = *locationA;
    *locationA = *locationB;
    *locationB = temp;
    return;
}
int main(){
    int a = 1;
    int b = 2;
    swap(&a,&b);
    cout << "after" << endl;
    cout << "a: " << a << endl;
    cout << "b: " << b << endl;


    return 0;
}
```

```te
PS E:\test\zm> ./point
locationA: 0x61fe1c
locationB: 0x61fe18
*locationA: 1
*locationB: 2
after
a: 2
b: 1
```



### 引用调用

**相当于直接把整个变量传了过去,而不是传值,传进去之后,对面可以直接当变量用且修改**

将参数的引用赋给形式参数,该引用用于访问调用中要用到的实际参数

```cpp
#include <iostream>
using namespace std;
void swap(int &A, int &B){
    cout << "A: " << A << endl;
    cout << "B: " << B << endl;
    cout << "&A: " << &A << endl;
    cout << "&B: " << &B << endl;
    int temp;
    temp = A;
    A = B;
    B = temp;
    return;
}
int main(){
    int a = 1;
    int b = 2;
    swap(a,b);
    cout << "after" << endl;
    cout << "a: " << a << endl;
    cout << "b: " << b << endl;
    return 0;
}
```

## 参数默认值

可以对形参指定一个默认值,如果调用时参数留空,则会使用默认值

这个默认值其实是在函数声明时做的,当声明为单独时,需要在声明中定义默认值,不能再定义中定义默认值,当只有定义时,默认值在定义中给出

```cpp
#include <iostream>
using namespace std;
int returnDefault(int  a = 10);
int main(){
    cout << returnDefault() << endl;
    cout << returnDefault(20)  << endl;
    return 0;
}
int returnDefault (int a){
    return a;
}
```

## Lambda

```cpp
[capture](parameters)->return-type{body}
// 如果 lambda 函数没有传回值（例如 void），其返回类型可被完全忽略。
[capture](parameters){body}
```

如

```cpp
[](int x, int y) -> int { int z = x + y; return z + x; }
[](int x, int y){ return x < y ; }
```

>[]      // 沒有定义任何变量。使用未定义变量会引发错误。
>[x, &y] // x以传值方式传入（默认），y以引用方式传入。
>[&]     // 任何被使用到的外部变量都隐式地以引用方式加以引用。
>[=]     // 任何被使用到的外部变量都隐式地以传值方式加以引用。
>[&, x]  // x显式地以传值方式加以引用。其余变量以引用方式加以引用。
>[=, &z] // z显式地以引用方式加以引用。其余变量以传值方式加以引用。

对于[=]或[&]的形式，lambda 表达式可以直接使用 this 指针。但是，对于[]的形式，如果要使用 this 指针，必须显式传入：

```cpp
[this]() { this->someFunc(); }();
```

# 数字

```cpp
   short  s;
   int    i;
   long   l;
   float  f;
   double d;
   
   // 数字赋值
   s = 10;      
   i = 1000;    
   l = 1000000;  
   f = 230.47;  
   d = 30949.374;
```

## 数学运算

#include \<cmath\>

## 随机数

```cpp
#include <iostream>
#include <ctime>
#include <cstdlib>

using namespace std;
int main(){
    // 生成种子,为了使每次运行程序的结果不同
    srand((unsigned)time(NULL));
    for(int i = 0; i < 10; i++){
        int j = rand();
        cout << j << endl;
    }
    return 0;
}
```

# 数组

 所有的数组都是由连续的内存位置组成， 最低的地址对于第一个元素，最高的地址对于最后一个元素

## 声明

```cpp
type arrayName [ arraySize ];
```

type 可以是任意有效的 C++ 数据类型
如

```cpp
double balance[10];
```


## 初始化

```cpp
double balance[5] = {1000.0,2.0,3.4,7.0,50.0}
```

当长度与初始化列表数量不等时:

​	若初始化列表大于数组长度,编译报错;

​	若初始化列表小于数组长度,其余位置补0;

其中可省略长度, 数组长度为后方初始化时元素的长度

```cpp
double balance[] = {1000.0,2.0,3.4,7.0,50.0}
```

## 数组长度获取

sizeof()

```cpp
#include <iostream>
using namespace std;
int main(){
    int a[5] = {1,2,3,4,5,6,7};
    for(int i = 0; i < sizeof(a)/sizeof(a[0]); i ++){
        cout << a[i] << endl;
    }
    return 0;
}
```

## 多维数组

```cpp
type name[size1][size2][size3]
```

### 二维数组

```cpp
int A[3][4] = 
{  
 {0, 1, 2, 3} ,   /*  初始化索引号为 0 的行 */
 {4, 5, 6, 7} ,   /*  初始化索引号为 1 的行 */
 {8, 9, 10, 11}   /*  初始化索引号为 2 的行 */
};
```

内嵌括号可省略

```cpp
int a[3][4] = {0,1,2,3,4,5,6,7,8,9,10,11};
```

#### 访问二维数组

```cpp
int val = a[2][3];
```

## 指向数组的指针

```cpp
int a[50];
```

a 是一个指向&a[0] 的指针,

```cpp
int *p;
int a[50];
p = a;
```

p值为数组a中第一个元素的地址

可使用指针运算访问数组元素

```cpp
#include <iostream>
using namespace std;
int main()
{
    char a[] = {'a', 'b', 'c', '\0'};
    cout << (a+1) << endl;
    cout << *(a+1) << endl;
    cout << a << endl;
    *a = '2';
    cout << a << endl;
    *(a+2) = 'd';
    cout << a << endl;
    return 0;
}
```

```
PS C:\test> ./pointerTest
bc
b
abc
2bc
2bd
```

## 传递数组给函数

三种声明方式

```cpp
void myFunction(int *param);
void myFunction(int param[10]);
void myFunction(int param[]);
```

三种声明方式效果完全一样

且c++不会对形式参数做边界检查

```cpp
#include<iostream>
using namespace std;
void coutArray(int a[1]);
int main(){
    int a[] = {1,2,3,4,5};
    coutArray(a);
    return 0;
}
void coutArray(int a[1]){
    for(int i = 0; i < 5; i++){
        cout << a[i] << endl;
    }
}

```

```
PS C:\test> ./arrayTest
1
2
3
4
5
```



## 从函数返回数组

返回指针时,指向的变量必须为静态变量

```cpp
#include<iostream>
using namespace std;
int* initArray();
int main(){
    
    int *a = initArray();
    for(int i = 0; i < 5; i++){
         cout << a[i] << endl;
    }
    return 0;
}
int* initArray(){
    static int a[5] ;
    for(int i = 0; i < 5; i++){
         a[i] = i+100;
    }
    return a;
}

```

```
PS C:\test> ./arrayTest
100
101
102
103
104
```



# 字符串

## C风格字符串

```cpp
char str[] = {'h','e','l','l','o','\0'};
```

与相同:

```cpp
char str[] = "hello";
```

其中 '\0' 为null字符

数组的大小会比字符串长度多一个''\0'

**一些方法**

- strcpy(s1, s2)    复制字符串s2到s1

- strcat(s1, s2)     连接字符串s2到s1的末尾,也可以用+号

  ```cpp
  #include <iostream>
  #include <cstring>
  using namespace std;
  int main(){
      char s1[] = {'h','e','l','l','o','\0'};
      char s2[] = "world";
      cout << "s1 " << s1 << endl;
      cout << "s2 " << s2 << endl;
      strcat(s1,s2);
      cout << "s1 " << s1 << endl;
      cout << "s2 " << s2 << endl;
      return 0;
  }
  ```

  ```
  PS C:\test> ./strTest
  s1 hello
  s2 world
  s1 helloworld
  s2 world
  ```

- strlen(s)    获取字符串长度,不包括null字符

- strcmp(s1, s2)    比较大小, 相等返回0, 1大返回值大于0, 2大返回值小于0

- strch(s1, ch) 返回一个指针,指向**字符**ch第一次在s1中出现的位置

- strstr(s1, s2) 返回一个指针,指向**字符串**s2第一次在s1中出现的位置

  ```cpp
  #include <iostream>
  #include <cstring>
  using namespace std;
  int main(){
      char s1[] = "hello world";
      char s2[] = "world";
      cout << "s1 " << s1 << endl;
      cout << "s2 " << s2 << endl;
      cout << "index " << strstr(s1,"l") << endl;
      return 0;
  }
  ```

  ```
  PS C:\test> ./strTest
  s1 hello world
  s2 world
  index llo world
  ```

## C++字符串类型

```cpp
#include <iostream>
#include <cstring>
using namespace std;
int main(){
    string s1 = "hello";
    string s2 = "world";
    string s3 = s1+s2;
    string s4 = s3;
    cout << s3 << endl;
    cout << s1 << endl;
    cout << s2 << endl; 
    cout << s4 << endl;
    s3+="222222";
    cout << s3 << endl;
    cout << s4 << endl;
    cout << (s4 + s2) .size() << endl;
    return 0;
}
```

其中 s4 = s3 是复制操作,s4 和 s3 完全是两个字符串, 改变其中的一个字符串两一个不会影响. 

\+ 号为连接操作,是一个运算符

\.size()为获取字符串长度的方法

# 指针

指针本身是一个变量,存储一个地址

```cpp
int* a;
int *b;
// 常见形式为b,但个人认为a形式更容易理解
// a是一个int* 类型的变量,也就是说a中存储的是int的地址
// 而*是一个操作符,可以计算一个地址的值,
// 这便是为何 *a 的值可以赋给一个int变量
```

所以初始化时的\*号和取值时的\*号意义不同,一个是类型,一个是运算符

```cpp
#include <iostream>
using namespace std;
int main(){
    int i = 10;
    int* p = &i;
    cout << "指针" << p << endl;
    cout << "指针中的值" << *p << endl;
    return 0;
}
```

## Null指针

建议为没有确切的地址的指针赋值Null,这种指针叫做空指针

```cpp
int* a = NULL;
```

输出空指针的地址为0,但不是内存中实际上0的位置, 

 没有值: *取值运算获取不到东西

可以通过if语句判断某指针是否非空:  NULL为false

```cpp
#include <iostream>
using namespace std;
int main(){
    double* p = NULL;
    if(!p){
        cout << "the pointer point to null " << p << endl;
    }else{
        cout << "the pointer point to something " << p << endl;
        cout << "*p " << *p << endl;

    }
    double a = 1.2;
    p = &a;
    if(!p){
        cout << "the pointer point to null " << p << endl;
    }else{
        cout << "the pointer point to something " << p << endl;
        cout << "*p " << *p << endl;
    }
    return 0;
}
```

```
PS C:\test> ./pointerTest
the pointer point to null 0
the pointer point to something 0x61ff00
*p 1.2
```

## 指针的算术运算

指针可进行四种算术运算 ++ -- + - 

指针每次自增会增加一个当前类型的大小

比如一个存储32位的整型的地址的指针,每次自增会增加32位,也就是四个字节,比如当前p=1000;则 p++ = 1004

```cpp
#include <iostream>
using namespace std;
int main(){
    int a[] = {1,2,3};
    for(int *p = a,i = 0; i < 3; i++ ){
        cout << p << endl;
        cout << *p << endl;
        p++;
    }
    return 0;
}
```

```
PS C:\test> ./pointerTest
0x61fefc
1
0x61ff00    
2
0x61ff04    
3
```

short测试

```
PS C:\test> ./pointerTest
loc 0x61ff02
val 1
loc 0x61ff04
val 2
loc 0x61ff06
val 3
```

long测试

```
PS C:\test> ./pointerTest
loc 0x61fefc
val 1
loc 0x61ff00
val 2
loc 0x61ff04
val 3
```

递减相同

```cpp
#include <iostream>
using namespace std;
int main(){
    long a[] = {1,2,3};
    long *p = &a[3];
    for( int i = 0; i < 3; i++ ){
        cout << "loc " << p << endl;
        cout << "val " << *p << endl;
        p--;
    }
    return 0;
}
```

```
PS C:\test> ./pointerTest
loc 0x61ff08
val 0
loc 0x61ff04
val 3
loc 0x61ff00
val 2
```

对于指针的+1或-1操作同样为增减一个单位,+2就是两个单位,类推

指针可用来进行比较,但只限于同类型指针

## 指针和数组的关系

```cpp
#include <iostream>
using namespace std;
int main()
{
    char a[] = {'a', 'b', 'c', '\0'};
    cout << a << endl;
    *a = '2';
    cout << a << endl;
    *(a+2) = 'd';
    cout << a << endl;
    return 0;
}
```

```
PS C:\test> ./pointerTest
abc
2bc
2bd
```

指向数组的指针a本身不可以被改变

## 指针数组

存储指针的数组

也许会好奇为啥没有存储数组的指针：数组名本身就是指向这个数组的指针

```cpp
#include <iostream>
using namespace std;
const int MAX = 3;
int main(){
    int *loc[MAX];
    int val[MAX] = {1,2,3};
    for(int i = 0; i < MAX; i ++){
        // a的地址都一样
        // int a = i;
        // loc[i] = &a;
        // ==============
        loc[i] = &val[i];
    }
    for(int i = 0 ; i < MAX; i ++){
        cout << loc[i] << endl;
        cout << *loc[i] << endl;
    }
    return 0;
}
```

```
PS E:\test\zm> ./pointTest
0x61fdfc
2
0x61fdfc
2
0x61fdfc
2
=======================
PS E:\test\zm> ./pointTest
0x61fdf4
1
0x61fdf8
2
0x61fdfc
3
```

由于字符串本质是一个数组,故字符串本身是一个地址

```cpp
#include <iostream>
using namespace std;
const int MAX = 3;
int main(){
    char *loc[MAX] = {
        "Hi",
        "nice to meet you",
        "Can I like you?"
    };
    
    for(int i = 0 ; i < MAX; i ++){
        cout << loc[i] << endl;
        // 强转, 不强转cout会直接输出以当前地址开头的字符串
        cout << static_cast<void*> (loc[i]) << endl;
        cout << *loc[i] << endl;
    }
    return 0;
}
```

```
PS E:\test\zm> ./pointTest
Hi
0x404008
H
nice to meet you
0x40400b
n
Can I like you?
0x40401c
C
```

## 指向指针的指针（多级间接寻址）

```cpp
#include <iostream>
using namespace std;
const int MAX = 3;
int main()
{
    int var = 9421;
    int *varL = &var;
    int **varLL = &varL;
    cout << "var " << var << endl;
    cout << "varL " << varL << endl;
    cout << "varLL " << varLL << endl;

    return 0;
}
```

```
PS E:\test\zm> ./pointTest
var 9421
varL 0x61fe14
varLL 0x61fe08
```

## 传递指针给函数

可以直接更改指针所指向变量的值

```cpp
#include <iostream>
#include <ctime>
using namespace std;
void getSeconds(unsigned long*);
int main()
{
    unsigned long sec; 
    cout << sec << endl;
    getSeconds(&sec);
    cout << sec << endl;
    return 0;
}
void getSeconds(unsigned long* var){
    *var = time(NULL);
    return;
}
```

```
PS E:\test\zm> ./pointTest
0
1668922164
```

由于数组名本身就是指针，故可将数组名传入

```cpp
#include <iostream>
using namespace std;
void increament(int *);
void coutArray(int *var);
int main()
{
    int a[] = {1, 2, 3, 4};
    cout << "size:" << sizeof(a) / sizeof(a[0]) << endl;
    coutArray(a);
    increament(a);
    coutArray(a);
    return 0;
}
void increament(int *var)
{
    cout << "size:" << sizeof(var) / sizeof(var[0]) << endl;

    for (int i = 0; i < 4; i++)
    {
        var[i]++;
    }
    return;
}
void coutArray(int *var)
{
    cout << "size:" << sizeof(var) / sizeof(var[0]) << endl;

    for (int i = 0; i < 4; i++)
    {
        cout << i << ":" << var[i] << endl;
    }
    return;
}
```

```
PS E:\test\zm> ./pointTest
size:4
size:2
0:1
1:2
2:3
3:4
size:2
size:2
0:2
1:3
2:4
3:5
```

**这里有个问题是,将数组作为形参传入方法后,虽然可以正确访问,但sizeof会发生变化,传入数组后的的sizeof为指针的大小**

## 从函数返回指针

**C++ 不支持在函数外返回局部变量的地址，除非定义局部变量为 static变量。**

```cpp
#include <iostream>
using namespace std;
int * createArray();
int main()
{
    int * a;
    a = createArray();
    for(int i = 0; i < 5; i ++){
        cout << a[i] << endl;
    }
    return 0;
}
int * createArray()
{
    static int ia[5];
    for(int i = 0; i < 5; i++){
        ia[i] = i;
    } 
    return ia;
}
```

```
PS E:\test\zm> ./pointTest
0
1
2
3
4
```

**静态数组初始化时大小不能传入变量**

# 引用

已经存在的变量的另一个名字

与指针的不同在于：

1. 不存在空引用，引用必须连接到一块合法的内存
2. 一旦引用被初始化为一个对象，就不能被指向到另一个对象，指针可以在任何时候指向另一个对象
3. 引用必须在创建时被初始化，指针可以在任何时间被初始化

```cpp
#include <iostream>
using namespace std;
int main()
{
    int  a = 5;
    int& b = a;
    int c = a;
    cout << "a " << a << endl;
    cout << "b " << b << endl;
    cout << "c " << c << endl;
    a = 6;
    cout << "a " << a << endl;
    cout << "b " << b << endl;
    cout << "c " << c << endl;
    
    return 0;
}

```

```
PS E:\test\zm> ./yinyong
a 5
b 5
c 5
a 6
b 6
c 5
```

可以看出,引用直接相当于原变量, 而等号赋值只是赋值

## 引用当形参

```cpp
#include <iostream>
using namespace std;
void swap(int& a, int&b);
int main()
{
    int a = 5;
    int b = 6;
    cout << "a " << a << endl;
    cout << "b " << b << endl;
    swap(a,b);
    cout << "a " << a << endl;
    cout << "b " << b << endl;
    return 0;
}

void swap(int& a, int&b){
    int temp = a;
    a = b; 
    b = temp;
};
```

```
PS E:\test\zm> ./yinyong
a 5
b 6
a 6
b 5
```

## 引用作为返回值

当一个引用作为返回值的时候,该方法可以在表达式的左边

```cpp
#include <iostream>
using namespace std;
double& returnAs(int i);
double vals[] = {10.1, 12.6, 33.1, 24.1, 50.0};
int main()
{
    returnAs(2) = 3.14;
    cout << vals[2];
    return 0;
}
double& returnAs(int i){
    return vals[i];
};
```

```
PS E:\test\zm> ./yinyong
3.14
```

同样的,返回引用不能返回局部变量的引用,但可返回静态变量

# 日期和时间

ctime 头文件 

获取当前时间:

```cpp
#include <iostream>
#include <ctime>
using namespace std;
int main()
{
    time_t now = time(0);
    // 时间戳
    cout << "now:" << now << endl;
    char *dt = ctime(&now);
    // 转为字符串
    cout << "dt:" << dt << endl;
    cout << "*dt:" << *dt << endl;

    tm *gmtm = gmtime(&now);
    cout << "gmtm:" << gmtm << endl;

    dt = asctime(gmtm);
    cout << "dt:" << dt << endl;
    cout << "*dt:" << *dt << endl;
    return 0;
}
```

```
PS E:\test\zm> ./timeTest 
now:1668939211
dt:Sun Nov 20 18:13:31 2022

*dt:S
gmtm:0x1071aa0
dt:Sun Nov 20 10:13:31 2022

*dt:S
```

# 基本输入输出

## io库头文件

\<iostream\> 定义了cin, cout, cerr, clog, 分别对应于标准输入流,标准输出流,非缓冲标准错误流, 缓冲标准错误流

\<iomanip\> 通过所谓的参数化流操纵器, 比如setw和setprecision, 来声明对执行标准化IO有用的服务

\<fstream\> 该文件为用户控制的文件处理声明服务

## cout

cout连接标准输出设备,通常是显示屏, cout 是与流插入运算符 << 结合使用的

```
  cout << "Value of str is : " << str << endl;
```

C++ 编译器根据要输出变量的数据类型,选择合适的流插入运算符来显示.

<< 运算符被重载来输出内置类型, 如整型,浮点型,doble,字符型和指针等数据项

流插入运算符 << 在一个语句中可以多次使用,endl用于在行末添加一个换行符

## cin

通常与流提取运算符 >> 结合使用

```cpp
#include <iostream>
using namespace std;
int main(){
    cout << "please input context" << endl;
    char context[50];
    cin >> context;
    cout << "context is : " << context;
    return 0;
}
```

C++编译器根据要输入值的数据类型,选择合适的流提取运算符来提取值,并把它存储在给定的变量中,  流提取运算符 >> 在一个语句中可以多次使用,如果要求输入多个数据,可使用如下语句

```cpp
#include <iostream>
using namespace std;
int main(){
    cout << "please input context" << endl;
    char first[50];
    char second[50];
    cin >> first >> second;
    cout << "the first is : " << first;
    cout << "the scend is : " << second;
    return 0;
}
```

```
PS C:\test> ./cinTest
please input context
45
56
the first is : 45the scend is : 56
```

## 标准错误流 cerr

非缓冲的错误流

```cpp
#include <iostream>
using namespace std;
int main(){
    int a = 10;
    cerr << "erroris : " <<  a << endl;
    return 0;
}
```

```
PS C:\test> .\cErrLogTest
erroris : 10
```

## 标准日志流 clog

```cpp
#include <iostream>
using namespace std;
int main(){
    int a = 10;
    clog << "log : " <<  a << endl;
    return 0;
}
```

```
PS C:\test> .\cErrLogTest
log : 10
```

# 数据结构

与数组不同，结构允许存储不同类型的数据项

## 定义结构

```cpp
struct type_name {
member_type1 member_name1;
member_type2 member_name2;
member_type3 member_name3;
.
.
} object_names;
```

```cpp
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
} book;
```

其中具体的结构可以暂时不写

还有一种方法是使用typeof

```cpp
typedef struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
}Books;
```



## 访问结构成员

使用点运算符 "."

```cpp
#include<iostream>
using namespace std;

struct Book
{
    string name;
    string writer;
    double price;

};

int main(){
    Book b1;
    b1.name = "three body";
    b1.writer = "big liu";
    b1.price = 3.14;
    cout << "book_name: " << b1.name << endl;
    cout << "book_writer: " << b1.writer << endl;
    cout << "book_price: " << b1.price << endl;
    return 0;
}
```

```
PS C:\test> ./structTest
book_name: three body
book_writer: big liu
book_price: 3.14
```

## 结构作为参数

注意是 struct Book b1

```cpp
#include<iostream>
using namespace std;

struct Book
{
    string name;
    string writer;
    double price;

};

void soutStruct(struct Book b1);

int main(){
    Book b1;
    b1.name = "three body";
    b1.writer = "big liu";
    b1.price = 3.14;
    soutStruct(b1);
    return 0;
}
void soutStruct(struct Book b1){
    cout << "book_name: " << b1.name << endl;
    cout << "book_writer: " << b1.writer << endl;
    cout << "book_price: " << b1.price << endl;
}
```

## 结构体指针

```cpp
#include<iostream>
using namespace std;

struct Book
{
    string name;
    string writer;
    double price;

};

void soutStruct(struct Book b1);
void setStruct(struct Book* b1);

int main(){
    Book b1;
    setStruct(&b1);
    soutStruct(b1);
    return 0;
}
void soutStruct(struct Book b1){
    cout << "book_name: " << b1.name << endl;
    cout << "book_writer: " << b1.writer << endl;
    cout << "book_price: " << b1.price << endl;
}
void setStruct(struct Book* b1){
    (*b1).name = "three body";
    (*b1).writer = "big liu";
    (*b1).price = 3.14;
}
```

或者 使用 -> 可直接从结构体指针访问属性

```cpp
#include<iostream>
using namespace std;

struct Book
{
    string name;
    string writer;
    double price;

};

void soutStruct(struct Book b1);
void setStruct(struct Book* b1);

int main(){
    Book b1;
    setStruct(&b1);
    soutStruct(b1);
    return 0;
}
void soutStruct(struct Book b1){
    cout << "book_name: " << b1.name << endl;
    cout << "book_writer: " << b1.writer << endl;
    cout << "book_price: " << b1.price << endl;
}
void setStruct(struct Book* b1){
    b1->name = "three body";
    b1->writer = "big liu";
    b1->price = 3.14;
}
```



## 结构体引用

```cpp
#include<iostream>
using namespace std;

struct Book
{
    string name;
    string writer;
    double price;

};

void soutStruct(struct Book b1);
void setStruct(struct Book& b2);

int main(){
    Book b1;
    Book& b2 = b1;
    setStruct(b2);
    soutStruct(b1);
    return 0;
}
void soutStruct(struct Book b1){
    cout << "book_name: " << b1.name << endl;
    cout << "book_writer: " << b1.writer << endl;
    cout << "book_price: " << b1.price << endl;
}
void setStruct(struct Book& b2){
    b2.name = "three body";
    b2.writer = "big liu";
    b2.price = 3.14;
}
```

## typedef

形参可以不再使用 struct Book b1,而是直接 Book b1

```cpp
#include<iostream>
using namespace std;

typedef struct Book
{
    string name;
    string writer;
    double price;

}Book;

void soutStruct(Book b1);
void setStruct(Book* b1);

int main(){
    Book b1;
    setStruct(&b1);
    soutStruct(b1);
    return 0;
}
void soutStruct(Book b1){
    cout << "book_name: " << b1.name << endl;
    cout << "book_writer: " << b1.writer << endl;
    cout << "book_price: " << b1.price << endl;
}
void setStruct(Book* b1){
    b1->name = "three body";
    b1->writer = "big liu";
    b1->price = 3.14;
}
```

# 类&对象

## 定义类

```cpp
class className{
    Access_Specifiers://访问修饰符
    	...// 变量
        ...// 方法
};// 分号结束一个类
```

例如

```cpp
#include<iostream>
using namespace std;
class Book{
    public:
    	string name;
    	double price;
    	string getBookName(){
            return name;
        }
};
int main(){
    Book book;
    book.name = "three body";
    string bn = book.getBookName();
    cout << bn << endl;
    return 0;
}
```

或者这种：

```cpp
#include<iostream>
using namespace std;
class Book{
    public:
    	string name;
    	double price;
    	string getBookName(void);

};
string Book::getBookName(void){
    return name;
}

int main(){
    Book book;
    book.name = "three body";
    string bn = book.getBookName();
    cout << bn << endl;
    return 0;
}
```



## 定义对象

```cpp
Book b1;
Book b2;
```

## 类访问修饰符

当不加任何修饰符时,类成员默认为私有

```cpp
#include<iostream>
using namespace std;
class Book{
    public:
    	string name;
    	double price;
    	string getBookName(void);
        string getDesc(){
            return description;
        }
    private:
        string description = "good book";

};
string Book::getBookName(void){
    return name;
}

int main(){
    Book book;
    book.name = "three body";
    string bn = book.getBookName();
    cout << bn << endl;
    cout << book.description << endl;
    cout << book.getDesc() << endl;
    return 0;
}
```

私有属性不能直接访问,可通过public 的 get方法返回

### 类的三种继承方式影响访问范围

- public 继承

  基类 public 成员，protected 成员，private 成员的访问属性在派生类中分别变成：public, protected, private

- protected 继承

  基类 public 成员，protected 成员，private 成员的访问属性在派生类中分别变成：protected, protected, private

- private 继承

  基类 public 成员，protected 成员，private 成员的访问属性在派生类中分别变成：private, private, private

## 类的构造函数

使用初始化列表来初始化字段

```cpp
Line::Line( double len)
{
    length = len;
    cout << "Object is being created, length = " << len << endl;
}
```

等同于

```cpp
Line::Line( double len): length(len)
{
    cout << "Object is being created, length = " << len << endl;
}
```

拓展

```cpp
C::C( double a, double b, double c): X(a), Y(b), Z(c)
{
  ....
}
```



## 析构函数

析构函数会在每次删除所创建的对象时执行

析构函数也是以类名作为方法名，只是带有波浪号前缀，不会返回任何值，也不能带有仍和参数，析构函数有助于在跳出程序前释放资源，

```cpp
class Line
{
   public:
      Line();   // 这是构造函数声明
      ~Line();  // 这是析构函数声明
};
```

## 拷贝构造函数

一种特殊的构造函数,在创建对象时,使用同一类之前创建的对象来初始化新的对象. 

如果类中没有定义拷贝构造函数,系统会自行定义一个,如果带有指针变量,并且有动态内存分配,则必须有一个拷贝构造函数

```cpp
classname (const classname &obj) {
   // 构造函数的主体
}
```

```cpp
#include <iostream>

using namespace std;
 
class Book{
    public:
        Book(string name){
            cout << "constur: " << name << endl;
        }
        ~Book(){
            cout << "distroy" << endl;
        }
        Book(const Book& book){
            cout << "copy" << endl;
        }
        void speck(){
            cout << "i'm a book" << endl;
        }
};
void needSpeck(Book b){
    b.speck();
    cout << "needSpeck b" << &b << endl;
}
int main(){
    Book b("three body");
    cout << "main b" << &b << endl;
    // Book b2 = b;
    needSpeck(b);
    return 0;
}
```

```
PS E:\test\zm> ./a
constur: three body
main b0x61fddf
copy
i'm a book
needSpeck b0x61fe0f
distroy
distroy
```

说明在传给一个函数一个对象时,会调用拷贝构造函数构造一个新的对象

## 友元函数

友元函数不是成员函数，但可以访问类的任何成员

```cpp
#include <iostream>

using namespace std;
 
class Book{
    int pages;
    public:
        Book(string name){
            cout << "constur: " << name << endl;
        }
        friend void soutPages(Book b);
};
void soutPages(Book b){
            cout << b.pages << endl;
        }
int main(){
    Book b("three body");
    
    soutPages(b);           
    return 0;
}
```

## 内联函数，不明，有机会补充

```cpp
#include <iostream>
 
using namespace std;

inline int Max(int x, int y)
{
   return (x > y)? x : y;
}

// 程序的主函数
int main( )
{

   cout << "Max (20,10): " << Max(20,10) << endl;
   cout << "Max (0,200): " << Max(0,200) << endl;
   cout << "Max (100,1010): " << Max(100,1010) << endl;
   return 0;
}
```

- 只有当函数只有 10 行甚至更少时才将其定义为内联函数.
- 在内联函数内不允许使用循环语句和开关语句.
- 内联函数的定义必须出现在内联函数第一次调用之前.

## this指针

友元函数没有this指针

```cpp
#include <iostream>

using namespace std;
 
class Book{
    int pages = 10;
    public:
        Book(string name){
            cout << "constur: " << name << endl;
        }
        void read(){
            cout << this->pages << endl;
        }
};

int main(){
    Book b("three body");
    b.read();         
    return 0;
}

```

```cpp
PS E:\test\zm> ./a
constur: three body
10
```

## 指向类的指针

```cpp
#include <iostream>

using namespace std;
 
class Book{
    int pages = 10;
    public:
        string name;
        Book(string name){
            cout << "constur: " << name << endl;
            this->name = name;
        }
        void read(){
            cout << this->pages << endl;
        }
};

int main(){
    Book b("three body");
    b.read();
    Book* bp = &b;    
    cout << bp->name << endl;    
    return 0;
}
```

```
PS E:\test\zm> ./a
constur: three body
10
three body
```

## 静态变量

静态成员的初始化只能放在类外使用范围解析运算符::来重新声明并对其进行初始化



```cpp
#include <iostream>

using namespace std;
class Book
{

    int pages = 10;

    public:
        static int bookNum;
        string name;
        Book(string name)
        {
            cout << "constur: " << name << endl;
            this->name = name;
            bookNum++;
        }
        void read()
        {
            cout << this->pages << endl;
        }
};
// 注意初始化
int Book::bookNum = 0;
int main()
{
    Book b("three body");
    Book b2("two body");
    cout << Book::bookNum<<endl;
    return 0;
}
```

## 静态函数

- 静态函数没有this指针
- 只能访问静态变量和静态函数

```cpp
#include <iostream>

using namespace std;
class Book
{

public:
    string name;
    Book(string name)
    {
        cout << "constur: " << name << endl;
        this->name = name;
    }

    static void ifGood()
    {
        cout << "yes, it is Good" << endl;
    }
};

int main()
{

    Book::ifGood();
    return 0;
}
```

```
PS E:\test\zm> ./a
yes, it is Good
```

# 继承

```cpp
// 基类
class Animal {
    // eat() 函数
    // sleep() 函数
};


//派生类
class Dog : public Animal {
    // bark() 函数
};
```

## 基类&派生类

一个类可以派生自多个类:多继承

派生类可以访问基类中的所有非私有成员

一个派生类继承了所有的基类方法，但下列情况除外：

- 基类的构造函数、析构函数和拷贝构造函数。
- 基类的重载运算符。
- 基类的友元函数。

```cpp
#include<iostream>
using namespace std;
class Animal{
    public:
        void brith(){
            cout << "birth in --- birth out ---" << endl;
        }
};
class Human{
    public:
        void speak(){
            cout << "speak something" << endl;
        }
};
class Teacher: public Animal,public Human{

};
int main(){
    Teacher t;
    t.brith();
    t.speak();
    return 0;
}
```

```cpp
#include<iostream>
using namespace std;
class Animal{
    public:
        void brith(){
            cout << "birth in --- birth out ---" << endl;
        }
};
class Human: public Animal{
    public:
        void speak(){
            cout << "speak something" << endl;
        }
};

class Man:public Human{
    public:
        void goToWC(){
            cout << "i want to go to the man WC" << endl;
        }
};
class Teacher: public Man{

};
int main(){
    Teacher t;
    t.brith();
    t.speak();
    t.goToWC();
    return 0;
}
```

## 继承类型

public, protected, private

## 继承构造方法

```cpp
#include<iostream>
using namespace std;
class Number{
    public:
        int value;
        Number(int value){
            this->value = value;
        }
};
class Integer:public Number{
    public:
        Integer operator + (const Integer& i){
            Integer ii(0);
            ii.value = this->value+i.value;
            return ii;
        }
        Integer(int value):Number(value){}
};
int main(){
    Integer i1(5);
    Integer i2(6);
    Integer i3 = i1+i2;
    cout << i1.value << endl;
    cout << i3.value << endl;
    return 0;
}
```



# 重载运算符和重载函数

## 函数重载

```cpp
#include <iostream>
using namespace std;
 
class printData
{
   public:
      void print(int i) {
        cout << "整数为: " << i << endl;
      }
 
      void print(double  f) {
        cout << "浮点数为: " << f << endl;
      }
 
      void print(char c[]) {
        cout << "字符串为: " << c << endl;
      }
};
 
int main(void)
{
   printData pd;
 
   // 输出整数
   pd.print(5);
   // 输出浮点数
   pd.print(500.263);
   // 输出字符串
   char c[] = "Hello C++";
   pd.print(c);
 
   return 0;
}
```

## 运算符重载

```cpp
#include<iostream>
using namespace std;
class Integer{
    public:
        int value;
        Integer operator + (const Integer& i){
            Integer ii(0);
            ii.value = this->value+i.value;
            return ii;
        }
        Integer(int value){
            this->value = value;
        }
};
int main(){
    Integer i1(5);
    Integer i2(6);
    Integer i3 = i1+i2;
    cout << i3.value << endl;
    return 0;
}
```

```
PS C:\test\c++> .\ClassTest
11
```

## 可重载运算符/不可重载运算符

下面是可重载的运算符列表：

| 双目算术运算符 | + (加)，-(减)，*(乘)，/(除)，% (取模)                        |
| -------------- | ------------------------------------------------------------ |
| 关系运算符     | ==(等于)，!= (不等于)，< (小于)，> (大于)，<=(小于等于)，>=(大于等于) |
| 逻辑运算符     | \|\|(逻辑或)，&&(逻辑与)，!(逻辑非)                          |
| 单目运算符     | + (正)，-(负)，*(指针)，&(取地址)                            |
| 自增自减运算符 | ++(自增)，--(自减)                                           |
| 位运算符       | \| (按位或)，& (按位与)，~(按位取反)，^(按位异或),，<< (左移)，>>(右移) |
| 赋值运算符     | =, +=, -=, *=, /= , % = , &=, \|=, ^=, <<=, >>=              |
| 空间申请与释放 | new, delete, new[ ] , delete[]                               |
| 其他运算符     | **()**(函数调用)，**->**(成员访问)，**,**(逗号)，**[]**(下标) |

下面是不可重载的运算符列表：

- **.**：成员访问运算符
- **.\***, **->\***：成员指针访问运算符
- **::**：域运算符
- **sizeof**：长度运算符
- **?:**：条件运算符
- **#**： 预处理符号

# 多态

了解一下静态多态/静态链接： 编译器调用方法时会调用基类的方法，也就是说，函数调用在程序执行之前就准备好了，这被称为早绑定。我们需要virtual关键字来表明需要动态链接的方法。此时,编译器看的是指针的内容,而不是它的类型.

```cpp
#include <iostream>
using namespace std;
class Human
{
    public:
        string s = "human";
        virtual void speak(){
            cout << s << "aba aba" << endl;
        };
};
class Man : public Human
{
    public:
    string s = "man";
        void speak()
        {
            cout << s << "i am a man" << endl;
        }
};
class Woman : public Human
{
    public:
    string s = "woman";
        void speak()
        {
            cout << s << "i am a woman" << endl;
        }
};
int main()
{
    Human *h = NULL;
    Human human;
    h = &human;
    h->speak();
    Man m;
    Woman wm;
    h = &m;
    h->speak();
    h = &wm;
    h->speak();
    return 0;
}
```

```
PS C:\test\c++> ./Polym                       
humanaba aba
mani am a man
womani am a woman
```

## 虚函数

像上面一样, 带有virtual声明的函数,叫做虚函数, 编译器不会静态链接该函数, 与静态链接相反的是动态链接, 或者叫后期绑定.

## 纯虚函数

virtual void speak() = 0;

必须带有 = 0; 告诉编译器为纯虚函数

```cpp
#include <iostream>
using namespace std;
class Human
{
    public:
        string s = "human";
        virtual void speak() = 0;
};
class Man : public Human
{
    public:
    string s = "man";
        void speak()
        {
            cout << s << "i am a man" << endl;
        }
};
class Woman : public Human
{
    public:
    string s = "woman";
        void speak()
        {
            cout << s << "i am a woman" << endl;
        }
};
int main()
{
    Human *h = NULL;
    Man m;
    Woman wm;
    h = &m;
    h->speak();
    h = &wm;
    h->speak();
    return 0;
}
```

含有纯虚函数的类不能实例化

# 数据抽象

# 数据封装

隐藏具体实现细节--私有, 只暴露接口--public

# 接口/抽象类

c++ 使用抽象类来实现接口

只要有一个函数是虚函数,该类就是抽象类/接口, 无法进行实例化,只能被继承

一个派生类,如果其非抽象类,则必须实现其基类的抽象方法,若不实现,则编译器认为其为抽象类

```cpp
#include <iostream>
using namespace std;
class Animal{
    public:
    virtual void birth() = 0;
};
class Human : public Animal
{
    public:
        string s = "human";
        virtual void speak() = 0;
};
class Woman : public Human
{
    public:
    string s = "woman";
        void speak()
        {
            cout << s << "i am a woman" << endl;
        }
        void birth(){
            cout << s << " is birthing" << endl;
        }
};
int main()
{
    Human *h = NULL;
    Woman wm;
    h = &wm;
    h->speak();
    h->birth();
    return 0;
}
```

```
PS C:\test\c++> ./Polym                       
womani am a woman
woman is birthing
```

实例化抽象类

```
Polym.cpp:28:11: error: cannot declare variable 'wm' to be of abstract type 'Woman'
   28 |     Woman wm;
      |           ^~
Polym.cpp:13:7: note:   because the following 
virtual functions are pure within 'Woman':    
   13 | class Woman : public Human
      |       ^~~~~
Polym.cpp:5:18: note:   'virtual void Animal::birth()'
    5 |     virtual void birth() = 0;
      |                  ^~~~~
Polym.cpp:31:14: error: 'virtual void Animal::birth()' is private within this context       
   31 |     h->birth();
      |              ^
Polym.cpp:5:18: note: declared private here   
    5 |     virtual void birth() = 0;
      |   
```

# 文件和流

标准库 **fstream**

## 数据类型

| 数据类型 | 描述                                        |
| -------- | ------------------------------------------- |
| ofstream | 输出文件了,用于创建文件和向文件             |
| ifstream | 该数据类型表示输入文件流,用于从文件读取信息 |
| fstream  | 拥有以上两种功能                            |

## 打开文件

open函数, 三对象都有

```cpp
void open(const char *filename, ios::openmode mode);
```

| 模式标志   | 描述                                                         |
| :--------- | :----------------------------------------------------------- |
| ios::app   | 追加模式。所有写入都追加到文件末尾。                         |
| ios::ate   | 文件打开后定位到文件末尾。                                   |
| ios::in    | 打开文件用于读取。                                           |
| ios::out   | 打开文件用于写入。                                           |
| ios::trunc | 如果该文件已经存在，其内容将在打开文件之前被截断，即把文件长度设为 0。类似覆盖? |

其中, 模式可以结合使用

如想要对某文件进行覆盖:

```cpp
ofstream outfile;
outfile.open("file.dat", ios::out | ios::trunc );
```

对某文件进行读写

```cpp
ifstream  afile;
afile.open("file.dat", ios::out | ios::in );
```

## 关闭文件

close函数, 三对象都有

```cpp
void close()
```

## 写入与读取

分别使用流插入运算符<< 和流提取运算符>>

```cpp
#include <iostream>
#include <fstream>
using namespace std;
int main()
{
    string s;
    ofstream outToFile;
    outToFile.open("qsConfig", ios::app);
    // outToFile << "\naaaaa" << endl;
    outToFile.close();

    ifstream readFile;
    readFile.open("qsConfig", ios::in);

    cout << "----------------" << endl;
    for (int i = 0; i < 5; i++)
    {
        readFile >> s;
        cout << s << endl;
    }

    cout << "----------------" << endl;
    return 0;
}
```

```
PS C:\test\c++\fileTest> .\fileTest
----------------
aName,aFile,aLocation
bName,bFile,bLocation
bName,bFile,bLocation
bName,bFile,bLocation
bName,bFile,bLocation
----------------
```

## 文件位置指针

**istream** 和 **ostream** 都提供了用于重新定位文件位置指针的成员函数。这些成员函数包括关于 istream 的 **seekg**（"seek get"）和关于 ostream 的 **seekp**（"seek put"）。

seekg 和 seekp 的参数通常是一个长整型。第二个参数可以用于指定查找方向。查找方向可以是 **ios::beg**（默认的，从流的开头开始定位），也可以是 **ios::cur**（从流的当前位置开始定位），也可以是 **ios::end**（从流的末尾开始定位）。

```cpp
// 定位到 fileObject 的第 n 个字节（假设是 ios::beg）
fileObject.seekg( n );
 
// 把文件的读指针从 fileObject 当前位置向后移 n 个字节
fileObject.seekg( n, ios::cur );
 
// 把文件的读指针从 fileObject 如果n为负数就是倒着取指针
fileObject.seekg( n, ios::end );
 
// 定位到 fileObject 的末尾
fileObject.seekg( 0, ios::end );
```

其中n可以为负数

# 异常处理

```cpp
try
{
   // 保护代码
}catch( ExceptionName e1 )
{
   // catch 块
}catch( ExceptionName e2 )
{
   // catch 块
}catch( ExceptionName eN )
{
   // catch 块
}
```

## 抛出异常

throw 语句的操作数可以是任意的表达式，表达式的结果的类型决定了抛出的异常的类型。

```cpp
double division(int a, int b)
{
   if( b == 0 )
   {
      throw "Division by zero condition!";
   }
   return (a/b);
}
```

## 捕获异常

```cpp
try
{
   // 保护代码
}catch( ExceptionName e )
{
  // 处理 ExceptionName 异常的代码
}
```

捕获任意异常

```cpp
try
{
   // 保护代码
}catch(...)
{
  // 能处理任何异常的代码
}
```

一个除零异常示例

```cpp
#include <iostream>
using namespace std;
double division(int a, int b);
int main(){
    int x = 50;
    int y = 0;
    double z = 0;
    try{
        z = division(x,y);
        cout << z << endl;
    }catch(const char* msg){
        cerr << msg << endl;
    }
    return 0;
}
double division(int a, int b){
    if(b==0){
        throw "division by zero exception";
    }
    return a/b;
}
```

## 自定义异常

**what()** 是异常类提供的一个公共方法，它已被所有子异常类重载。这将返回异常产生的原因。

```cpp
#include <iostream>
#include <exception>
using namespace std;
 
struct MyException : public exception
{
  const char * what () const throw ()
  {
    return "C++ Exception";
  }
};
 
int main()
{
  try
  {
    throw MyException();
  }
  catch(MyException& e)
  {
    std::cout << "MyException caught" << std::endl;
    std::cout << e.what() << std::endl;
  }
  catch(std::exception& e)
  {
    //其他的错误
  }
}
```



指针练习

```cpp
#include <iostream>
using namespace std;
class MyException : public exception
{
public:
    MyException(string msg, int code) : msg(msg), code(code) {}
    string msg;
    int code;
};
int main()
{

    try
    {
        MyException e("something is wrong", 404);

        throw &e;
    }
    catch (MyException *e)
    {
        cerr << e->code << endl;
        cerr << e->msg << endl;
    }
    return 0;
}

```

正常人做法

```cpp
#include <iostream>
using namespace std;
class MyException : public exception
{
public:
    MyException(string msg, int code) : msg(msg), code(code) {}
    string msg;
    int code;
};
int main()
{

    try
    {
        throw MyException("something is wrong", 404);
    }
    catch (MyException e)
    {
        cerr << e.code << endl;
        cerr << e.msg << endl;
    }
    return 0;
}

```

```
PS C:\test\c++> .\ExceptionTest
404
something is wrong
```

# 动态内存

c++程序中内存分为两个部分

- 栈: 在函数内部声明的所有变量都占用栈内存
- 堆: 程序中未使用的内存,在程序运行时可用于动态分配内存

new运算符, 可在运行时为给定变量分配堆内的内存,返回所分配的空间地址.

delete 运算符,删除new运算符分配的内存.

```cpp
double* pvalue  = NULL; // 初始化为 null 的指针
pvalue  = new double;   // 为变量请求内存
```

如果自由存储区已被用完，可能无法成功分配内存。所以建议检查 new 运算符是否返回 NULL 指针，并采取以下适当的操作：

```cpp
double* pvalue  = NULL;
if( !(pvalue  = new double ))
{
   cout << "Error: out of memory." <<endl;
   exit(1);
 
}
```

malloc() 函数,c语言中的动态分配函数,new 关键字与其相比不但分配内存,还创建了对象

```cpp
#include<iostream>
using namespace std;
int main(){
    int *a = NULL;
    a = new int;
    *a = 10;
    cout << a << endl;
    cout << *a << endl;
    delete a;
    cout << a << endl;
    cout << *a << endl;
    return 0;
}
```

```
PS C:\test\c++> .\DynamicMemary           
0x777f98
10
0x777f98
7831480
```

## 数组的动态内存分配

```cpp
#include<iostream>
using namespace std;
int main(){
    int ***a = NULL; // a[5][3][3]
    a = new int**[5];
    for(int i = 0; i < 5; i ++){
        a[i] = new int *[3];
        for(int j = 0; j < 3; j ++){
            a[i][j] = new int[3];
        }
    }
    
    return 0;
}
```

## 对象的动态分配

```cpp
#include<iostream>
using namespace std;
class Book{
    public : 
    int price = 100;
};
int main(){
    // new 是分配内存，返回的是内存地址
    Book* b = new Book();
    cout << b->price << endl;
    Book b2 = *new Book();
    cout << b2.price << endl;

    return 0;
}
```

# 命名空间

## 定义命名空间

```cpp
#include<iostream>
using namespace std;
namespace first_space
{
    void func(){
        cout << "first_namespace" << endl;
    }
}
namespace second_space
{
    void func(){
        cout << "second_namespace" << endl;
    }
}
int main(){
    first_space::func();
    return 0;
}
```

## using

告诉编译器,后续代码使用哪个命名空间

但是没有替换作用,否则会报多个重载错误

```cpp
int main(){
    using namespace first_space;
    func();
    // 错误用法
    using namespace second_space;
    func();
    return 0;
}
```

```
PS C:\test\c++> g++ .\namespaceTest.cpp -onamespaceTest
.\namespaceTest.cpp: In function 'int main()':.\namespaceTest.cpp:19:10: error: call of overloaded 'func()' is ambiguous
   19 |     func();
      |          ^
.\namespaceTest.cpp:11:10: note: candidate: 'void second_space::func()'
   11 |     void func(){
      |          ^~~~
.\namespaceTest.cpp:5:10: note: candidate: 'void first_space::func()'
    5 |     void func(){
      |          ^~~~
```

可以单独引用

```cpp
#include<iostream>
using std::cout;

int main(){
    cout << "a" <<std::endl;
    return 0;
}
```

**using** 指令引入的名称遵循正常的范围规则。名称从使用 **using** 指令开始是可见的，直到该范围结束。此时，在范围以外定义的同名实体是隐藏的。

```cpp
#include<iostream>
void judge(){
    // 这里的cout是爆红的
    cout << "yes" << endl;
}
int main(){
    using namespace std;
    cout << "a" << endl;
    judge();
    return 0;
}
```

## 不连续的命名空间

## 嵌套的命名空间

```cpp
namespace namespace_name1 {
   // 代码声明
   namespace namespace_name2 {
      // 代码声明
   }
}

// 访问 namespace_name2 中的成员
using namespace namespace_name1::namespace_name2;
// 访问 namespace_name1 中的成员
using namespace namespace_name1;
```

在上面的语句中，如果使用的是 namespace_name1，那么在该范围内 namespace_name2 中的元素也是可用的

# 模板/泛型

## 函数模板

```cpp
#include <iostream>
using namespace std;
template<typename T>
T maxType(T x, T y){
    return x>y?x:y;
}
int main(){
    cout << maxType(1,2) << endl;
    cout << maxType(1.1,1.2) << endl;
    return 0;
}
```

```cpp
#include <iostream>
using namespace std;

class MaxUtil{
    public:
    template<typename T>
    static T maxType (T x, T y){
        return x>y?x:y;
        }
};
int main(){
    
    cout << MaxUtil::maxType(1,2) << endl;
    cout <<  MaxUtil::maxType(1.1,1.2) << endl;
    return 0;
}
```



## 类模板

```cpp
#include <iostream>
#include <vector>
using namespace std;

template <class T>
class Stack
{
private:
    vector<T> elems;

public:
    void push(T const &elem)
    {
        // 追加传入元素的副本
        elems.push_back(elem);
    };
    T pop()
    {
        if (elems.empty())
        {
            return NULL;
        }
        else
        {
            T t = elems.back();
            elems.pop_back();
            return t;
        }
    }
    T top() const
    {
        if (elems.empty())
        {
            return NULL;
        }
        else
        {
            return elems.back();
        }
    }
    bool empty() const
    {
        return elems.empty();
    }
};
int main()
{
    Stack<int> stack;
    stack.push(1);
    stack.push(3);
    stack.push(5);
    cout << stack.top() << endl;
    cout << stack.pop() << endl;
    cout << stack.pop() << endl;
    cout << stack.pop() << endl;
    cout << stack.pop() << endl;
    cout << stack.pop() << endl;
    return 0;
}
```

# 预处理

## #define

### 宏定义

```cpp
#include <iostream>
using namespace std;
#define MIN(a,b)(a<b?a:b)
int main(){
    cout << MIN(1,2) << endl;
    return 0;
}
```

### 条件编译

```cpp
#ifdef NULL
   #define NULL 0
#endif

#ifdef DEBUG
   cerr <<"Variable x = " << x << endl;
#endif

#if 0
   不进行编译的代码
#endif
```

```cpp
#include <iostream>
using namespace std;
#define DEBUG
#define MIN(a,b)(a<b?a:b)
int main(){
    #ifdef DEBUG
    cout << MIN(1,2) << endl;
    #endif
    #if 0
    cout << "nothing" << endl;
    #endif
    
    return 0;
}
```

```
PS C:\test\c++> .\preDefineTest
1
```

## # 和 ##

\# 运算符会把 replacement-text 令牌转换为用引号引起来的字符串。

```cpp
#include <iostream>
using namespace std;
 
#define MKSTR( x ) #x
 
int main ()
{
    cout << MKSTR(HELLO C++) << endl;
 
    return 0;
}
```

```
HELLO C++
```

\## 运算符用于连接两个令牌。

```cpp
#include <iostream>
using namespace std;
 
#define concat(a, b) a ## b
int main()
{
   int xy = 100;
   
   cout << concat(x, y);
   return 0;
}
```

```
100
```

## C++ 中的预定义宏

C++ 提供了下表所示的一些预定义宏：

| 宏       | 描述                                                         |
| :------- | :----------------------------------------------------------- |
| __LINE__ | 这会在程序编译时包含当前行号。                               |
| __FILE__ | 这会在程序编译时包含当前文件名。                             |
| __DATE__ | 这会包含一个形式为 month/day/year 的字符串，它表示把源文件转换为目标代码的日期。 |
| __TIME__ | 这会包含一个形式为 hour:minute:second 的字符串，它表示程序被编译的时间。 |

# 信号

信号是中断,有些信号可以被程序捕获

| 信号    | 描述                                         |
| :------ | :------------------------------------------- |
| SIGABRT | 程序的异常终止，如调用 **abort**。           |
| SIGFPE  | 错误的算术运算，比如除以零或导致溢出的操作。 |
| SIGILL  | 检测非法指令。                               |
| SIGINT  | 程序终止(interrupt)信号。                    |
| SIGSEGV | 非法访问内存。                               |
| SIGTERM | 发送到程序的终止请求。                       |

## signal 注册处理器

```cpp

#include <iostream>
#include <csignal>
#include <unistd.h>
 
using namespace std;
 
void signalHandler( int signum )
{
    cout << "Interrupt signal (" << signum << ") received.\n";
 
    // 清理并关闭
    // 终止程序  
 
   exit(signum);  
 
}
 
int main ()
{
    // 注册信号 SIGINT 和信号处理程序
    signal(SIGINT, signalHandler);  
 
    while(1){
       cout << "Going to sleep...." << endl;
       sleep(1);
    }
 
    return 0;
}
```

## raise 生成信号

```cpp
#include <iostream>
#include <csignal>
#include <unistd.h>
 
using namespace std;
 
void signalHandler( int signum )
{
    cout << "Interrupt signal (" << signum << ") received.\n";
 
    // 清理并关闭
    // 终止程序 
 
   exit(signum);  
 
}
 
int main ()
{
    int i = 0;
    // 注册信号 SIGINT 和信号处理程序
    signal(SIGINT, signalHandler);  
 
    while(++i){
       cout << "Going to sleep...." << endl;
       if( i == 3 ){
          raise( SIGINT);
       }
       sleep(1);
    }
 
    return 0;
}
```

```
PS C:\test\c++> .\signTest
Going to sleep....
Going to sleep....
Going to sleep....
Interrupt signal (2) received.
```

# 多线程

# WEB编程

# STL标准模板库

| 组件                | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| 容器（Containers）  | 容器是用来管理某一类对象的集合。C++ 提供了各种不同类型的容器，比如 deque、list、vector、map 等。 |
| 算法（Algorithms）  | 算法作用于容器。它们提供了执行各种操作的方式，包括对容器内容执行初始化、排序、搜索和转换等操作。 |
| 迭代器（iterators） | 迭代器用于遍历对象集合的元素。这些集合可能是容器，也可能是容器的子集。 |

## 容器

```cpp
#include <iostream>
#include <vector>
using namespace std;
int main()
{
    vector<string *> vec;
    int i;
    cout << vec.size() << endl;
    string a[] = {"aname", "aLoc"};
    string b[] = {"bname", "bLoc"};
    string c[] = {"cname", "cLoc"};
    vec.push_back(a);
    vec.push_back(b);
    vec.push_back(c);
    cout << vec.size() << endl;

    vector<string*>::iterator it = vec.begin();
    while (it != vec.end())
    {
        string *arr = *it;
        for (int j = 0; j < 2; j++)
        {
            cout << arr[j] << endl;
        }
        it++;
    }
    return 0;
}
```

