---
title: fastjson
date: 2023-09-21 10:35:19
tags:
  - fastjson
categories:
  - 笔记
---

# 参考资料

https://alibaba.github.io/fastjson2/spring_support_cn.html

# spring框架集成fastjson2

fastjson2在集成到spring框架时，引用的模块应该是fastjson-extension

且fastjson针对不同版本的springboot版本做了不同的封装

```xml
<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2-extension-spring5</artifactId>
    <version>2.0.40</version>
</dependency>

or

<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2-extension-spring6</artifactId>
    <version>2.0.40</version>
</dependency>
```



# fastjson做默认序列化器进行参数接收

```java
@Configuration
@EnableWebMvc
public class WebMvcConfigurer extends WebMvcConfigurerAdapter {

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        FastJsonHttpMessageConverter converter = new FastJsonHttpMessageConverter();
        //自定义配置...
        FastJsonConfig config = new FastJsonConfig();
        config.setDateFormat("yyyy-MM-dd HH:mm:ss");
        config.setReaderFeatures(JSONReader.Feature.FieldBased, JSONReader.Feature.SupportArrayToBean);
        config.setWriterFeatures(JSONWriter.Feature.WriteMapNullValue, JSONWriter.Feature.PrettyFormat);
        converter.setFastJsonConfig(config);
        converter.setDefaultCharset(StandardCharsets.UTF_8);
        converter.setSupportedMediaTypes(Collections.singletonList(MediaType.APPLICATION_JSON));
        converters.add(0, converter);
    }
}
```

# 下划线json请求体匹配驼峰变量名

**添加智能匹配的Feature**

将json字符串塞入实体类

```java
JSONObject.parseObject(Files.readString(path), clazz, Feature.SupportSmartMatch);
```

全局修改，@RequestBody自动注入

```
@Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        FastJsonHttpMessageConverter converter = new FastJsonHttpMessageConverter();
        //自定义配置...
        FastJsonConfig config = new FastJsonConfig();
        config.setDateFormat("yyyy-MM-dd HH:mm:ss");
        config.setReaderFeatures(JSONReader.Feature.FieldBased, JSONReader.Feature.SupportArrayToBean, JSONReader.Feature.SupportSmartMatch);
        config.setWriterFeatures(JSONWriter.Feature.WriteMapNullValue, JSONWriter.Feature.PrettyFormat);
        converter.setFastJsonConfig(config);
        converter.setDefaultCharset(StandardCharsets.UTF_8);
        converter.setSupportedMediaTypes(Collections.singletonList(MediaType.APPLICATION_JSON));
        converters.add(0, converter);
    }
```

# 字段序列化映射

```java
/在实体类的get方法中加上@JSONField注解，注解里面标识了需要转换成json格式字符串的字段名
@JSONField(name ="Lifnr")
public String getLifnr() {
    return Lifnr;
}
```

# 常用方法

- 对象转为json字符串：JSON.toJSONString(Object object)

    ```java
    // 若需要保留null值
    JSON.toJSONString(saveExportDto, String.valueOf(SerializerFeature.WriteMapNullValue));
    ```

- json字符串转为JSONObject对象：JSON.parseObject(String string)

    