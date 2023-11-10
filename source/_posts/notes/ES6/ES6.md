---
title: ES6
date: 2023-11-09 19:07:19
tags:
  - ES6
categories:
  - 笔记
---

# 介绍

ES就是JS的原名，ES6发布于2015年

# let

let与var的差别

- let不能重复声明

    ```js
    // var
    var j = 10;
    var j = 20;
    // let
    let i = 10;
    // 下面这句代码是非法的，报错i已被声明，
    let i = 20;
    // let之前如果是var先声明，则第一次let可以将其覆盖
    // var之前如果let已经声明，则会报错
    ```

- let有块级作用域，即使是非函数的花括号范围，使用let在其中定义的变量也只能在其中访问

    ```js
    {
        var ii = 19;
        let ik = 10;
    }
    console.log(ii);
    // 报错ik未定义
    console.log(ik);
    ```

- let不会预解析进行变量提升

    没有声明之前先访问，var会将改变量赋值为undefind，let会报错（not defind）

- let定义的全局变量不会作为window的属性

    var 一个变量的时候，改变量会变为window对象的属性

- let在es6中推荐使用

# const

特性与let相同，除此以外

- 定义出的变量为常量
- 必须在声明时赋值

# 模板字符串

解决换行和字符串拼接复杂问题

- 以 `` 号包裹
- 可通过${}填入变量
- 注意变量需要在模板字符串之前定义并赋值，且模板字符串之后再去更改变量，模板字符串的内容并不会更新

```js
let you = "ES6";
let a = 
`你好
    ${you}`
console.log(a)
```

> 你好
>     ES6

# 解构表达式

## 解构数组

```js
let arr = [11, 12, 13, 14, 15];
// 其中，c和f都定义了默认值，但是c可以从arr中找到13来赋值，
// f由于没有匹配的值所以会使用默认值16
// g由于没有给默认值且找不到对应的值，其值最终为undefind
let [a, b, c=4, d, e, f=16, g] = arr; 
```

## 解构对象

需要解构变量名与对象中的属性名一致

```js
let person = {
    name:"zhangsan",
    age:15
}
let {name, age} = person;
```

## 形参解构

```js
let arr = [1,2,3,4];
function arrjg([a,b,c,d,e=10]){
    console.log(a,b,c,d,e);
}
// 1 2 3 4 10
arrjg(arr);
```

```js
let person = {
    name:"zhangsan",
    age:15
}
function objectjg({name,age}){
    console.log(name,age);
}
// zhangsan 15
objectjg(person);
```

# 箭头函数

与java中lambda几乎相同

```js
let fun1 = function(){};
let fun2 = ()=>{};
let fun3 = (x,y) => x+y;
let fun4 = x => console.log(x);
```

## this问题

```js
let person = {
    name: "张三",
    f1:function(){
        console.log(name);
    },
    f2:function(){
        console.log(this.name);
    },
    f3:()=>{
        console.log(name);
    },
    f4:()=>{
        console.log(this.name);
    }
}
// 除f2可输出张三，其余都输出了空
// 1和3是因为方法中直接获取到的只能是参数列表中的值理解
// 4是因为箭头函数没有自己的this
person.f1();person.f2();person.f3();person.f4();
```

箭头函数的this是其外层所处的上下文的环境中的this，如上案例中，箭头函数中的this并不是person的this，因为person只是其外层，箭头函数中的this还需要往外找person所处的上下文。

在实际测试中，在对象里包着的lambda的this都是window ，在方法中嵌套的普通方法的this为window，在方法中嵌套的箭头函数满足以上规则。

由于this传递，甚至可以一直用箭头函数嵌套传递

```js
let person = {
    name: "张三",
        f3:function(){
            let f4 = ()=>{
                let f4 = ()=>{
                    let f4 = ()=>{
                        console.log(this.name);
                    };
                    f4();
                };
                f4();
            };
            f4();
        }, 
}
person.f3();
```

# rest

**相当于Java中的可变参数**

由于参数长度不定，可变参只能有一个且必须在最后一位

```js
let f = (a,b,c,...d)=>{
    console.log(a,b,c,d);
}
// 1 2 3 (5) [4, 5, 6, 7, 8]
f(1,2,3,4,5,6,7,8);
```

# spread

**相当于实参用rest**

就是把数组拆开后放到了参数列表中

```js
let f = (a,b,c)=>{
    console.log(a,b,c);
}
let arr = [1,2,3,4];
// 1 2 3
f(...arr);
let f = (a,b,c)=>{
    console.log(a,b,c);
}
let arr = [1,2,3,4];
// 6 1 2
f(6,...arr);
```

**spread用来合并数组**

```js
let arr1 = [1,2,3];
let arr2 = [4,5,6];
let arr3 = [0,...arr1,3.5,...arr2,7];
// (9) [0, 1, 2, 3, 3.5, 4, 5, 6, 7]
console.log(arr3)
```

**spread用于合并对象**

```js
let name={name:"张三"};
let age={age:10};
let gender={gender:"boy"};
let person = {...name,...age,...gender};
// {name: '张三', age: 10, gender: 'boy'}
console.log(person);
```

# 面向对象的语法糖

## 类的定义

```js
class Person{
    // 定义成员变量
    name;
    age;
    // 实例方法
    eat(food){
        // 注意这里必须是this.才能取到值
        console.log(`${this.age}岁的${this.name}在吃${food}`)
    }
    // 静态方法
    static add(a,b){
        console.log(a+b);
    }
}
```

## 创建实例

```js
let p = new Person()
```

## 给对象的属性赋值

```js
p.name="张三";
p.age=15;
```

## 调用实例方法

```js
p.eat("apple")
```

## 调用静态方法

注意无法从类的实例上调用静态方法

```js
Person.add(1,2)
```

## get和set方法

get/set + 空格 + 属性名

```js
class Person{
    // 定义成员变量
    name;
    // get & set
    get name(){
        console.log("get Name");
        return this.name;
    }
    set name(name){
        console.log("set Name");
        this.name = name;
    }
}
```

但是在外部向对象取值或者赋值时，不会通过get或者set方法，而是会直接向属性赋值。get与set方法的触发条件为真实属性名与get后的属性名不同：

```js
class Person{
    // 定义成员变量
    n;
    // get & set
    get name(){
        console.log("get Name");
        return this.n;
    }
    set name(name){
        console.log("set Name");
        this.n = name;
    }
}
```

使用：

```js
let p = new Person();
// 这样方会经过get和set方法
p.name = "jack";
console.log(p.name);
```

虽然看似是在操作属性，但实际是在操作get与set方法：

在操作某个对象的属性时，首先拿着该属性名去对象中寻找是否有该属性，若有，则尝试直接操作属性，若没有，则寻找是否有对应的get&set方法。

## private属性

```js
class Person{
    // 定义成员变量
    #n;
    // get & set
    get name(){
        console.log("get Name");
        return this.#n;
    }
    set name(name){
        console.log("set Name");
        this.#n = name;
    }
}

let p = new Person()
// 不允许的操作
p.#n = "张三"
// 只能通过set方法
p.name = "张三"
```

在es6中，属性名以#开头的属性为私有属性

在实际测试中，发现edge浏览器可以直接赋值，但是firefox会报错

## 构造器

方法名命名为constructor即可

```js
class Person{
    // 定义成员变量
    name;
    age;
    constructor(name, age){
        this.name = name;
        this.age = age;
    }
}
let p = new Person("张三",15)
```

## 继承

```js
class Person{
    // 定义成员变量
    #name;
    #age;
    constructor(name, age){
        this.#name = name;
        this.#age = age;
    }
    set name(name){
        this.#name=name;
    }
    get name(){
        return this.#name;
    }
    set age(age){
        this.#age = age;
    }
    get age(){
        return this.#age;
    }
}
class Student extends Person{
    #score;
    constructor(name,age,score){
        // 调用父类构造器
        super(name, age);
        this.#score = score;
    }
    set score(score){
        this.#score = score;
    }
    get score(){
        return this.#score;
    }
    good(){
        console.log(`${this.age}岁的${this.name}考了${this.score}分`)
    }
}
let s = new Student("李四",15,99)
// 15岁的李四考了99分
s.good();
```

# 对象拷贝

## 浅拷贝

就是传地址，两个变量指向一个对象

```js
let arr1 = [1,2,3];
let arr2 = arr1;

let p1 = new Person("张三",15)
let p2 = p1
```

## 深拷贝

可通过解构表达式

```js
let arr1 = [1,2,3];
let arr2 = [...arr1];

let p1 = new Person("张三",15)
let p2 = {...p1};
```

如过是对象，可通过json序列化和反序列化

会丢失私有属性、方法等

```js
let p1 = new Person("张三",15)
let p2 = JSON.parse(JSON.stringify(p1));
```

# 模块化

## 导入

```js
// * 代表Math.js中的所有资源
// 无论何种方式导入，导入的内容都会被当成一个对象处理
// 所以要用as指定一个对象来接收
// 调用时需要如 math.add()
import * as math from './Math.js';
// 或者使用解构表达式
// 调用时直接 add()
import {add,diff} from './Math.js';
// 解构表达式里可以起别名
// 调用时 ad()
import {add as ad,diff} from './Math.js';
// 解构表达式里可以导入多次，一次起别名，一次原名
// 调用时 ad() add()都可以
import {add, add as ad,diff} from './Math.js';
// 默认导出的导入方式 start
import * as math from './Math.js';
math.default or math.default()
// or
import {default as add} from './Math.js';
// or
import add from './Math.js';
// 默认导出的导入方式 end
```

html以模块的方式引入js文件

```html
<script src="" type="module"></script>
```

## 分别导出

在想要暴露的属性之前添加export关键字

```js
export function add(){};
export class Person{};
```

## 统一导出

```js
function add(){};
class Person{};
export{add,Person}
```

## 默认导出

指定引入某个js文件时默认引入的对象，默认导出只能有一个

```js
function add(){};
class Person{};
export default Person
```

