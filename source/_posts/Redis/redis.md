---
title: Redis
date: 2022-12-29 16:50:30
updated: 2024-01-29 16:40:19
tags:
  - redis
categories:
  - notes
---

# SDS

**simple dynamic string**

SDS是redis底层使用的字符串结构

```c
struct sdshdr {
    //记录buf数组中已使用字节的数量
    //等于SDS所保存字符串的长度
    int len;
    //记录buf数组中未使用字节的数量
    int free;
    //字节数组，用于保存字符串
    char buf[];
};
```

保留了`\0`字符，目的是为了复用c语言中的字符串方法

buf.length = len + 1 + free

其中free为每次分配空间进行的预分配内存，避免每次扩展字符串时都需要重新申请空间。以1M为限，1M下会分配即将用到的内存的两倍，1M以上只多分配1M，避免指数爆炸。当然如果free本身就能够支持本次操作，则不会进行内存重分配。

free空间为惰性释放，当对字符串进行缩短操作时，会将回收的内存放在free中而不是会立即释放，便于后续使用，同时SDS提供了对应的释放api避免造成内存浪费。

此外，SDS为二进制安全的，由于不会通过终止符判断是否到信息结尾，故可以存储二进制数据即使其中包含`\0`，保证数据在存储与读取时的一致性

# 链表

```c
typedef struct listNode {
    // 前置节点
    struct listNode * prev;
    // 后置节点
    struct listNode * next;
    //节点的值
    void * value;
}listNode;

typedef struct list {
    // 表头节点
    listNode * head;
    // 表尾节点
    listNode * tail;
    // 链表所包含的节点数量
    unsigned long len;
    // 节点值复制函数
    void *(*dup)(void *ptr);
    // 节点值释放函数
    void (*free)(void *ptr);
    // 节点值对比函数
    int (*match)(void *ptr,void *key);
} list;
```

双向无环链表，带头指针和尾指针，且带链表长度，同时结点的值为void指针类型，故具有多态性。

# 字典



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

# 启用远程连接

修改redis.conf文件，linux在/etc/redis下

- 修改protcted-mode为false
- 将bind一行注释
- requirepass 后面设置密码

# 启用密码后的cli连接

redis-cli之后，需要使用 auth password 进行认证，否则无权限操作

远程：redis-cli -h host -p port -a password

# Hash过期

hash类型数据无法为单独的每条数据设置过期时间，只能为整个hash结构设置过期时间，如果有需求，建议在单个字段中存储过期时间手动判断

# 日志记录

linux下`redisc.onf`文件在etc的redis下面，编辑该文件，找到logfile一行，改行为日志文件所在地址

# redis被攻击记录

redis关掉了保护模式与bind，密码设为了123456

现象，redis在备份rdb文件时出错，显示日志如下：

```log
 * 1 changes in 900 seconds. Saving...
 * Background saving started by pid 2127220
 * DB saved on disk
 * RDB: 0 MB of memory used by copy-on-write
 * Background saving terminated with success
 // 备份文件夹只读
 # Failed opening the RDB file root (in server root dir /var/spool/cron) for saving: Read-only file system
 # Failed opening the RDB file redis (in server root dir /var/spool/cron) for saving: Read-only file system
 // 不知道哪里来的MASTERR
 * Connecting to MASTER 108.181.122.221:60101
 * MASTER <-> REPLICA sync started
 * Non blocking connect for SYNC fired the event.
 * Master replied to PING, replication can continue...
 * Trying a partial resynchronization (request ccc31f7f854cd2e74e324a89c50f5e9d244d31e5:1).
 * Full resync from master: ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ:0
 * Discarding previously cached master state.
 * MASTER <-> REPLICA sync: receiving 21816 bytes from master
```

其中奇怪的地方，一个是出现了一个主机，另一个是备份文件夹变成了只读

首先没有配置过主从复制，其次查看配置文件中，备份文件夹的地址为 `/var/lib/redis`，可见配置被动态修改了

参考攻击方法：[Redis攻防(未授权访问、利用redis写入webshell、任务计划反弹、Shellssh-keygen 公钥登录服务器、利用主从复制RCE)_redis未授权访问写入webshell的步骤不包括?(1.00分) 设置数据缓存文件 设置数据缓-CSDN博客](https://blog.csdn.net/q20010619/article/details/121912003)

建议配置方式

1. 单独为redis设置一个普通账号启动 redis
2. 设置本地 localhost 不允许外部访问
3. 保护模式开启 protected-mode 开启 （默认开启）
4. 把端口最好更改
5. requirepass 设置redis密码

好在使用apt安装的redis，且使用systemctl启动redis，这样redis的所属用户为redis，没有系统文件夹比如进程等的操作权限

# systemctl启动redis的配置

使用`systemctl start redis`命令启动Redis服务时，默认情况下会以`redis`用户的身份运行。这是通过`systemd`的单元文件来配置的，该文件定义了服务的运行方式。

要查看Redis服务的用户配置，可以执行以下步骤：

1. 打开Redis服务的单元文件。在大多数Linux发行版上，Redis服务的单元文件位于`/etc/systemd/system/redis.service`或`/lib/systemd/system/redis.service`。
2. 使用文本编辑器打开该文件。
3. 在文件中查找`User`行。该行指定了运行Redis服务的用户。它应该类似于以下内容：


```bash
User=redis
```
4. 如果你想更改运行Redis服务的用户，只需将`User`行中的值修改为你想要的用户名，并保存文件。
5. 重新加载`systemd`配置并重新启动Redis服务，以使更改生效。可以使用以下命令：


```bash
sudo systemctl daemon-reload
sudo systemctl restart redis
```

请注意，更改运行Redis服务的用户需要具有适当的系统权限，并且确保新的用户具有访问Redis所需的文件和目录的权限。此外，确保在更改用户配置之前备份原始的单元文件，以便在需要时可以还原。