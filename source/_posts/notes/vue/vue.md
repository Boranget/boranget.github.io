---
 title: Vue
date: 2023-11-11 14:50:30
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

```js
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

共享css样式写入一个css文件中

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

# 响应式数据

在vue2中，数据默认就是响应式的，但在vue3中，数据需要经过ref/reactive函数的处理.

ref函数更适合单个字面量

reactive更适合对象

## ref

在script标签中，ref响应数据需要通过.value的方式操作数据，但在template标签中使用ref数据不需要。

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

- toRef/toRefs 将reactive种的某个属性或者多个属性转为ref响应数据

    ```vue
    let age = toRef(person, "age")
    let {age, name} = toRefs(person)
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

- 命令必须以来标签且必须在开始标签中使用

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

直接将方法事件写到时间渲染命令种

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

- .once 只绑定一次

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

v-for 需要注意要定义key，建议使用属性id

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
- 计算属性会判断计算属性依赖的数据有无发生变化，如果没变化则使用上一次计算的结果

```vue
import { computed } from "vue";
let count = computed(()=>{
	return carts.length;
})
```

# 数据监听器

监听数据发生改变

## watch

监听ref值

 ```vue
<script setup>
  import { reactive, ref, watch } from "vue";
  let count = ref("");
  watch(count, (newValue,oldValue)=>{
    console.log(oldValue,"->",newValue);
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

监听reactive中的一个值

```vue
<script setup>
  import { reactive, ref, watch } from "vue";
  let count = reactive({});
  // 需要将会变化的值以返回值的形式作为第一个参数
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

监听某个对象中的所有值是否变化，deep设为true进行深度监听

```vue
<script setup>
  import { reactive, ref, watch } from "vue";
  let count = reactive({});
  // 需要将会变化的值以返回值的形式作为第一个参数
  watch(()=>count, ()=>{
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

除了{deep:true}之外，其中还可添加{immediate:true}：在页面加载完成后立即执行（使用初始值）

## watchEffect

任何响应式数据变化都会触发，但前提是该数据在watchEffect方法中有用到

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

navigator

```vue
<script setup>
 // degineEmits用于定义向父组件提交数据的事件以及正式的提交数据
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
App

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
    <!-- msg为自定义名称的传递给子组件的信息 -->
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
Content

```vue
<script setup>
import { defineProps } from "vue";
// msg 为父组件给子组件加上的属性名，String为属性值的类型
defineProps({ msg: String });
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

通过当前地址栏的路径切换vue组件

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
    <!-- 该标签会被替换为具体的vue -->
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

## 路径跳转组件

```vue
<router-link to="/add">add</router-link>
```

## 重定向

```js
{
    path:"/update",
    // 注意这里是重定向的地址而不是组件
    redirect:"/list"
}
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

