---
title: Redis
date: 2022-12-29 16:50:30
tags:
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





