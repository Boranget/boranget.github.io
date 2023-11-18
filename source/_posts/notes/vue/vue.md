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

响应式数据是指在变量的数据变化之后，页面渲染的数据会随着变量改变

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

# 路由守卫

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

# promise

**回调函数**

回调函数是基于事件的自动调用函数，其他的代码不会等待回调函数执行完毕，异步的

回调函数是一种未来会执行的函数，回调函数以外的其他代码不会等这个函数的执行结果就会执行下去

回调函数相当于一种承诺，有三种状态

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
// 回调函数可接收两个参数
// resolve 和 reject 参数是函数，再回调函数中调用可改变当前promise的状态
let promise = new Promise(function(resolve,reject){});
// then方法会在promise对象的状态发生改变后执行
// then中传入两个参数，分别为两个方法
// 第一个方法为状态转为resolved时会执行的函数
// 第二个方法为状态转为reject时会执行的代码
promise.then()
// promise中的函数会在promise声明时执行
// then方法会等待promise中的方法执行结束执行，then下方的方法不会等待then执行完成，但会等待promise代码执行完成
promise.then(
    function(){
        console.log(resolve);
    }
    ,function(){
        console.log(reject);
    }
)
// resolve与reject函数可以传入参数，then中的回调函数中接收
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
// then方法会返回另一个Promise，可调用该对象的catch函数
// catch函数当promise中的回调函数报错或promise状态为reject的时候执行
// 可接参数，其值为回调函数中reject填入的值或者异常信息
// 所以如果有catch处理的话，then中的第二个方法可以去掉
let promise2 = promise.then(
    function(value){
        console.log(value);
    }
)
promise2.catch(function(){})
// 可连写
promise.then(
    function(value){
        console.log(value);
    }
).catch(function(value){
    console.log(value);
})
```

## async

```js
async function a(){
    
}
// 箭头
let a = async ()=>{}
```

async 所标识的函数会被封装为一个返回结果是一个pomise对象的函数，方法体则是Promise对象声明时所接收的回调函数

如果在a函数中返回结果，则该promise的状态会变为Resolved，返回的结果会放入resolve的参数中，

如果在a函数中抛出异常，则该promise的状态会变为Rejected，异常信息放入reject的参数中。

如果a函数return了一个promise对象，则该promise就是这个promise

```js
let promise = a();
promise.then().catch()
```

## await

用于快速获取promise成功状态下的返回值，只能在async修饰的方法中使用

如果await操作的promise返回异常，则，await操作会抛出异常

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

# Axios

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

# pinia

pinia中可以直接定义数据，默认是响应式的，多个vue文件可从中获取