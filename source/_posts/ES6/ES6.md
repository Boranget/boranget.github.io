---
title: ES6
date: 2023-11-09 19:07:19
updated: 2023-11-11 10:35:19
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

连续结构赋值

```js
let obj = {
    a:{
        b:{
            c: 1
        }
    }
}
const {a:{b:{c}}} = obj
console.log(c)
// 同时重命名
const {a:{b:{c:name}}} = obj
console.log(name)
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

# 扩展运算符

```js
// 拼接数组或对象
const arr = [1, 2, 3];
const arr2 = [...arr, 4, 5, 6];

// 使用展开运算符克隆一个对象，是浅复制
const obj = { a: 1, b: 2 ,c:{name:'zhangsan'}};
const newObj = { ...obj};
obj.c.name="lisi"
console.log(newObj);// newObj的c.name为lisi
// 复制的同时还可以修改属性或者添加属性
const newObj = { ...obj, a: 5 };
console.log(newObj); // newObj的属性a被修改了

// 批量形参
const sum = (...args) => {
    return args.reduce((a, b) => a + b, 0);
};
const res = sum(1, 2, 3, 4);
console.log(res);
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

## 实例方法的定义方式

类中实例方法有两种定义方式，一种是直接定义，一种是属性定义

直接定义的实例方法放在实例对象的原型对象上，而属性方法直接放在实例对象的上

如果将属性定义的方法改为箭头函数，则由于箭头函数的this会指向外层所在的this，故箭头函数中的this会指向实例对象

```js
class Person{
    // 直接定义的实例方法放在实例对象的原型对象上
    eat(){
        console.log('eat');
    }
    // 而属性方法直接放在实例对象的上
    speak = function(){
        console.log('speak');
    }
	// 箭头函数
    speak2 = () => {
        console.log('speak2');
    }
}
const p = new Person();
console.log(p);
```

![image-20240404115211061](ES6/image-20240404115211061.png)

## 调用实例方法

在类中定义的方法被放在了类的原型对象上，供实例使用

在实例调用自身的实例方法时，实例方法中的this为当前实例

```js
p.eat()
```

但比如使用call去调用实例方法时，可以更改方法中的this指向，下面的call方法中如果使用了this，this会指向传入的`{"name":"zs"}`

```js
p.eat.call({"name":"zs"})
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

构造器中的this为当前的实例对象

构造方法也会存放在原型链上

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

子类在继承父类后，子类的构造器可以不写，可以直接使用父类的构造器。

若在子类中定义了构造器，则必须调用父类的构造器，且必须在子类构造器最开始调用

其实父类就是放在了子类对象的原型链上，所以子类可以直接调用父类的方法

但是父类的属性不会直接继承到自身，可能会通过构造方法获得跟父类类似的属性

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
class Person{};
export default Person
```

# 动态对象属性key

```js
const user = {
    username: "john",
    password: "password"
}
const key = "username"
user[key] = "jane"
const newUser = {[key]:"zs"}
console.log(user)
console.log(newUser)
```

# 函数柯里化

一个函数的返回值是一个函数

# promise

**回调函数**

回调函数是基于事件的自动调用函数，其他的代码不会等待回调函数执行完毕才向下走，所以回调函数的执行是异步的。

回调函数是一种未来会执行的函数，回调函数以外的其他代码不会等这个函数的执行结果就会执行下去

回调函数相当于一种”承诺“，其从提出后有三种状态

- 进行中
- 兑现（成功）
- 失败

针对承诺的三种状态要执行三种预案

## 什么是promise

promise是异步编程的一种解决方案，比传统的解决方案（回调函数和事件）更加强大，ES6原生提供了Promise对象。Promise类似于一个容器，其中保存着某个未来才会结束的事件（通常是一个异步操作）的结果

有三种状态：

- Pending 进行中
- Resolved 已完成
- Rejected 已失败

只有其异步操作的结果可以决定当前是哪一种状态，任何其他操作都无法改变这个状态。

一旦状态改变就不会再改变。任何时候都可以得到这个结果，Promise的对象状态的改变，只有两种可能：Pending变为Resolved，或者从Pending变为Rejected，只要这两种情况发生，状态就凝固了，不会再改变了

## 使用

```js
// 里面的函数便是回调函数
let promise = new Promise(function(){});
// 回调函数可接收两个参数：resolve 和 reject 
// 这两个参数其实是函数，在回调函数中调用可改变当前promise的状态
let promise = new Promise(function(resolve,reject){});
// then方法会在promise对象的状态发生改变后执行
// then中可以传入两个参数，分别为两个方法
// 第一个方法为状态转为resolved时会执行的函数
// 第二个方法为状态转为reject时会执行的代码
// promise中的函数会在promise被声明的时候便开始执行
// 而then方法会等待promise中的方法执行结束执行，then下方的方法不会等待then执行完成，但会等待promise代码执行完成（也就是说then是异步的，但promise中的方法不是？）
promise.then(
    function(){
        console.log(resolve);
    }
    ,function(){
        console.log(reject);
    }
)
// resolve与reject函数可以传入参数作为消息，可以在then中的回调函数中接收
let promise = new Promise(function(resolve,reject){
    resolve("success");
    reject("fail");
});
promise.then(
    function(value){
        console.log(value);
    }
    ,function(value){
        console.log(value);
    }
)
// then方法会返回另一个Promise，其值为
// 如果成功函数中返回了非Promise值，则会将其包装为Promise作为then的返回
// 如果成功函数中返回了一个Promise对象，则then的返回值则为该Promise
// 如果成功函数中抛出了一个异常，则then会返回一个失败promise，失败原因为该异常
// 如果失败状态没有指定返回值，则then会返回一个封装为成功的Promise，其值为undefined
// 可调用该对象的catch函数
// catch函数当promise中的回调函数报错或promise状态为reject的时候执行
// 可接收一个参数，其值为回调函数中reject填入的值或者异常信息
// 所以如果有catch处理的话，then中的第二个方法可以去掉
let promise2 = promise.then(
    function(value){
        console.log(value);
    }
)
promise2.catch(function(){})

// 以上这些操作可以连写
promise.then(
    function(value){
        console.log(value);
    }
).catch(function(value){
    console.log(value);
})
```

## 中断then链

返回一个pending状态的promise用于终端then链处理

```js
fetch('www.baidu.com').then(
  response => {
    console.log('这一步只能证明连接服务器成功了');
    // 返回一个 Promise 对象，该对象会在响应成功时解析为 JSON 对象，用于下面then的处理
    return response.json();
  },
  error =>{
    console.log('连接服务器失败', error);
    // 中断then链调用
    return new Promise(() => {});
  }
).then(
  response => {
    console.log('服务器返回的数据', response);
  },
  error => {
    console.log('服务器返回错误', error);
  }
)
```



## async

```js
async function a(){
    
}
// 箭头方式
let a = async ()=>{}
```

async 所标识的函数会被封装为返回结果是一个pomise对象的函数，async标识函数的方法体则是Promise对象声明时所接收的那个回调函数。

如果在a函数中返回结果，则该promise的状态会变为Resolved，返回的结果会放入resolve的参数中，

如果在a函数中抛出异常，则该promise的状态会变为Rejected，异常信息放入reject的参数中。

如果a函数return了一个promise对象，则该promise就是这个promise

```js
let promise = a();
promise.then().catch()
```

## await

用于快速获取promise对象在成功状态下的返回值，只能在async修饰的方法中使用

如果await操作的promise返回的是异常，则await操作会抛出异常

与await在同一个方法体中且在await后的代码会等待await执行结束

```js
let res = await Promise.resolve(obj)
// res = obj
```

```js
async function p(){
    return 0;
}
async function fun(){
    let res = await p();
    console.log(res);
}
fun()
```

使用await只能获取成功后的结果数据，那如何处理失败呢？答案是使用trycatch

```js
async a() {
    try {
        const response = await fetch("www.baidu.com");
        const data = await response.json();
        console.log(data);
    } catch (e) {
        console.log(e);
    }
}
```



# fetch

兼容性不高，老版本浏览器有不兼容，与xhr无关

```js
fetch('www.baidu.com').then(
  response => {
    console.log('这一步只能证明连接服务器成功了');
    // 返回一个 Promise 对象，该对象会在响应成功时解析为 JSON 对象，用于下面then的处理
    return response.json();
  },
  error =>{
    console.log('连接服务器失败', error);
    // 中断then链调用
    return new Promise(() => {});
  }
).then(
  response => {
    console.log('服务器返回的数据', response);
  },
  error => {
    console.log('服务器返回错误', error);
  }
)
// 优化
fetch('www.baidu.com').then(
    response => {
        console.log('这一步只能证明连接服务器成功了');
        // 返回一个 Promise 对象，该对象会在响应成功时解析为 JSON 对象，用于下面then的处理
        return response.json();
    }
).then(
    response => {
        console.log('服务器返回的数据', response);
    }
).catch(
    error => {
        console.log('服务器连接失败', error);
    }
);
```

# Axios

用于发送请求

```bash
npm install axios
```

```vue
<script setup>
import { ref } from "vue";
import axios from "axios";

let msg = ref("");
function getMsg() {
  // 方法返回一个promise对象
  axios({
    // url
    url: "https://api.uomg.com/api/rand.qinghua?format=json",
    // method
    method: "get",
    // params会以键值对形式拼接到url后，
    params: {},
    // data 会以json形式放入请求体
    data: {}
  })
    .then((response) => {
      /**
       * response的结构
       * {
       *    data：服务端响应的数据，如果是个json数据，会自动转为对象
       *    status：响应状态码
       *    statusText：响应描述
       *    headers：响应头
       *    config：本次请求的配置信息
       *    request：本次请求的XMLHttpRequest属性
       * }
       */
      console.log(response);
      console.log(response.data.content)
      msg.value = response.data.content;
    })
    .catch((e) => {
      console.log(e);
    });
}
</script>
<template>
  <div>
    <h1>{{ msg }}</h1>
    <button @click="getMsg">变</button>
  </div>
</template>
<style scoped>
</style>
```

**Object.assign(a,b)**

可将b中的属性赋予a对象，若a对象中已有，则覆盖，没有则创建

```vue
<script setup>
import { ref, reactive } from "vue";
import axios from "axios";

let data = reactive({});
function getMsg() {
  // 方法返回一个promise对象
  axios({
    // url
    url: "https://api.uomg.com/api/rand.qinghua?format=json",
    // method
    method: "get",
    // params会以键值对形式拼接到url后，
    params: {},
    // data 会以json形式放入请求体
    data: {}
  })
    .then((response) => {
      /**
       * response的结构
       * {
       *    data：服务端响应的数据，如果是个json数据，会自动转为对象
       *    status：响应状态码
       *    statusText：响应描述
       *    headers：响应头
       *    config：本次请求的配置信息
       *    request：本次请求的XMLHttpRequest属性
       * }
       */
      console.log(response);
      console.log(response.data.content)
      Object.assign(data,response.data)
    })
    .catch((e) => {
      console.log(e);
    });
}
</script>
<template>
  <div>
    <h1>{{ data.content }}</h1>
    <button @click="getMsg">变</button>
  </div>
</template>
<style scoped>
</style>
```

## 简写

由于await后的代码会等待await执行结束，则若在提交按钮绑定的方法中使用await获取数据，通过获取到的数据来判断当前方法应该返回的值是可行的，因为return会等待await的执行结果

**get**

```vue
<script setup>
import { ref, reactive } from "vue";
import axios from "axios";

let showData = reactive({});

async function getMsg(){
  // axios.get(url,{params,headers})
  let promise = axios.get("https://api.uomg.com/api/rand.qinghua?format=json",{
    params:{
      name:"zs"
    }
  })
  let {data} = await promise;
  Object.assign(showData,data)
}
</script>
<template>
  <div>
    <h1>{{ showData.content }}</h1>
    <button @click="getMsg">变</button>
  </div>
</template>
<style scoped>
</style>
```

**post**

```vue
<script setup>
import { ref, reactive } from "vue";
import axios from "axios";

let showData = reactive({});

async function getMsg() {
  // axios.get(url,{params,headers})
  let promise = axios.post(
    "https://api.uomg.com/api/rand.qinghua?format=json",
    // 这个对象是请求体
    {
      username: "zs",
      password: "123456",
    },
    {
      params: {
        name: "zs",
      },
    }
  );
  let { data } = await promise;
  Object.assign(showData, data);
}
</script>
<template>
  <div>
    <h1>{{ showData.content }}</h1>
    <button @click="getMsg">变</button>
  </div>
</template>
<style scoped>
</style>
```

## 拦截器

axios可通过creat方法生成一个实例，该实例有着与axios相似的方法调用，可在某具体js中生成该实例并将该实例暴露，且在js文件中给该实例添加拦截器，以下示例并没有单独抽离实例js

```vue
<script setup>
import { ref, reactive } from "vue";
import axios from "axios";

let showData = reactive({});

async function getMsg() {
  // axios.get(url,{params,headers})
  /**
   * baseURL 使用该实例发送的请求之前会拼接baseURL
   * timeout 请求超时时间，毫秒单位
   */
  let axiosins = axios.create({
    baseURL: "https://api.uomg.com",
    timeout: 10000,
  });
  // 设置请求拦截器，两个函数
  axiosins.interceptors.request.use(
    config => {
      // 设置请求的信息，比如请求头、体等，最后需要返回这个config
      // config.headers.Accept="application/json,123"
      return config;
    },
    error => {
      // 请求错误拦截，需要返回一个失败的promise
      return Promise.reject(error)
    }
  );
  // 设置响应拦截器，两个函数
  axiosins.interceptors.response.use(
    response => {
      // 响应状态码为200时执行,response需要返回，否则没有响应
      console.log(123)
      return response
    },
    error => {
      // 其他状态码执行, 最后需要返回一个失败的promise
      console.log(error)
      return Promise.reject(error)
    }
  );
  let promise = axiosins.get("/api/rand.qinghua?format=json", {
    params: {
      name: "zs",
    },
  });
  let { data } = await promise;
  Object.assign(showData, data);
}
</script>
<template>
  <div>
    <h1>{{ showData.content }}</h1>
    <button @click="getMsg">变</button>
  </div>
</template>
<style scoped>
</style>
```

# 跨域

原因，浏览器当前请求的视图中的某个目标指向的地址与视图的地址不在同一个域。

- 方法一：前端服务器发请求
- 方法二：先发送预检请求，用于检查目标服务器是否安全
  - 前端先发送一个option的预检请求（自动发送）
  - 后端新增一个过滤器，如果收到的请求是预检请求，则拦截处理，正常请求则放行。在预检请求的响应头中设置是否允许跨域等的信息。