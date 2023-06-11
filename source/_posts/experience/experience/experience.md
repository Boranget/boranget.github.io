---
title: experience
date: 2023-01-31 16:50:30
tags:
  - 经验
categories:
  - 经验
---

#  JSON

多以fastjson为例

**注意：jdk1.8之前的版本（不包括1.8）需要使用fastjson 1.*的版本，与其后版本不兼容**

## json字符串转为json对象

一个将json字符串转为json对象并将其中的json数组取出并处理的例子

```java
	// 将json字符串转为json对象
    JSONObject originalJsonObject = JSONObject.parseObject(originalJsonString);
    // 获取json数组
    JSONArray array = originalJsonObject.getJSONArray("jsonArray");
    // 遍历处理
    JSONArray targetArray = new JSONArray();
    for (int i = 0; i < array.size(); i++) {
        JSONObject jsonObject = array.getJSONObject(i);
        JSONObject targetJsonObject = getTargetJsonObject(jsonObject);
        targetArray.add(targetJsonObject);
    }
```



## 转义相关

使用fastjson来组装json节点时，如果其中某个节点的值是一个json字符串，在将整个对象转为json字符串后会将该值中的json字符串转义。如下中的orgAttr。

```json
{
  "obj": {
    "orgAttr": "{\"ORD42\":\"String 19\",\"ZHKONT3\":\"String 29\",\"ZKMMS3\":\"String 30\",\"ZHKONT2\":\"String 26\",\"ZKMMS2\":\"String 27\",\"ZHKONT1\":\"String 24\",\"GSBER\":\"String 28\",\"DRFLAG\":\"String 12\",\"ZKMMS1\":\"String 25\",\"SEND_TIME\":\"String 32\",\"ANLKL\":\"String 16\",\"PJTXT\":\"String 11\",\"AFASL\":\"String 21\",\"ZMISTYPE\":\"String 9\",\"ZMISTYPEPRO\":\"String 10\",\"CSKTEXT\":\"String 15\",\"NDPER\":\"String 23\",\"NDJAR\":\"String 22\",\"SEND_DATE\":\"String 31\",\"ANLUE\":\"String 17\",\"KTOGR\":\"String 18\",\"AUFTEXT\":\"String 14\",\"ORD44\":\"String 20\",\"EC_TYPE\":\"String 13\"}",
    "orgCode": "String 8"
  }
}
```

# XML

多以dom4j为例

**注意：jdk1.8之前的版本（不包括1.8）需要使用dom4j 2.0.*的版本，与其后版本不兼容**

## 无中生有

逐个节点构建一个xml结构,并导出为字符串

```jsva
Document document = DocumentHelper.createDocument();
Element rootElement = document.addElement("ROOT");
Element empId = rootElement.addElement("ID");
empId.setText("2021");
Element empCode = rootElement.addElement("CODE");
empCode.setText("200");
Element empTime = rootElement.addElement("TIME");
empTime.setText(time);
String xmlStr = document.asXML().toString();
```

## xml字符串转为xml对象

```java
Document dom =DocumentHelper.parseText(xmlStr);
Element root=dom.getRootElement();
String id = root.element("ID").getText();
String code = root.element("CODE").getText();
String message = root.element("MESSAGE").getText();
```

## 通过xpath获取节点

```java
Document document = ....; 
List<Node> nodes = document.selectNodes("//nodeName");
```

路径前带双斜杠为从寻找整个文档中所有的name为"nodeName"的节点

路径前带单斜杠为在根节点下寻找某节点

```jsva
for (Node node : nodes) {
    ......
    String s = node.selectSingleNode("rn5:id").getText();
    .............
}
```

路径前不带斜杠为在当前调用node下寻找某节点.

**注意**: 如果在selectSingleNode方法中传入了双斜杠表达式,他会寻找整个文档中第一个名称为nodeName的节点返回

可添加 | 表示多个xpath

## 命名空间问题

带命名空间的xml字符串转为dom对象, 并且在寻找节点时要带命名空间

```java
		
 private static Document getDocumentFromXmlWithNameSpace(String xmlRes) {
        Map<String, String> xmlMap = new HashMap<>();
		// 将所有命名空间加入此map
        xmlMap.put("rn0", "urn:java.lang");
        xmlMap.put("rn2", "urn:com.sap.aii.mdt.api.data");
        ...............
        SAXReader reader = new SAXReader();
        reader.getDocumentFactory().setXPathNamespaceURIs(xmlMap);
        Document document = null;
        try {
            byte[] bytes = xmlRes.getBytes();
            document = reader.read(new ByteInputStream(bytes, bytes.length));
        } catch (DocumentException e) {
            e.printStackTrace();
        }
        return document;
}

```

# Base64

## jdk8之前commons-codec1.3

### 编码

```java
	static String base64Encode(String needEncodeStr){
        String base64encodedString = null;
        try {
            Base64 base64 = new Base64();
            byte[] encode = base64.encode(needEncodeStr.getBytes("utf-8"));
            base64encodedString = new String(encode);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return  base64encodedString;
    }
```

### 解码

```java
    static String base64Decode(String needDecodeStr){
        Base64 base64 = new Base64();
        byte[] base64decodedBytes;
        String res = null;
        try {
            base64decodedBytes = base64.decode(needDecodeStr.getBytes("utf-8"));
            res = new String(base64decodedBytes, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return  res;
    }
```

## jdk8开始自带工具

### 编码

```java
    static String base64Encode(String needEncodeStr){
            String base64encodedString = null;
            try {
                base64encodedString = Base64.getEncoder().encodeToString(needEncodeStr.getBytes("utf-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            return  base64encodedString;
    }
```



### 解码

```java
    static String base64Decode(String needDecodeStr){
        byte[] base64decodedBytes = Base64.getDecoder().decode(needDecodeStr);
        String res = null;
        try {
            res = new String(base64decodedBytes, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return  res;
    }

```

# Fegin

## Fegin传输文件MultipartFile

### 上传文件

报错org.springframework.web.multipart.MultipartException:Current request is not a multipart request

the request was rejected because no multipart boundary was found

解决:

```java
@ApiOperation("上传一个文件")
@RequestMapping(value = "/file/uploadfile", method = RequestMethod.POST, consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public CommonResult fileupload(@RequestPart MultipartFile uploadfile, @RequestParam String bucket,
                               @RequestParam(required = false) String objectName);
```

其中 consumes = MediaType.MULTIPART_FORM_DATA_VALUE 解决"Current request is not a multipart request"

@RequestPart MultipartFile uploadfile 解决"the request was rejected because no multipart boundary was found"

### 下载文件

feignClient：

```java
@ApiOperation("下载一个文件")
    @RequestMapping(value = "/file/downloadFile", method = RequestMethod.GET)
    public Response downloadFile(@RequestParam String bucket, @RequestParam String objectName);
```

注意返回值不是void而是一个feign包中的Response类

controller:

```java
 Response feignResponse = fileService.downloadFile(BUCKET_NAME,objectName);
InputStream inputStream = feignResponse.body().asInputStream();
```

# SpringBoot系列

## 默认包扫描

springboot默认扫描启动类所在包以及其下的包,如果引入了另一个项目,但是零一项目中组件所在的包的包名在以上范围,则可扫描成功.

如果另一项目中所需组件不在该范围,可在启动类上进行配置

需要注意,配置扫描别的包,默认配置会失效,所以注意要把当前包加上

```java
@SpringBootApplication(scanBasePackages = {"com.orrangee","com.orange"})
```

## 自定义一个starter

可以实现自动配置,其实就是把别的项目中的bean自动装配进来

这里需要理解spring的自动装配原理

[SpringBoot 自动装配原理详解 | JavaGuide(Java面试+学习指南)](https://javaguide.cn/system-design/framework/spring/spring-boot-auto-assembly-principles.html#autoconfigurationimportselector-加载自动装配类)

首先,springboot在启动时会扫描外部引用jar包中的**META-INF/spring.factories**文件

> org.springframework.core.io.support.SpringFactoriesLoader#loadSpringFactories用于加载所有的META-INF/spring.factories文件

![image-20230131151506098](experience/image-20230131151506098.png)

以如下作为父项目以控制版本

```xml
 <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.6.11</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
```

引入依赖:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
</dependency>
```

这里复制一波条件选择

- `@ConditionalOnBean`：当容器里有指定 Bean 的条件下
- `@ConditionalOnMissingBean`：当容器里没有指定 Bean 的情况下
- `@ConditionalOnSingleCandidate`：当指定 Bean 在容器中只有一个，或者虽然有多个但是指定首选 Bean
- `@ConditionalOnClass`：当类路径下有指定类的条件下
- `@ConditionalOnMissingClass`：当类路径下没有指定类的条件下
- `@ConditionalOnProperty`：指定的属性是否有指定的值
- `@ConditionalOnResource`：类路径是否有指定的值
- `@ConditionalOnExpression`：基于 SpEL 表达式作为判断条件
- `@ConditionalOnJava`：基于 Java 版本作为判断条件
- `@ConditionalOnJndi`：在 JNDI 存在的条件下差在指定的位置
- `@ConditionalOnNotWebApplication`：当前项目不是 Web 项目的条件下
- `@ConditionalOnWebApplication`：当前项目是 Web 项 目的条件下

整体配置类

```java
@Configuration
public class DrinkerConfiguration {
    /**
     * ConditionOnProperty用于控制该Bean是否引入
     * starter.orange是前缀
     * enabled是值的key
     * 在引用项目中这样配置
     * starter.orange.enabled=false
     * 这里会判断enabled的值,如果说true,则进行装载,否则不装载
     * matchIfMissing是默认,这里默认true,也就是默认装载
     * @return
     */
    @Bean
    @ConditionalOnProperty(prefix = "starter.orange",value = "enabled", matchIfMissing = true)
    public Drinker drinker(){
        return new Drinker("milker");
    }
}

```

一个测试的实体类

```java
public class Drinker {
    private String name;

    public Drinker(String name) {
        this.name = name;
    }

    public void drink(){
        System.out.println("drinker "+name+" is drinking");
    }
}
```



spring.factories配置

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.starter.orange.DrinkerConfiguration
```

其中第一行表示下面的配置是配置类

第二行是要装载的配置

**测试**

```java
@Autowired(required = false)
Drinker drinker;
@GetMapping("/getA")
public String a(){
    drinker.drink();
    return "hello";
}
```

```
drinker milker is drinking
```

成功加载

## FeignClient

1. 依赖

2. ```java
   @FeignClient(value = "orange-frame-rbac")
   ```

3. ```
   @EnableFeignClients
   ```

# 自适应ContentType

微信小程序需要根据下载文件接口返回的ContenType请求头来解析文件

```java
// 根据下载的文件名获取文件类型
        Optional<MediaType> mediaType = MediaTypeFactory.getMediaType(objectName);
        String contentType = mediaType.orElse(MediaType.APPLICATION_OCTET_STREAM).toString();
        response.setContentType(contentType);
```

# http 401

碰到一种情况,使用postman可以正常调用的一个接口, 在代码中使用okhttp调用时,出现了401的问题,最后将请求地址改为https协议(之前是http)后,访问成功,经过资料查找,认为应该是如下原因:

**有防御性的安全策略**

简单来说就是， 来自一个知名浏览器的 HTTP 通讯是允许的， 但来自其他系统的自动通讯则被拒绝， 并生成 401 错误代码。这是一种异常情况， 但是也许表明您的 Web 服务器周围 采取了非常具有防御性的安全策略。

# java中对象的相互引用问题

在java中是允许对象之间的相互引用的,如:

```java
@Data
class A{
    B b;
}
@Data
class B{
    A a;
}
public static void main(String[] args) {
        A a = new A();
        B b = new B();
        a.b = b;
        b.a = a;
        // System.out.println(a);
}
```

相互引用是没问题的,但如果要对其进行序列化, 如使用lombok+sout,或者使用json工具将其中一个对象序列化时,便会因为递归次数太多而发生stackoverflow异常

![image-20230131101837736](experience/image-20230131101837736.png)

所以在使用序列化时,需要注意该对象内有无递归引用

# nginx

## 配置文件编码格式问题

Nginx:[emerg] unknown directive ” ” in/usr/local/nginx/conf/nginx.conf:3

有可能是配置文件的编码格式变成了bom utf-8，需要改回utf-8

# 方法的重写

静态方法不可被重写

允许的是：在子类中定义一个与父类中同名的静态方法，但当指定一个子类实例赋值给父类变量时，调用该变量的静态方法，执行还是父类中的静态方法

# sql

mysql中delete语句可以使用别名

方法为：

```sql
delete r from role r WHERE r.id=5
```



# java调用python

```java
@RestController
public class CallPythonController {
    @RequestMapping("/call")
    public String call(@RequestParam int a,@RequestParam int b){
        StringBuilder stringBuilder = new StringBuilder();

        try {
            String[] args1 = new String[] { "py", "E:\\my_file\\study\\java_invoke_python\\testPy.py", String.valueOf(a), String.valueOf(b) };
            Process proc = Runtime.getRuntime().exec(args1);// 执行py文件
            BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = null;
            while ((line = in.readLine()) != null) {
                System.out.println(line);
                stringBuilder.append(line);
            }
            in.close();
            proc.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }finally {
            return stringBuilder.toString();
        }
    }
}
```

```python
import sys
 
def func(a,b):
    return (a+b)
 
if __name__ == '__main__':
    a = []
    for i in range(1, len(sys.argv)):
        a.append((int(sys.argv[i])))
 
    print(func(a[0],a[1]))
```

# lambda

lambda表达式中不允许使用非final的变量

或者引用非final变量之后不允许对其值做修改

>Variable used in lambda expression should be final or effectively final

# Maven

maven编译会将resource中的内容编译到target中的classes下的根目录

但默认不会将java文件夹中的非java文件编译

# 线程不安全问题

2023/4/3

在一个项目中，有个job服务，还有一个业务服务A

在job服务中通过feign远程去调用A中的一个方法，该方法会进行数据库的更新操作

该更新操作步骤为

删除旧数据->插入新数据

问题:

A中的该业务用时很长,导致job这边feign中超时,feign采取了重试操作,重新发送了一次请求

导致实际上第一次业务线程还没有跑完,但第二次业务开始,第二次业务会删除第一次业务已经插入的数据,但接下来两次业务会同时进行,导致数据库中的数据为第一次业务插入的数据与第二次插入的数据.

解决:

将业务代码抽离到service层中,添加synchronized关键字

# 带T和+08:00格式的时间转换

```java
String origin = "2023-04-06T13:57:00.029+08:00";
LocalDateTime date = LocalDateTime.parse(origin, DateTimeFormatter.ISO_OFFSET_DATE_TIME);
Instant instant = date.toInstant(java.time.ZoneOffset.UTC);
// 获取时间戳
long timestamp = instant.toEpochMilli();
// format
date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
```



