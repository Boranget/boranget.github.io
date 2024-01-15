---
title: Redis
date: 2022-12-29 16:50:30
tags:
  - redis
categories:
  - 笔记
---

# RedisTemplate

## 使用

spring默认提供的redisTemplate并不好用，这里使用自定义的RedisTemplate\<String, Object\>

### redis连接

```yml
spring:
  redis:
    database: 0
    host: 127.0.0.1
    port: 6379
    connect-timeout: 1000
```



### redis配置

```java
// 这里的Configuration是为了使下面的@Bean生效
@Configuration
public class RedisConfig {
    @Bean(name = "myTemplate")
    public RedisTemplate<String,Object> template(RedisConnectionFactory factory){
        // 要返回的对象初始化
        RedisTemplate<String ,Object> template = new RedisTemplate<>();
        // 设置工厂,这里的工厂对象spring会自动注入
        template.setConnectionFactory(factory);

        // 从这里开始是json序列化器的配置
        Jackson2JsonRedisSerializer<Object> jackson2JsonRedisSerializer
                = new Jackson2JsonRedisSerializer<Object>(Object.class);
        ObjectMapper om = new ObjectMapper();
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        // 以下两条为指定序列化内容
        // 已过期方法
        // 这里必须指定,否则反向序列化结果是map
//        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        om.activateDefaultTyping(LaissezFaireSubTypeValidator.instance,ObjectMapper.DefaultTyping.NON_FINAL);
        // 序列化器设置om
        jackson2JsonRedisSerializer.setObjectMapper(om);
        // 初始化一个字符串的序列化器
        StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringRedisSerializer);
        template.setValueSerializer(jackson2JsonRedisSerializer);
        template.setHashKeySerializer(stringRedisSerializer);
        template.setHashValueSerializer(jackson2JsonRedisSerializer);
        template.afterPropertiesSet();
        return template;
    }
}
```



### 调用

```java
 @Autowired
    RedisTemplate<String,Object> myTemplate;


@GetMapping("/factory")
    public Object factoryInfo() throws JsonProcessingException {
        ValueOperations<String, Object> stringObjectValueOperations = myTemplate.opsForValue();

        Student student = new Student();
        student.setName("掌上");
        student.setAge(18);
        student.setGender("男");
        student.setStudentNum("201806010145");
        stringObjectValueOperations.set("ms",student);
        Object value = stringObjectValueOperations.get("ms");
        System.out.println(value);


       return value;
    }
```

# EnableRedisRepositories

## 使用

### 实体类配置

指定实体类中的id,并将实体类加@RedisHash("student")的注解,将会以student:id为key的方式存入redis

```java
@RedisHash("student")
public class Student {
    @Id
    Long id;
    String name;
    Integer age;
    String gender;
    String studentNum;
```



### Dao与Service

**Dao**

```java
@Repository
public interface StudentDao extends CrudRepository<Student, Long> {
}
```

泛型中第一位为存储类型,第二位为id的类型

**Service**

```java
@Service
public class StudentService {
    @Autowired
    private StudentDao studentDao;

//因为使用了RedisRepositories，所以简单的crud将不用使用RedisTemplate
//    @Autowired
//    private RedisTemplate redisTemplate;


    /**
     * 按student:id的方式存入redis
     * @param student
     */
    public void save(Student student){
        //redisTemplate.opsForValue().set(new Random().nextDouble() + "",student);

        studentDao.save(student);

    }

    /**
     * 根据key从redis中查找对应value
     * @param id
     * @return
     */
    public Student findOne(Long id){

        //StudentEntity student = (StudentEntity) redisTemplate.opsForValue().get(key);

        Student student = studentDao.findById(id).get();

        return student;
    }

}

```



### 调用

```java
@Autowired
    StudentService studentService;
    @GetMapping("/rep/student/{id}")
    public Object saveAndGetStudentByRep(@PathVariable Long id) throws JsonProcessingException {

        Student student = new Student();
        student.setName("掌上");
        student.setAge(18);
        student.setGender("男");
        student.setStudentNum(LocalDateTime.now().toString());


        studentService.save(student);
        Student value = studentService.findOne(id);
        System.out.println(value);

        return value;
    }
```

# 保护模式

redis默认开启保护模式。要是配置里没有指定bind和密码，开启该参数后，redis只能本地访问，拒绝外部访问。

redis.conf安全设置： # 打开保护模式 protected-mode yes

Redis 的保护模式是一种安全特性，它限制了 Redis 服务器的访问权限。当保护模式被启用时，如果没有设置 `bind` 参数和密码，Redis 服务器将只接受来自本地主机的连接。这意味着，外部客户端将无法连接到 Redis 服务器，除非它们在同一个局域网内或具有相应的权限。

具体来说：

1. **bind 参数**：`bind` 参数用于指定 Redis 服务器应该绑定的 IP 地址。如果未设置此参数，Redis 将绑定到所有可用的网络接口。但当保护模式被启用时，如果未设置 `bind` 参数，Redis 将只接受来自 localhost（127.0.0.1）的连接。
2. **密码**：为了从外部访问 Redis，你可以设置密码。当保护模式被启用时，如果你没有设置密码，外部客户端将无法连接到 Redis 服务器，除非它们具有适当的权限或位于相同的局域网内。

因此，当 Redis 的保护模式被启用且没有设置 `bind` 和密码时，Redis 服务器的访问将被限制在本地机器上。这有助于增强服务器的安全性，防止未经授权的访问。

# 禁用或者重命名危险命令

Redis中线上使用keys *命令是非常危险的，应该禁用或者限制使用这些危险的命令，可降低Redis写入文件漏洞的入侵风险。

- `KEYS *` 命令在 Redis 中用于列出所有的键。当 Redis 服务器正在处理这个命令时，它会遍历整个键空间，这可能会导致长时间的阻塞，尤其是在有大量数据的情况下。
- 更糟糕的是，如果有外部攻击者恶意地使用 `KEYS *` 命令，它可能会导致 Redis 服务器资源耗尽，从而拒绝服务。

修改 redis.conf 文件，添加
```
rename-command FLUSHALL ""
rename-command FLUSHDB  ""
rename-command CONFIG   ""
rename-command KEYS     ""
rename-command SHUTDOWN ""
rename-command DEL ""
rename-command EVAL ""
```
然后重启redis。
重命名为"" 代表禁用命令，如想保留命令，可以重命名为不可猜测的字符串，如：
`rename-command FLUSHALL  joYAPNXRPmcarcR4ZDgC`

