---
title: jackson
date: 2023-08-27 10:35:19
tags:
  - jackson
categories:
  - 笔记
---

# 参考资料

https://blog.csdn.net/qq_41834086/article/details/111152470

# 序列化与反序列化

实例实体类

```java
package com.example.demo;

public class Person {
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    String username;
    int age;
}
```

序列化与反序列化过程

```java
public static void main(String[] args) throws IOException {
    String json ="{\"username\":\"zhangsan\",\"age\":15}";
    Person person = new ObjectMapper().readValue(json, Person.class);
    new ObjectMapper().writeValue(System.out,person);
}
```

# 定制反序列化

```java
class PersonDeSerializer extends StdDeserializer<Person> {
    
    protected PersonDeSerializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public Person deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException, JacksonException {
        Person person = new Person();
        while (!jsonParser.isClosed()){
            JsonToken jsonToken = jsonParser.nextToken();
            if(JsonToken.FIELD_NAME.equals(jsonToken)){
                String fieldName = jsonParser.getCurrentName();
                System.out.println(fieldName);
                jsonToken = jsonParser.nextToken();
                if("username".equals((fieldName))){
                    person.setUsername(jsonParser.getValueAsString().toUpperCase());
                }
                if("age".equals(fieldName)){
                    person.setAge(jsonParser.getValueAsInt());
                }
            }
        }
        return person;
    }
}

public static void main(String[] args) throws IOException {
        String json ="{\"username\":\"zhangsan\",\"age\":15}";
        ObjectMapper objectMapper = new ObjectMapper();
        SimpleModule simpleModule = new SimpleModule();
        simpleModule.addDeserializer(Person.class,new PersonDeSerializer(Person.class));
        objectMapper.registerModule(simpleModule);
        Person person = objectMapper.readValue(json, Person.class);
        objectMapper.writeValue(System.out,person);
    }
```

# 定制化序列化

```java
class PersonSerializer extends StdSerializer<Person>{

    protected PersonSerializer(Class<Person> t) {
        super(t);
    }

    @Override
    public void serialize(Person person, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeStringField("his name",person.getUsername());
        jsonGenerator.writeStringField("his age",String.valueOf(person.getAge()));
        jsonGenerator.writeEndObject();
    }
}

public static void main(String[] args) throws IOException {
    String json ="{\"username\":\"zhangsan\",\"age\":15}";
    ObjectMapper objectMapper = new ObjectMapper();
    SimpleModule simpleModule = new SimpleModule();
    simpleModule.addSerializer(Person.class,new PersonSerializer(Person.class));
    objectMapper.registerModule(simpleModule);
    Person person = objectMapper.readValue(json, Person.class);
    objectMapper.writeValue(System.out,person);
}
```

# SpringBoot更改@RequestBody参数注入逻辑（参数名映射）

[springboot项目配置参数请求及返回均为下划线方式_springboot responsebody 指定返回的格式 为下划线分割_偶系渣渣灰的博客-CSDN博客](https://blog.csdn.net/breakaway_01/article/details/119033959)

```yaml
spring:
  jackson:
     property-naming-strategy: SNAKE_CASE #下划线参数
```