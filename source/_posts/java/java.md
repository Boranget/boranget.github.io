---
title: java
date: 2023-2-23 16:50:30
updated: 2024-02-22 10:35:19
tags:
  - java基础
categories:
  - 笔记
---

# 内部类相关

## 静态与非静态的底层

待研究

- 静态内部类可以在除外部类以外的类中实例化，比如Builder模式
- 非静态的内部类只能在外部类中实例化，且只能在非静态方法中实例化，
- 非静态内部类可以声明静态变量，也可以在静态块中被声明，但无法同时被实例化
- 内部接口默认都是静态的且必须是静态的

## 匿名内部类和局部变量的关系

lambda的实现与匿名内部类有关系，简单地说，匿名内部类可能会比它所在的方法的存活时间还长，这样的话，他想要调用的局部变量会因为方法的结束出栈而消失，则会出现问题，故如果需要使用局部变量，需要是final的（如果不是final，编译器在编译的时候会变为final，如果在匿名内部类使用之后对该变量做修改，则编译不通过），这样匿名内部类会复制一份改局部变量与自己共同存活。

## 内部类的访问修饰符

private修饰的内部类及其中嵌套的private内部类能且只能在其所属的外部类及其包含的所有内部类中访问

```java
@Component
public class TreeService {
    public static FileTree fileTree;
    private class FileTree {
        private class FileTreeNode{

        }
    }
    private class F{
        private class FF{
            FileTree fileTree = new FileTree();
        }
        FileTree fileTree = new FileTree();
    }
}

```



# Builder模式

```java
public class OtherTest {
    public static void main(String[] args) {
        A.ABuilder aBuilder = new A.ABuilder();
        A jeck = aBuilder.age(11).name("jeck").build();
        System.out.println(jeck);
    }
}

class A {
    private int age;
    private String name;
    private A() {

    }
    private A(int age, String name) {
        this.age = age;
        this.name = name;
    }

    @Override
    public String toString() {
        return "A{" +
                "age=" + age +
                ", name='" + name + '\'' +
                '}';
    }

  
    public static final class ABuilder {
        private int age;
        private String name;

        public ABuilder age(int age) {
            this.age = age;
            return this;
        }

        public ABuilder name(String name) {
            this.name = name;
            return this;
        }

        public A build() {
            return new A(this.age, this.name);
        }

    }
}

```

# 反射相关

## 获取私有构造器生成实例

```java
/**
 * @author boranget
 * @date 2023/2/23
 * 注意私有的构造器需要通过 getDeclaredConstructor方法获取
 * 且需要设置访问权限之后才能生成实例
 */
public class OtherTest {
    public static void main(String[] args) {
        Class<A> aClass = A.class;
        A a = null;
        Constructor<A> constructor = null;
        try {
            constructor = aClass.getDeclaredConstructor(int.class, String.class);
            constructor.setAccessible(true);
            A jeck = constructor.newInstance(11, "jeck");
            System.out.println(jeck);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }


    }
}

class A {
    private int age;
    private String name;

    private A() {

    }

    private A(int age, String name) {
        this.age = age;
        this.name = name;
    }

    @Override
    public String toString() {
        return "A{" +
                "age=" + age +
                ", name='" + name + '\'' +
                '}';
    }
}
```

# Optional

身为一个容器，将对象引用存入其中，用于缓解该引用为null时的报错，减少空指针异常产生的情况。

# 函数式接口

仅有一个抽象方法的接口，通常会添加@FunctionalInterface的注解

一般是供lambda表达式使用

```java
public class Test {
    public static void main(String[] args) {
        final int res = getRes((a, b) -> {
            return a * b;
        });
        System.out.println(res);
        final int res2 = getRes((a, b) -> {
            return a + b;
        });
        System.out.println(res2);

    }
    static int getRes(Fun f){
        int a = 2,b=3;
        return f.getRes(a,b);
    }
}
@FunctionalInterface
interface Fun{
    int getRes(int a, int b);
}
```

# 流式编程

将数据包装到stream中后使用Stream的一系列操作进行编程，优点是编程很丝滑，缺点是后期不方便阅读

## filter

进行数据筛选

```java
public static void main(String[] args) {
    List<String> l = new ArrayList();
    l.add("a");
    l.add("b");
    l.add("v");
    l.add("df");
    l.add("df");
    l.add("r");
    System.out.println(l);
    final List<String> a1 = l.stream().filter(a -> !a.equals("a")).collect(Collectors.toList());
    final Set<String> a2 = l.stream().filter(a -> !a.equals("a")).collect(Collectors.toSet());
    System.out.println(a1);
    System.out.println(a2);
}
```

## map

将一个集合映射成另一个集合

```java
 final List<String> collect = l.stream().map(a -> "[ " + a + " ]").collect(Collectors.toList());
```

## collect

流操作的结束操作，其结果为生成一个集合，生成list和set的方法如上，这里写一下生成map的方法。

```java
final Map<String, String> collect = l.stream().collect(Collectors.toMap(a -> a.substring(0,1), a -> a));
```

## match

同样的流操作的结束操作，结果为生成一个布尔值，判断原数据集是否满足某个要求

- anyMatch：判断的条件里，任意一个元素成功，返回true

- allMatch：判断条件里的元素，所有的都是，返回true

- noneMatch：与allMatch相反，判断条件里的元素，所有的都不是，返回true

```java
final boolean va = l.stream().anyMatch(a -> a.equals("va"));
```

## sort

使用流sort不会修改原集合，需要最后收集为一个新集合，如果使用Collections则会修改原集合。

```java
Collections.sort(l, (a, b) -> {
    if (a.length() != b.length()) {
        return a.length() - b.length();
    }
    for (int i = 0; i < Math.min(a.length(), b.length()); i++) {
        if (a.charAt(i) != b.charAt(i)) {
            return a.charAt(i) - b.charAt(i);
        }
    }
    return 0;
});
System.out.println(l);
final List<String> collect = l.stream().sorted((a, b) -> {
    if (a.length() != b.length()) {
        return a.length() - b.length();
    }
    for (int i = 0; i < Math.min(a.length(), b.length()); i++) {
        if (a.charAt(i) != b.charAt(i)) {
            return a.charAt(i) - b.charAt(i);
        }
    }
    return 0;
}).collect(Collectors.toList());
System.out.println(collect);
```

使用另一种lambda

```java
public static void main(String[] args) {
    List<String> l = new ArrayList();
    l.add("aa");
    l.add("ba");
    l.add("va");
    l.add("df");
    l.add("ra");
    System.out.println(l);
    Collections.sort(l,Test::sort);
    System.out.println(l);
    final List<String> collect = l.stream().sorted(Test::sort).collect(Collectors.toList());
    System.out.println(collect);
}
static int sort(String a, String b){
    if (a.length() != b.length()) {
        return a.length() - b.length();
    }
    for (int i = 0; i < Math.min(a.length(), b.length()); i++) {
        if (a.charAt(i) != b.charAt(i)) {
            return a.charAt(i) - b.charAt(i);
        }
    }
    return 0;
}
```

使用Comparator中带的比较器

```java
final List<String> collect = l.stream().sorted(Comparator.reverseOrder()).collect(Collectors.toList());
```

## findfirst...

寻找流中的第一个元素，返回一个Optional

## Collectors

收集器

- toList
- toMap
- 。。。
- join
    类似于js中数组的join

# Comparator

比较器

```java
Comparator.comparing(Student::getName); 
```

# super与this关键字

[Java中super关键字及super()的使用_java super-CSDN博客](https://blog.csdn.net/pipizhen_/article/details/107165618)

this关键字可以当作一个变量，其地址指向当前对象，而super只是一个调用父类特征的入口，注意是父类特征而不是父类对象。这是因为父类的特征已经在子类中存在了，且super不像this会指向一个实例，这也就造成this可以当作一个对象输出super不可以，因为super不是一个整体。

## this关键字

- this可以出现在实例方法和构造方法中
- this的语法有this.和this()
- this不能出现在静态方法中，因为静态方法没有实例
- this大部分情况可以省略
- this在区分实例变量与局部变量时不可省略
- this()只能出现在构造方法的第一行，通过当前的构造方法去调用当前类中与之对应的构造方法。

## super关键字

super指向直接父类的特征，比如直接父类的实例变量或者实例方法，如果直接父类没有该名称的特征则会顺着继承链向上查找。

- siper能出现在实例方法和构造方法中
- super的语法有super.和super()
- super不能出现在静态方法中，原因同上
- 大多数情况下可以省略
- 当前类想访问父类的某个特征但是该特征在当前类中也有同名特征存在时，则需要使用super关键字进行指定
- super()方法只能出现在构造方法的第一行，目的是为了在创建子类对象时先初始化父类特征，如果不手动调用也会自动隐式调用。**当子类的构造方法内第一行没有出现“super()”时，系统会默认给它加上无参数的"super()"方法构造，如果父类中没有指定无参构造则会编译不通过。且构造方法中“this()”和“super()”不能同时出现，也就是“this()”和“super()”都只能出现在构造方法的第一行。**

# 泛型相关

## 泛型的继承关系

当一个方法声明接收一个参数为Object\<T\>时，其中的T必须传当前泛型类中指定的类实例，不能传该类的子类

```java
default T selectOne(@Param("ew") Wrapper<T> queryWrapper) {
    return this.selectOne(queryWrapper, true);
}
```

## 泛型动态返回实例

```java
/**
 * 将系统用户转换为Authing用户
 * CreateUserInfoDto 与 CreateUserReqDto 功能类似，字段相同
 * 抽象出来避免后期要存入多个字段需修改多处
 * 
 * @param sysUser
 * @return
 */
private <T> T assignSysUserToAuthingUser(User sysUser, Class<T> clz) {
    T authingUser = null;
    try {
        authingUser = clz.getDeclaredConstructor().newInstance();
        clz.getMethod("setUsername",String.class).invoke(authingUser, sysUser.getUsername());
        clz.getMethod("setPhone",String.class).invoke(authingUser, sysUser.getMobile());
        // 猜测这里设置为true就可以直接用手机号登录了
        clz.getMethod("setPhoneVerified",Boolean.class).invoke(authingUser, true);
    } catch (InstantiationException | NoSuchMethodException | InvocationTargetException |IllegalAccessException e) {
        throw new RuntimeException(e);
    }
    return authingUser;
}
```



# IO

## ByteArrayOutputStream

可以用该输出流来写入内容，且该流最后可转为byte数组:`ByteArrayOutputStream.toByteArray()`

## 无法同时打开一个文件的输入流和输出流

否则该文件会损坏，建议使用copy方式

# 双冒号

用于“方法引用”，用法

```java
ClassName::methodName
```

- 静态方法引用

    碰到参数重载时，根据上下文推断参数类型去创建对应的函数式接口实例

- 实例方法引用

    lambd表达式中调用某个实例的某个方法，可以简化为使用`该实例所属的类::该方法`

# 正则匹配

创建Pattern并指定正则表达式，在正则表达式中，使用小括号`()`标识子表达式

子表达式可通过使用`matcher.group`指定序号获取，0为整个表达式匹配的内容

若整个正则表达式匹配到了内容，则find会返回true

`.*`与`.*?`的区别：带问号为非贪婪匹配，会尽可能匹配更少的字符，而不带问号为贪婪匹配，会尽量匹配更多的字符

```java
public class MatcherTest {
    public static void main(String[] args) {
        String currentLine = "123456![image-20240422144249123](TestManual/image-20240422144249123.png)-(123)123456()";
        // group2 为 123)123456(
//        Pattern pattern = Pattern.compile("!\\[.*\\]\\((.*?)\\).*\\((.+)\\)");
        // group2 为 123
        Pattern pattern = Pattern.compile("!\\[.*\\]\\((.*?)\\).*\\((.+?)\\)");
        Matcher matcher = pattern.matcher(currentLine);
        if (matcher.find()) {
            System.out.println(matcher.group(0));
            System.out.println(matcher.group(1));
            System.out.println(matcher.group(2));
        }
    }

}
```

# 删除文件夹

```java
public void deleteDir(String filePath) {
    // 删！
    File file = new File(filePath);
    Stack<File> fileStack = new Stack<>();
    fileStack.push(file);
    while (!fileStack.isEmpty()) {
        File currentFile = fileStack.pop();
        if (currentFile.isDirectory()) {
            File[] fileArray = currentFile.listFiles();
            if (fileArray.length == 0) {
                currentFile.delete();
                continue;
            }
            // 如果文件夹不空，需要先删文件夹内容再删文件夹
            // 将文件夹先存回去
            fileStack.push(currentFile);
            // 将文件夹内容加入栈中
            fileStack.addAll(Arrays.stream(fileArray).toList());
            continue;
        }
        currentFile.delete();
    }
}
```

# java原生发送http请求

```java
private String getRequest() throws IOException {
		String target = "http://17.28:50000/nwa";
		URL url = new URL(target);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
		// con.connect()
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuffer content = new StringBuffer();
        while ((inputLine = in.readLine()) != null) {
            content.append(inputLine);
        }
        in.close();
        con.disconnect();

        return (content.toString());

	}
```

可以不通过connect()方法来建立连接，因为getOutputStream()方法会隐式的进行connect。

使用方法 `HttpURLConnection.setFollowRedirects(false);`来禁用重定向，从而获取中间结果

# try后跟括号

在java1.7后，可以将实现了AutoCloseable的资源写在try后的括号中，在离开该范围后，会自动关闭资源：

```java
try (InputStream keyStoreData = new FileInputStream(jksFilePath)) {           // Path for jks
    KeyStore keyStore = KeyStore.getInstance("JKS");
    keyStore.load(keyStoreData, keyStorePassword);
    return safeHttpsBuilder(keyStore, password, HttpClients.custom()).build();
}
```

# 非静态代码块

已知静态代码块在编译后会有一个static 的init方法

而非静态代码块在编译后会编织到当前类每个构造方法中，并在构造方法的具体逻辑之前执行

# 包装类

## intvalue

Long类型的包装类中，有个intvalue方法，可返回对应的int类型值

## map

在包装类做key的情况下，比较的是对象的地址而非值

比如Integer做key，key为3，此时如果用get(3L)的话是取不到的，因为3L是个Long类型