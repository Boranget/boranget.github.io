---
title: Vue
date: 2023-11-11 14:50:30
updated: 2024-01-12 16:40:19
tags:
  - vue
categories:
  - 笔记
---
# 核心功能

- 声明式渲染

    可以声明式的描述最终输出的HTML和JavaScript状态之间的关系

- 响应性

    vue会自动跟踪js状态并在其发生变化时响应式的更新DOM

# 渐进式

可以分块拉取依赖

# Hello Vue 

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="./node_modules/vue/dist/vue.global.js"></script>
</head>
<body>
    <div id="app">
        <h1 v-text="message"></h1>
        <h1 v-bind:style="colorStyle">{{message}}</h1> 
        <button @click="fun1">change</button>
    </div>
    
    <script>
        const app = Vue.createApp({
            // 注意以下为vue3的语法
            setup(){
                let message = "hello vue";
                // 使用 v-bind:属性名=”colorStyle“ 可以绑定属性
                let colorStyle = {"background-color":"red"};
                function fun1(){
                    alert("hello");
                }
                // 在 return中返回的变量或者方法才能和HTML元素关联
                return {
                    message,
                    colorStyle,
                    fun1
                }
            }
        })
        // app对象关在到元素身上
        app.mount("#app");
    </script>
</body>
</html>
```

# vue2

vue2为选项式api，又叫配置式（option），单个功能的各个模块分散在不同的配置领域中，不利于维护，vue3中使用组合式api

# setup

setup是vue3中新增的配置项

## this

注意setup函数中的this为undefind

## setup的返回值

在setup函数中将需要暴露到渲染中的对象返回

## 与data、method关系

data，method还可以写但不建议，由于setup中没有this、且其为最早的生命阶段，所以读不到data、method中的内容，但是反过来，data、method中可以通过this读取setup中的内容

# vite+vue3工程目录

```
E:\MY_FILE\PROJECTS\VUE\VITE-DEMO
├─.vscode
├─node_modules
├─public			存放公共资源
└─src				源代码目录
    ├─assets		项目中静态资源
    └─components	组件
```

- 在vite项目中，index.html是项目的入口文件，在项目的最外层
- 加载index.html后，Vite解析`<script type="module" src="xxx">`指向的JS文件
- Vue3中通过createApp函数创建一个应用实例

# SFC

**单文件组件**

多个页面共同拥有的部分可以抽出来作为组件，用于引入，传统的组件剥离方式为多文件组件：每一个组件作为一个html文件，其中包含该组件的html，js以及css代码。

vue中组件剥离方式为通过*.vue文件来管理组件，其中有style，script，template标签，分别存放组件的样式，脚本，html代码。 

组件引入：

```vue
import Block from "./.../BlockVue.vue"
// 此时Block可以作为HTML标签使用
```

每个vue会把一个组件封装成一个html标签，需要用的时候直接将该标签放到需要的位置即可

语法上要求template标签下有且只有一个子标签，可使用div包裹

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vite + Vue</title>
  </head>
  <body>
    <div id="app"></div>
    <!-- 
    import { createApp } from 'vue'
    import './style.css'
    import App from './App.vue'
    // vue 会将App模块中的template部分放入这里mount的结构中
    createApp(App).mount('#app') 
    -->
    <script type="module" src="/src/main.js"></script>
  </body>
</html>

```

```vue
<script setup>
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <div>
    <a href="https://vitejs.dev" target="_blank">
      <img src="/vite.svg" class="logo" alt="Vite logo" />
    </a>
    <a href="https://vuejs.org/" target="_blank">
      <img src="./assets/vue.svg" class="logo vue" alt="Vue logo" />
    </a>
  </div>
  <HelloWorld msg="Vite + Vue" />
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
```

# CSS样式的导入

共享css样式写入一个css文件中，通过以下三种方法引入

```vue
// 1.
<script>
    import ‘.../*.css’
</script>
// 2.
<style>
	@import ‘.../*.css’
</style>
// 3.
在main.js文件中导入
import ‘.../*.css’
```

## 局部样式

在某个vue文件中的scoped属性，可以限制其中内容只在当前vue文件中生效

```vue
<style scoped>
</style>
```



# 响应式数据

响应式数据是指在变量的数据变化之后，页面渲染的数据会随着变量改变

在vue2中，数据默认就是响应式的，但在vue3中，数据需要经过ref/reactive函数的处理.

ref函数更适合单个字面量（基本类型数据），但也可以定义对象类型的数据，碰到对象数据时底层会使用reactive

reactive只能定义对象类型的响应式数据

## ref

在script标签中，ref响应数据需要通过.value的方式操作数据（包括对象和数组，也会被转为value），但在template标签中使用ref数据不需要。

```vue

<script>
  import {ref} from 'vue';
  export default{
    setup(){
    let num = ref(0);
    function add(){
      num.value++;
    }
    function diff(){
      num.value--;
    }
    return{num,add,diff}
  }
  }
  
</script>

<template>
  <div>
    <button @click="add">+</button>
    <span>{{num}}</span>
    <button @click="diff">-</button>
  </div>
</template>

<style scoped>
</style>

```

## reactive

在script标签中和在template标签中使用reactive数据都不需要.value。

reactive同时可以修改深层的属性（多层）

reavtive声明的对象会变为Proxy对象

reactive声明的对象重新指向后会失去响应式：原理也好理解，本来该对象变为Proxy对象了，结果重新指向另一个对象，就变成普通对象了，这是其一，其二，就算在替换时重新使用reactive包装，但由于页面渲染时使用的那个对象是之前的，与现在这个新声明的对象并无联系，所以也体现不到页面上。但是可以通过Object.assign去整体替换对象中的属性。**但是使用ref声明的对象可以通过value整体替换**

```vue
<script setup>
import { reactive, ref } from "vue";
let person = reactive({
  name:"张三",
  age:15
})
</script>
<template>
  <div>
    <button @click="person.age++">+</button>
    <span>{{person.name}}</span>
    <span>{{person.age}}</span>
    <button @click="person.age--">-</button>
  </div>
</template>
<style scoped>
</style>
```

- toRef/toRefs 将reactive中的某个属性或者多个属性转为ref响应数据

    ```js
    let age = toRef(person, "age")
    let {age, name} = toRefs(person)
    age.value=10
name.value="123"
    ```
    
    

# setup语法糖

去掉导出，去掉方法框，去掉返回语句 ，script标签添加setup属性

```vue

<script setup>
import { ref } from "vue";
let num = ref(0);
function add() {
  num.value++;
}
function diff() {
  num.value--;
}
</script>

<template>
  <div>
    <button @click="add()">+</button>
    <span>{{ num }}</span> 
    <button @click="diff()">-</button>
  </div>
</template>

<style scoped>
</style>

```

使用这种语法糖有个问题是无法设置组件名，组件名与vue文件名匹配，一种解决办法是写两个script，在另一个script中声明组件名，或者使用插件：vite-plugin-vue-setup-extend

# 插值表达式

使用时不依赖于标签

```js
// 引用变量
{{msg}}
// 调用函数 
{{getMsg()}}
// 运算 
{{age>18?'成年':'未成年'}}
// 对象调用api 
{{bee.split(' ').reverse().join('')}}
```

# 文本渲染命令

v-text、v-html

- 命令必须依赖标签且必须在开始标签中使用

- 命令支持使用模板字符串，注意在双引号中还有反单引号

    ```vue
    <h1 v-text="`你好 ${name}`"></h1>
    ```

- 命令中支持运算
- 支持对象api调用
- v-text不支持html标签解析，v-html支持

# 属性渲染命令

v-bind:属性名=”“

```vue
<img v-bind:src="data.logo" v-bind:title="data.name">
```

可简写为：：（简写为冒号）

```vue
<img :src="data.logo" :title="data.name">
```

# 事件渲染命令 

v-on:事件名="函数名()"，这里的事件名不是原生的事件名，而是原生事件名去掉on前缀

```vue
<button v-on:click="submit()">按钮</button>
```

可简写为@事件名

```vue
<button @click="submit()">按钮</button>
```

## 内联事件

直接将方法事件写到事件渲染命令中

非内联：

```vue

<script setup>
import { ref } from "vue";
let num = ref(0);
function add() {
  num.value++;
}
function diff() {
  num.value--;
}
</script>

<template>
  <div>
    <button @click="add()">+</button>
    <span>{{ num }}</span>
    <button @click="diff()">-</button>
  </div>
</template>

<style scoped>
</style>
```

内联：

在template种操作ref对象无需操作value属性

```vue

<script setup>
import { ref } from "vue";
let num = ref(0);
</script>
<template>
  <div>
    <button @click="num++">+</button>
    <span>{{ num }}</span>
    <button @click="num--">-</button>
  </div>
</template>
<style scoped>
</style>

```

## 事件修饰符

- .once 只绑定一次，触发一次后失效

    ```vue
    <button @click.once = "submit()">按钮</button>
    ```

- 去除默认行为

    ```vue
    <button @click.prevent"submit()">按钮</button>
    ```

    相当于

    ```js
    <button @click"submit($event)">按钮</button>
    function submit(event){
        ...
        event.preventDefault();
    }
    ```

    

# 条件渲染

v-if 为true则当前元素被渲染（展示），否则将不在dom树中

v-else 自动和前一个v-if取反 

```vue
<script setup>
import { reactive, ref } from "vue";
let person = reactive({
  name:"张三",
  age:15
})
</script>
<template>
  <div>
    <button @click="person.age++">+</button>
    <span v-if="person.age>0">{{person.name}}</span>
    <span v-else>还没出生</span>
    <span>{{person.age}}</span>
    <button @click="person.age--">-</button>
  </div>
</template>
<style scoped>
</style>
```

v-show 将数据隐藏（display方式），总会被渲染，只是会被隐藏

相比起来v-if有更高的切换开销，如果不切换或者切换比较少，则v-if合适，如果频繁切换则show合适

# 列表渲染

v-for 需要注意要定义key，建议使用属性id，key前要加冒号（其实是v-bind）

```vue
  <tr v-for="item,index in data.list" :key = item.id>
    <td>{{ index }}</td>
    <td>{{ item.id }}</td>
    <td>{{ item.name }}</td>
    <td>{{ item.age }}</td>
  </tr>
```

# 单/双向绑定

- 单向绑定：v-bind 响应式数据变化时，会更新dom树，但用户对页面中内容的改变如输入框中数据的变化不会影响响应式数据

- 双向绑定：v-model 用户对页面中内容的改变如输入框中数据的变化会影响响应式数据的值，一般用于表单

    ```vue
    <script setup>
    import { reactive, ref } from "vue";
    let user = reactive({})
    </script>
    <template>
      <div>
        <form action="#">
          用户名：<input type="text" v-model="user.name"><br>
          密码：<input type="password" v-model="user.pass">
          <!-- reset按钮对响应式数据不起作用 -->
          <button type="reset">clear</button>
        </form>
        <h1>{{user}}</h1>
      </div>
    </template>
    <style scoped>
    </style>
    ```

# 计算属性

computed，其值为其他属性计算而来

与直接调用计算方法的区别：

- 方法每调用一次都会执行一次方法
- 计算属性会判断计算属性依赖的数据有无发生变化，如果没变化则使用上一次计算的结果缓存

```js
import { computed } from "vue";
let count = computed(()=>{
	return carts.length;
})
```

# 数据监听器

监听数据发生改变，watch为懒监听，即在监听到源发生变化时才会执行回调函数

watch可监听的源包括如下内容

- 一个函数，返回一个值
- 一个ref
- 一个响应式对象
- 由以上类型的值组成的数组



## ref指向的一个值

监听ref值，注意这里不需要.value，watch函数的返回值是一个函数，调用该返回值函数可以停止该watch的监视（但在方法的一个参数里居然可以调方法的返回值？嗯，因为该参数方法是在监视到改变时才会调用，到时已经可以获取到外部方法的返回值了）

 ```vue
<script setup>
  import { reactive, ref, watch } from "vue";
  let count = ref("");
  let stopwatch = watch(count, (newValue,oldValue)=>{
    console.log(oldValue,"->",newValue);
      if(...){
         stopwatch()
      }
  });
</script>
<template>
  <div>
    <input type="text" v-model="count" />
  </div>
</template>
<style scoped>
</style>
 ```



## ref指向的对象

监听ref定义的对象，注意这里需要开启深度监听才能监听其中的属性是否改变（获取的对象还是整个对象），否则只有在修改整个value指向的对象时才会触发

注意如果是改变其中的某个属性，则获取到的newvalue和oldvalue都是最新的对象，因为地址值是没变的，所以对象一直没变。多数情况下一般不用oldvalue

```vue
<script setup>
  import { reactive, ref, watch } from "vue";
  let person = ref({name:"",age:10});
  let stopwatch = watch(person, (newValue,oldValue)=>{
    console.log(oldValue,"->",newValue);
      if(...){
         stopwatch()
      }
  },{deep:true});
</script>
<template>
  <div>
    <input type="text" v-model="count" />
  </div>
</template>
<style scoped>
</style>
```



## reactive指向的对象

监视reactive定义的对象类型数据，默认是开启深度监视的，且无法关闭 

```js
let person = reactive({
    name:"jeck",
    age: 18
})
watch(person, (newValue,oldValue)=>{
    console.log(oldValue,"->",newValue);
});
```



## reactive指向对象中的某个属性

监听reactive中的一个属性，则不能直接监视，可以通过将其作为返回值放入一个方法，则可以进行监听

```vue
<script setup>
  import { reactive, ref, watch } from "vue";
    watch(()=>count.value, (newValue,oldValue)=>{
    console.log(oldValue,"->",newValue);
  });
</script>
<template>
  <div>
    <input type="text" v-model="count.value" />
  </div>
</template>
<style scoped>
</style>
```



## reavtive指向对象中的属性对象

监听某个对象中的某个属性对象变化，deep设为true进行深度监听

```vue
<script setup>
  import { reactive, ref, watch } from "vue";
  let count = reactive({
      name:"",
      car:{
          price:100
      }
  });
  // 当price发生变化时也会触发，不进行深度监听只有在car整个被替换才会触发
  watch(()=>count.car, ()=>{
    console.log(count)
  },{deep:true});
</script>
<template>
  <div>
    <input type="text" v-model="count.value" />
  </div>
</template>
<style scoped>
</style>
```

除了{deep:true}之外，其中还可添加{immediate:true}：在页面加载完成后立即执行（使用初始值也算一次变化，也会触发）



## 一个数组

新旧value是数组

```js
import { reactive, ref, watch } from "vue";
watch([()=>count.value,person], (newValue,oldValue)=>{
    console.log(oldValue,"->",newValue);
});
```



## watchEffect

立即运行一个函数，同时响应式的追踪其依赖，并在依赖更改时重新执行该函数

任何响应式数据变化都会触发，但前提是该数据在watchEffect方法中有用到，适用于同时要监视大量数据，避免一个个监视

```vue
<script setup>
  import { reactive, ref, watch, watchEffect} from "vue";
  let count = reactive({});
  watchEffect(()=>{
    
  });
</script>
<template>
  <div>
    <input type="text" v-model="count.value" />
  </div>
</template>
<style scoped>
</style>
```

# vue生命周期

- setup

- beforeCreate

    组件实例化完成之后执行

- created

    组件实例处理完所有与状态相关的选项后调用，挂载还未开始

- beforeMount

    将vue中定义的dom树挂载到html页面之前

- mounted

    将vue中定义的dom树挂载到html页面之后

- beforeUpdate

    数据已更新，在更新到dom之前

- updated

    更新到dom之后

- beforeUnmounte

    移除某个dom之前

- unmounted

    移除某个dom之后

# 组件

## 组件组装

header

```vue
<script setup>

</script>
<template>
  <div>
    欢迎：<a href="#">退出登录</a>
  </div>
</template>
<style scoped>
</style>
```
navigator

```vue
<script setup>

</script>
<template>
  <div>
    <ul>
      <li>各种管理</li>
      <li>各种管理</li>
      <li>各种管理</li>
      <li>各种管理</li>
      <li>各种管理</li>
      <li>各种管理</li>
    </ul>
  </div>
</template>
<style scoped>
</style>
```
content

```vue
<script setup>

</script>
<template>
  <div>
    这里展示主要内容
  </div>
</template>
<style scoped>
</style>
```
App

```vue
<script setup>
  // 引入header
  import Header from "./components/Header.vue";
  // 引入navigator
  import Navigator from './components/Navigator.vue';
  // 引入content
  import Content from './components/Content.vue'; 
</script>
<template>
  <div>
    <Header class="header"></Header>
    <Navigator class="navigator"></Navigator>
    <Content class="content"></Content>
  </div>
</template>
<style scoped>
.header{
  height: 90px;
  border: 1px solid black;
}
.navigator{
  width: 15%;
  float: left;
  height: 800px;
  box-sizing:border-box;
  border: 1px solid black;
}
.content{
  width:85%;
  float: right;
  height: 800px;
  box-sizing:border-box;
  border: 1px solid black;
}
</style>
```

## 组件传参

可以父组件传参给子组件，也可以子组件传给父组件，两者结合便可实现兄弟传参

navigator（子）

```vue
<script setup>
 // degineEmits用于定义子组件向父组件提交数据的事件以及正式的提交数据
  import { defineEmits } from 'vue';
  // 定义一个向父组件提交数据的事件
  // sendMenu为事件的标识
  // 返回值emits为提交方法，提交时需要携带事件标识
  const emits = defineEmits(["sendMenu"]);
  function send(data){
    emits("sendMenu",data);
  }
</script>
<template>
  <div>
    <ul>
      <!-- 这里在指定方法时可以 -->
      <li @click="send('各种管理1')">各种管理1</li>
      <li @click="send('各种管理2')">各种管理2</li>
      <li @click="send('各种管理3')">各种管理3</li>
      <li @click="send('各种管理4')">各种管理4</li>
      <li @click="send('各种管理5')">各种管理5</li>
      <li @click="send('各种管理6')">各种管理6</li>
    </ul>
  </div>
</template>
<style scoped>
</style>
```
App（父）

```vue
<script setup>
// 引入header
import Header from "./components/Header.vue";
// 引入navigator
import Navigator from "./components/Navigator.vue";
// 引入content
import Content from "./components/Content.vue";
import { reactive, ref, watch } from "vue";
let navigatorMsg = ref("");
function handler(data) {
  navigatorMsg.value = data;
}
</script>
<template>
  <div>
    <Header class="header"></Header>
    <!-- 定义接收器并绑定处理事件的方法 -->
    <Navigator @sendMenu="handler" class="navigator"></Navigator>
    <!-- msg为自定义名称的传递给子组件的信息，可以不叫msg叫别的什么，这里加了冒号则会将navigatorMsg作为表达式，这里会当作变量名去寻找对应的对象 -->
    <Content class="content" :msg="navigatorMsg"></Content>
  </div>
</template>
<style scoped>
.header {
  height: 90px;
  border: 1px solid black;
}
.navigator {
  width: 15%;
  float: left;
  height: 800px;
  box-sizing: border-box;
  border: 1px solid black;
}
.content {
  width: 85%;
  float: right;
  height: 800px;
  box-sizing: border-box;
  border: 1px solid black;
}
</style>
```
Content（子）

```vue
<script setup>
import { defineProps } from "vue";
// msg 为父组件给子组件加上的属性名，String为属性值的类型
// x中包含所有父组件传递的消息
let x = defineProps({ msg: String });
    // or
let x = defineProps(['msg']);
</script>
<template>
  <div>
    {{ msg }}
  </div>
</template>
<style scoped>
</style>
```

# Router

[嵌套路由 | Vue Router (vuejs.org)](https://router.vuejs.org/zh/guide/essentials/nested-routes.html)

## 两种方案

一种为使用锚点跳转，另一种为使用日常地址跳转，分别对应不同组件 createWebHistory和createWebHashHistory

- `createWebHistory`：使用 HTML5 的 `history.pushState` 和 `history.replaceState` 方法来实现路由跳转。URL 的结构更为直观，例如 `/home`、`/about` 等，不会包含任何特殊字符。然而，由于它使用了 HTML5 的 history API，如果直接在浏览器中刷新或直接访问某个路由，服务器需要能够识别并处理该路由，否则可能会返回 404 错误。
- `createWebHashHistory`：在 URL 中使用 `#` 符号（例如 `http://www.example.com/#/page`）。`#` 之后的内容不会被发送到服务器，所以不需要在服务器层面上进行任何特殊处理。这种模式对后端更为友好，即使后端没有实现完整的路由覆盖，也不会导致 404 错误。

## 锚点方式

锚点方式：通过当前地址栏的路径切换vue组件，达到不刷新当前页面便可大面积替换内容的效果，但感觉地址栏使用锚点的效果不太好看（来自后端开发的吐槽）

```bash
npm install vue-router
```

App.vue，定义何处使用路由替换
```vue
<script setup>

</script>
<template> 
  <div>
    内容在下面
    <!-- 通过路由，该标签会被替换为具体的vue -->
   	<router-view></router-view>
    内容在上面
  </div>
</template>
<style scoped>

</style>
```

main.js

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './routers/router.js';
const app = createApp(App);
// 让app使用路由
app.use(router)
app.mount('#app')
```

路由.js

```js
import {createRouter, createWebHashHistory} from 'vue-router';
import Home from '../components/Home.vue';
import List from '../components/List.vue';
import Add from '../components/Add.vue';
import Update from '../components/Update.vue';

// 创建一个路由对象
const router = createRouter({

    // history属性用于记录路由的历史
    history:createWebHashHistory(),
    // routes 用于定义多个不同的路径和组件之间的对应关系
    routes:[
        {
            path:"/",
            component:Home
        },
        {
            path:"/home",
            component:Home
        },
        {
            path:"/list",
            component:List
        },
        {
            path:"/Add",
            component:Add
        },
        {
            path:"/update",
            component:Update
        }
    ]
}
);

// 暴露
export default router;
```
## 重定向

```js
{
    path:"/update",
    // 注意这里是重定向的地址而不是组件
    redirect:"/list"
}
```

## 路径跳转组件

会在router-view部分显示

```vue
<router-link to="/add">add</router-link>
<router-view/>
```

## router-view

一个页面可以有多个router-view，每个router-view可以展示不同内容

```vue
<script setup>

</script>
<template> 
  <div>
    内容在下面
    <!-- 该标签会被替换为具体的vue -->
      <router-view name="homeView"></router-view>
      <router-view name="listView"></router-view>
   内容在上面
  </div>
</template>
<style scoped>

</style>
```

```js
routes:[
        {
            path:"/",
            component:{
                homeView:Home
            }
        },
        {
            path:"/home",
            component:{
                homeView:Home
            }
        },
        {
            path:"/list",
            component:{
                listView:List
            }
        },
        {
            path:"/Add",
            component:{
                // 没有设置name的router-view
                default: Add
            }
        },
    ]
```

## 编程式路由

通过代码而非router-link实现页面的跳转 

```vue
<script setup>
import {ref} from "vue"
import {useRouter} from "vue-router"
const router = useRouter();
let target = ref("/home")
function changeRoute(){
  router.push(target.value)
  // 或
  router.push(path:target.value)
}
</script>
<template> 
  <div>
    <button @click="changeRoute">去target</button>
    <!-- 动态接收目标路由 -->
    <input type="text" v-model="target">
    内容在下面
    <!-- 该标签会被替换为具体的vue -->
   <router-view></router-view>
   内容在上面
   <router-link to="/add">add</router-link>
  </div>
</template>
<style scoped>

</style>
```

## 路由传参 

- 路径参数

    路由定义时使用冒号开头作为路径参数接收形参的定义

    ```js
    import {createRouter, createWebHashHistory} from 'vue-router';
    import Home from '../components/Home.vue';
    import Add from '../components/Add.vue';
    // 创建一个路由对象
    const router = createRouter({
        // history属性用于记录路由的历史
        history:createWebHashHistory(),
        // routes 用于定义多个不同的路径和组件之间的对应关系
        routes:[
            {
                path:"/",
                component:Home
            },
            {
                path:"/home",
                component:Home
            },
            {
                path:"/add/:addItem1/:addItem2",
                component:Add
            }
        ]
    }
    );
    // 暴露
    export default router;
    ```

    接收方使用route.params. 获取值，这里用到的useRoute与上方获取跳转路径的userRouter不是一个东西
    
    ```vue
    <script setup>
    import { useRoute} from 'vue-router';
    let route=useRoute()
    let a = parseInt(route.params.addItem1);
    let b = parseInt(route.params.addItem2);
    </script>
    <template>
      <div>
      add Result {{ a+b }}
      </div>
    </template>
    <style scoped>
      
    </style>
    ```
    
    **同组件内传参**
    
    在比如/add/1/2跳转到/add/3/4时，如果页面有使用路径参数渲染的数据，数据不会主动变化，可以使用update更新
    
    ```vue
    <script setup>
    import { useRoute } from "vue-router";
    import { onUpdated, ref } from "vue";
    let route = useRoute();
    let a = ref(parseInt(route.params.addItem1));
    let b = ref(parseInt(route.params.addItem2));
    onUpdated(() => {
      a.value = parseInt(route.params.addItem1);
      b.value = parseInt(route.params.addItem2);
    });
    </script>
    <template>
      <div>{{ a }} + {{ b }} = {{ a + b }}</div>
    </template>
    <style scoped>
    </style>
    ```

- 键值对传参

    路由正常定义

    ```js
    import {createRouter, createWebHashHistory} from 'vue-router';
    import Home from '../components/Home.vue';
    import Add from '../components/Add.vue';
    // 创建一个路由对象
    const router = createRouter({
        // history属性用于记录路由的历史
        history:createWebHashHistory(),
        // routes 用于定义多个不同的路径和组件之间的对应关系
        routes:[
            {
                path:"/",
                component:Home
            },
            {
                path:"/home",
                component:Home
            },
            {
                path:"/add",
                component:Add
            }
        ]
    }
    );
    // 暴露
    export default router;
    ```

    接收：使用query

    ```vue
    <script setup>
    import { useRoute } from "vue-router";
    import { onUpdated, ref } from "vue";
    let route = useRoute();
    let a = ref(parseInt(route.query.addItem1));
    let b = ref(parseInt(route.query.addItem2));
    onUpdated(() => {
      a.value = parseInt(route.query.addItem1);
      b.value = parseInt(route.query.addItem2);
    });
    </script>
    <template>
      <div>{{ a }} + {{ b }} = {{ a + b }}</div>
    </template>
    <style scoped>
    </style>``
    ```

    传参

    ```vue
    <router-link to="/add?addItem1=5&addItem2=6">5+6</router-link>
    router.push("/add?addItem1=5&addItem2=6")
    或者
    <router-link v-bind:to=”{path:'/add',query:{addItem1:2,addItem2:3}}“>5+6</router-link>
    router.push({path:'/add',query:{addItem1:2,addItem2:3}})
    ```

## 路由守卫

在路由切换前后使用回调函数的方式进行处理，可做登录校验：（在展现页面前先判断下存储中有没有登录成功的凭证）

- 全局前置守卫
- 全局后置守卫

在router.js中定义

```js
// 设置全局前置守卫
// 每次路由切换页面前，都会执行beforeEach中的回调函数
router.beforeEach(
    // to 到哪去。from 从哪来，next放行方法
    // next() 放行
    // next("/..") 要求浏览器重定向到哪个路径，一定要有条件，否则会死循环
    (to,from,next)=>{
        console.log("before");
        console.log(to,from,next);
        next();
    }
)
// 设置全局后置守卫
// 每次路由切换页面后，都会执行afterEach中的回调函数
router.afterEach(
    (to,from)=>{
        console.log("after");
        console.log(to,from);
    }
)
// 暴露
export default router;
```

如果当前已在目标组件但还要往目标组件跳，会执行after但不会执行before

## 登录实践

```js
import {createRouter, createWebHashHistory} from 'vue-router';
import Home from '../components/Home.vue';
import Login from '../components/Login.vue';

// 创建一个路由对象
const router = createRouter({

    // history属性用于记录路由的历史
    history:createWebHashHistory(),
    // routes 用于定义多个不同的路径和组件之间的对应关系
    routes:[
        {
            path:"/",
            component:Home
        },
        {
            path:"/home",
            component:Home
        },
        {
            path:"/login",
            component:Login
        }
    ]
}
);
// 设置全局前置守卫
// 每次路由切换页面前，都会执行beforeEach中的回调函数
router.beforeEach(
    // to 到哪去。from 从哪来，next放行方法
    // next() 放行
    // next("/..") 转到哪个也买你
    (to,from,next)=>{
        if(to.path == '/login'){
            next();
        }else{
            // 用户未登录则拦截
            const username = sessionStorage.getItem("username");
            if(null != username){
                next();
            }else{
                next('/login')
            }
        }
        
    }
)
// 暴露
export default router;
```

Login页面

```vue
<script setup>
import { useRouter } from "vue-router";
import { onUpdated, ref } from "vue";
let username = ref("");
let password = ref("")
const router = useRouter();
function login(){
  if(username.value == "user"&&password.value == "123456"){
    // 使用存储记录登陆状态
    sessionStorage.setItem('username', username.value);
    router.push("/home");
  }else{
    alert("用户名或者密码错误")
  }
}
</script>
<template>
  <div>
    <input type="text" v-model="username">
    <input type="password" v-model="password">
    <button @click="login">登录</button>
  </div>
</template>
<style scoped>
</style>
```

Home

```vue
<script setup>
import { useRouter } from 'vue-router';
  let username = sessionStorage.getItem("username");
  const router = useRouter();
  function logout(){
    sessionStorage.removeItem("username")
    router.push("/login")
  }
</script>
<template>
  <div>
    欢迎{{ username }} <br>
    <button @click="logout">退出登录</button>
  </div>
</template>
<style scoped>
 
</style>
```

## childen

注意name不能重名，否则会冲突

children用于vue嵌套，下面这种情况，Framework为父框架，其中有个route-view组件，用于展示子vue

```js
import {createRouter, createWebHistory} from 'vue-router'
import VueCookies from "vue-cookies";
const routes = [
    {
        name: '登录页',
        path: '/login',
        component: ()=>import('../views/Login.vue'),
    },
    {
        name: '主页',
        path: '/',
        component: ()=>import('../views/Framework.vue'),
        children:[
            {
                path:"/blog/list",
                name:"博客管理",
                component:()=>import('../views/blog/Blog-list.vue')
            },
            {
                path:"/blog/category",
                name:"分类管理",
                component:()=>import('../views/blog/Blog-category.vue')
            }
        ]
    }
];
const router = createRouter({
    routes,
    history: createWebHistory(),
})
router.beforeEach((to, from, next) => {
    console.log(to, from, next);
    const ui = VueCookies.get("userInfo");
    if (!ui && to.path!= "/login"){
        router.push("/login")
    }
    next();
});
export default router
```

# pinia

pinia中可以直接定义数据，默认是响应式的，多个vue文件可从中获取数据，pinia数据在浏览器刷新后会清除，一般会结合sessionsorage和gloablestorange使用  

**在main.js中开启全局pinia功能**

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './routers/router.js';
const app = createApp(App);
// 让app使用路由
app.use(router)
// 开启全局pinia
import { createPinia } from 'pinia';
let pini = createPinia();
app.use(pini);
app.mount('#app');
```

**定义共享数据**

```js
// 共享数据
import { defineStore } from "pinia";
// 定义一个共享数据，这里返回的是一个方法，该方法的返回值为定义的响应式数据
export const defindPerson = defineStore({
  id: "defindPerson", //当前数据id，要求全局唯一
  state: () => {
    // 这里return的值才是共享的数据
    return {
      uname: "张三",
      pword: "123456",
      patform: ["tecent", "ali", "baidu"],
    };
  },
  // 定义获得数据或者使用数据计算结果的函数，不要定义修改数据的逻辑
  getters: {
    username() {
      console.log(this);
      return `name${this.uname}`;
    },
    password() {
      return this.pword;
    },
    platform() {
      return this.patform;
    },
  },
  // 定义修改数据的函数
  actions: {
    changeName(name) {
        console.log("set")
      this.uname = name;
    },
  },
});

```

**可以只定义数据体**

```js
// 共享数据
import { defineStore } from "pinia";
// 定义一个共享数据，这里返回的是一个方法，该方法的返回值为定义的响应式数据
export const defindPerson = defineStore(
 // id可单独取出作为一个参数定义
 // "defindPerson",
 {
  id: "defindPerson", //当前数据id，要求全局唯一
  state: () => {
    // 这里return的值为共享的数据
    return {
      uname: "张三",
      pword: "123456",
      patform: ["tecent", "ali", "baidu"],
    };
  }
});

```

**比较习惯的另一种写法**

```js
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)
  function increment() {
    count.value++
  }

  return { count, doubleCount, increment }
})
```



**展示**

```vue
<script setup>
import { reactive } from 'vue';
import {defindPerson} from '../store/store.js'
let data = defindPerson() 
</script>
<template>
  <div>
    <h1>P1</h1>
  {{ JSON.stringify(data) }}
  </div>
</template>
<style scoped>
 
</style>
```



**修改**

```vue
<script setup>
import { reactive } from 'vue';
import {defindPerson} from '../store/store.js'
let data = defindPerson();
</script>
<template>
  <div>
    <h1>P2</h1>
    uname <input type="text" v-model="data.username">
    pwoed <input type="text" v-model="data.pword">
    <button @click="data.changeName('即刻')">changename</button>
  </div>
</template>
<style scoped>
 
</style>
```

**reset**

.$reset

```vue
<script setup>
import { reactive } from 'vue';
import {defindPerson} from '../store/store.js'
let data = defindPerson();
</script>
<template>
  <div>
    <h1>P2</h1>
    uname <input type="text" v-model="data.uname">
    pwoed <input type="text" v-model="data.pword">
    <button @click="data.$reset()">重置</button>
  </div>
</template>
<style scoped>
 
</style>
```

**批量**

.$patch

```vue
<script setup> 
import { reactive } from 'vue';
import {defindPerson} from '../store/store.js'
let data = defindPerson();
</script>
<template>
  <div>
    <h1>P2</h1>
    uname <input type="text" v-model="data.uname">
    pwoed <input type="text" v-model="data.pword">
    <button @click="data.$patch({uname:'李四',pword:'password'})">批量</button>
  </div>
</template>
<style scoped>
 
</style>
```

# Element-plus

项目构建时需要typescript

组件库

```bash
npm install element-plus
```

全局引入

**main.js**

```js
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
app.use(ElementPlus)
```

# TS

## 接口

在src下面的types文件夹中创建index.ts文件，在其中定义接口，用于约束

```typescript
export interface PersonInter{
    id:string,
    name:string,
    age:number,
    // x是可有可无的
    x?:string
}
```

使用接口

@符号表示src根目录

```typescript
import {type:PersonInter} from '@/types'
let person:PersonInter = {id:'001', name:'jeck', age:10}
let personList:Array<PersonInter> = [
    {id:'001', name:'jeck', age:10},
    {id:'001', name:'jeck', age:10},
    {id:'001', name:'jeck', age:10}
]
```

## 自定义类型

```typescript
export type Persons = Array<PersonInter>
or
export type Persons = PersonInter[]
```

```typescript
import {type:Persons} from '@/types'
let personList:Persons = [
    {id:'001', name:'jeck', age:10},
    {id:'001', name:'jeck', age:10},
    {id:'001', name:'jeck', age:10}
]
```

## 限制类型的reactive

```typescript
import {type:Persons} from '@/types'
import {reactive} from 'vue '
let personList = reactive<Persons>([
    {id:'001', name:'jeck', age:10},
    {id:'001', name:'jeck', age:10},
    {id:'001', name:'jeck', age:10}
])
```

# sass

在 Vue.js 项目中，`sass-loader` 和 `sass`（或 `node-sass`）通常用于处理和编译 Sass 文件。Sass 是一种 CSS 预处理器，它允许使用变量、嵌套规则、混合（mixins）、函数等高级功能来编写更干净、更可维护的 CSS 代码。然后，这些 Sass 文件需要被编译成浏览器可以理解的普通 CSS。

* **sass** (或 **node-sass**): 这是一个库，它将 Sass/SCSS 代码编译成 CSS。`node-sass` 是 `sass` 的一个基于 Node.js 的实现，而纯 `sass` 是一个 Dart 语言的实现，也可以用在 Node.js 环境中，但通常 `node-sass` 更为常用。

* **sass-loader**: 这是一个 webpack 加载器，用于在 webpack 构建过程中处理 Sass 文件。它实际上并不会直接编译 Sass，而是会调用 `sass` 或 `node-sass` 来完成编译工作。`sass-loader` 会在 webpack 的模块系统中找到所有的 `.scss` 或 `.sass` 文件，并将它们编译成 CSS，然后这些 CSS 可以被进一步处理（例如，通过 `css-loader` 和 `style-loader` 将其内嵌到 JavaScript 包中，或直接输出为单独的 CSS 文件）。

在 Vue.js 项目中，可能会这样使用它们：

1. 首先，安装必要的依赖：


```bash
npm install --save-dev sass-loader sass
# 或者使用 node-sass
npm install --save-dev sass-loader node-sass
```
2. 在你的 webpack 配置文件中（通常是 `vue.config.js` 或 webpack 的配置文件），配置 `sass-loader`：


```javascript
module.exports = {
  // ...
  module: {
    rules: [
      // ...
      {
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  }
};
```
3. 在你的 Vue 组件中，你可以这样使用 Sass：


```vue
<style lang="scss">
$primary-color: #333;

.my-class {
  color: $primary-color;
  background-color: lighten($primary-color, 10%);
}
</style>
```
在这个例子中，`$primary-color` 是一个 Sass 变量，`lighten` 是一个 Sass 内置函数。这些都被 `sass-loader` 和 `sass`/`node-sass` 编译成普通的 CSS。

# 插槽

默认插槽：

定义默认slot无需放在template下，使用直接写内容，注意默认插槽一个组件中只能有一个	

```vue
<div class="dialog-body">
    <slot></slot>
</div>

<Dialog title="新增">
    123
</Dialog>
```



具名插槽：

定义带名字的插槽（具名）需要将slot标签包裹在template中，具名slot定义方式如下：

```vue
<template>
	<slot :name="column.scopedSlots">
     </slot>
</template>
```

使用插槽：使用v-slot=“插槽名”或者直接#插槽名

```vue
<template #cover>
	<div>
        123
    </div>
</template>
or
<template v-slot="cover">
	<div>
        123
    </div>
</template>
```

插槽传参给父组件，这里使使用了结构的方式将参数从子组件插槽中传递出来

```vue
<template #default="scope">
    <slot
          :name="column.scopedSlots"
          :index="scope.$index"
          :row="scope.row"
          >
        </slot>
    </template>
<template #cover="{ index, row }">
	<Cover :cover="row.cover"></Cover>
</template>
```

# rules

使用element-ui时，可以使用`:rules`属性对表单内元素内容进行校验

```vue
<el-form :model="formData" :rules="rules" ref="formDataRef">
  <el-form-item prop="account">
    <el-input placeholder="请输入账号" v-model="formData.account" size="large">
      <template #prefix>
        <span class="iconfont icon-account"></span>
      </template>
    </el-input>
  </el-form-item>
  <el-form-item prop="password">
    <el-input placeholder="请输入密码" v-model="formData.password" size="large">
      <template #prefix>
        <span class="iconfont icon-password"></span>
      </template>
    </el-input>
  </el-form-item>
  <el-form-item prop="checkCode">
    <div class="check-code-panel">
      <el-input class="input" placeholder="请输入验证码" v-model="formData.checkCode" size="large" />
      <img :src="checkUrl" alt="网络异常" @click="changeCode">
    </div>

  </el-form-item>
  <el-form-item label="">
    <el-checkbox v-model="formData.rememberMe" :label="true">记住我</el-checkbox>
  </el-form-item>
  <el-form-item label="">
    <el-button type="primary" :style="{ width: '100%' }" size="large" @click="login">登录</el-button>
  </el-form-item>
</el-form>
```

```js
// 输入框公共属性
const rules ={
  account:[{
    required:true,
    message:"请输入账号"
  }],
  password:[{
    required:true,
    message:"请输入密码"
  }],
  checkCode:[{
    required:true,
    message:"请输入验证码"
  }],
}
```

# 标签ref

标签的ref属性可以将标签对象赋给一个ref对象，在js中可以调用，下面的例子是使用了上个知识点中element-ui中的校验功能

```html
<el-form :model="formData" :rules="rules" ref="formDataRef">
...
</el-form>
```

```js
// 表单相关
const formDataRef = ref()
const login = ()=>{
  formDataRef.value.validate((v)=>{
    if(!v){
      return;
    }
  })
}
```

# VueCookies

用于向浏览器中存储cookie

使用：

```js
import VueCookies from "vue-cookies";
VueCookies.set("userInfo",result.data,0);
```

注意这里不要使用结构的方式引入VueCookies，否则引入的是undefind

# :src 模板字符串

```
:src="`/api/file/getImage/${userInfo.avatar}`"
```

# Element+ 全局使用中文

App.vue:

```vue

<template>
 <div>
    <el-config-provider :locale="zhCn">
        <router-view></router-view>
    </el-config-provider>
 </div>
</template>
<script setup>
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
</script>


<style scoped>

</style>

```

# Element+ 表单自定义class custclass

已经弃用，直接使用calss即可

# modelValue

在vue3中，子组件在定义props时，可在其中定义一名为modelValue的对象，该对象为v-model默认接受的值，用法如下：

```vue
// 子组件：
const props = defineProps({
  modelValue: {
    type: String,
    default: null,
  }
});

// 父组件
<CoverUpload v-model="dialogConfig.cover"></CoverUpload>
```

这里v-model绑定的值会自动绑到props中的modelValue上

# v-model与:model的区别

**v-model**

v-model 是 v-model:value 的缩写，通常用于表单上的双向数据绑定（表单接受值 value，故v-model默认收集的就是 value ，所以缩写直接省略 value），可以实现子组件到父组件的双向数据动态绑定。数据不仅能从data流向页面，还可以从页面流向data。

**:model**

:model 是 v-bind:model 的缩写，可以实现将父组件的值传递给子组件，但是子组件不能传给父组件，无法双向绑定。

**v-bind**

v-bind:value 可以简写为 :value ，数据只能从data流向页面。

# nextTick

`nextTick(() => {...});`
Vue 的 `nextTick` 函数用来延迟执行一段代码，直到下一次 DOM 更新循环结束之后。这通常用于在数据改变后确保 DOM 已经更新，然后再执行某些依赖于新 DOM 的操作。

```js
const edit = (type, value) => {
  // 这里让对话框弹出，会更新formData的值，依赖的是:model属性
  // 接着使用formDataRef.value.resetFields()方法清空表单，否则会保留上一次的值
  // :model是element-ui用的，比如使用rule时候
  dialogConfig.ifShow = true;
  nextTick(() => {
    // 要等渲染出来再清空，否则白清空了
    formDataRef.value.resetFields();
    if (type === "add") {
      dialogConfig.title = "新增分类";   
    } else if (type === "update") {
      dialogConfig.title = "修改分类";
      Object.assign(formData, value);
      dialogConfig.cover = value.cover;
    }
    
  });
};
```

# Element+ form rules校验

ref绑定的对象必须是直接在setup下的ref对象

v-bind:model 指向的对象和fome-item的v-model对象必须是包含关系

```vue

<el-form
         :rules="dialogFormRules"
         ref="dialogFormRef"
         :model="dialogFormData"
         >
    <el-form-item label="博客分类" prop="categoryId">
        <el-select
                   v-model="dialogFormData.categoryId"
                   clearable
                   placeholder="请选择分类"
                   :style="{ width: '100%' }"
                   >
        </el-select>
    </el-form-item>
</el-form>
<script>
    const dialogFormRef = ref(null);
const dialogFormRules = {
  categoryId: [{ required: true, message: "请选择分类" }],
  type: [{ required: true, message: "请选择类型" }],
  reprintUrl: [{ required: true, message: "请输入转载地址" }],
  allowComment: [{ required: true, message: "请选择是否允许评论" }],
};
const dialogFormData = reactive({
  tags: [],
});
const dialogConfig = reactive({
  title: "保存博客",
  buttons: [
    {
      type: "danger",
      text: "确定",
      click: async (e) => {
        dialogFormRef.value.validate(async (valid) => {
          console.log(dialogFormData);
          if (valid) {
            return;
          }
        });
      },
    },
  ],
</script>

```

