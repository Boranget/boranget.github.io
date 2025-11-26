---
title: xxl-job
date: 2025-09-13 12:35:19
updated: 2025-09-13 12:35:19
tags:
  - xxl-job
categories:
  - 经验
---

# 参考资料

[分布式任务调度平台XXL-JOB](https://www.xuxueli.com/xxl-job/)

# 定义

xxl-job本质上是个springboot的微服务

# 部署

拉取代码后本地编译

在xxl-jobdocdb路径下找到tables_xxl_job.sql文件。在mysql上运行sql文件。

配置文件：

```properties
### 调度中心JDBC链接
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/xxl_job?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
### 报警邮箱
spring.mail.host=smtp.qq.com
spring.mail.port=25
spring.mail.username=xxx@qq.com
spring.mail.password=xxx
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true
spring.mail.properties.mail.smtp.socketFactory.class=javax.net.ssl.SSLSocketFactory
### 调度中心通讯TOKEN [选填]：非空时启用；
xxl.job.accessToken=
### 调度中心国际化配置 [必填]： 默认为 "zh_CN"/中文简体, 可选范围为 "zh_CN"/中文简体, "zh_TC"/中文繁体 and "en"/英文；
xxl.job.i18n=zh_CN
## 调度线程池最大线程配置【必填】
xxl.job.triggerpool.fast.max=200
xxl.job.triggerpool.slow.max=100
### 调度中心日志表数据保存天数 [必填]：过期日志自动清理；限制大于等于7时生效，否则, 如-1，关闭自动清理功能；
xxl.job.logretentiondays=10
```

# DEMO

```properties
# web port
server.port=8081
# log config
logging.config=classpath:logback.xml
spring.application.name=xxljob-demo
### 调度中心部署跟地址 [选填]：如调度中心集群部署存在多个地址则用逗号分隔。执行器将会使用该地址进行"执行器心跳注册"和"任务结果回调"；为空则关闭自动注册；
xxl.job.admin.addresses=http://127.0.0.1:8080/xxl-job-admin
### 执行器通讯TOKEN [选填]：非空时启用；
xxl.job.accessToken=
### 执行器AppName [选填]：执行器心跳注册分组依据；为空则关闭自动注册
xxl.job.executor.appname=xxl-job-demo
### 执行器注册 [选填]：优先使用该配置作为注册地址，为空时使用内嵌服务 ”IP:PORT“ 作为注册地址。从而更灵活的支持容器类型执行器动态IP和动态映射端口问题。
xxl.job.executor.address=
### 执行器IP [选填]：默认为空表示自动获取IP，多网卡时可手动设置指定IP，该IP不会绑定Host仅作为通讯实用；地址信息用于 "执行器注册" 和 "调度中心请求并触发任务"；
xxl.job.executor.ip=
### 执行器端口号 [选填]：小于等于0则自动获取；默认端口为9999，单机部署多个执行器时，注意要配置不同执行器端口；
xxl.job.executor.port=9999
### 执行器运行日志文件存储磁盘路径 [选填] ：需要对该路径拥有读写权限；为空则使用默认路径；
xxl.job.executor.logpath=/data/applogs/xxl-job/jobhandler
### 执行器日志文件保存天数 [选填] ： 过期日志自动清理, 限制值大于等于3时生效; 否则, 如-1, 关闭自动清理功能；
xxl.job.executor.logretentiondays=10
```

```java
@Configuration
public class XxlJobConfig {
    private Logger logger = LoggerFactory.getLogger(XxlJobConfig.class);
    @Value("${xxl.job.admin.addresses}")
    private String adminAddresses;
    @Value("${xxl.job.accessToken}")
    private String accessToken;
    @Value("${xxl.job.executor.appname}")
    private String appname;
    @Value("${xxl.job.executor.address}")
    private String address;
    @Value("${xxl.job.executor.ip}")
    private String ip;
    @Value("${xxl.job.executor.port}")
    private int port;
    @Value("${xxl.job.executor.logpath}")
    private String logPath;
    @Value("${xxl.job.executor.logretentiondays}")
    private int logRetentionDays;

    @Bean
    public XxlJobSpringExecutor xxlJobExecutor() {
        logger.info(">>>>>>>>>>> xxl-job config init.");
        XxlJobSpringExecutor xxlJobSpringExecutor = new XxlJobSpringExecutor();
        xxlJobSpringExecutor.setAdminAddresses(adminAddresses);
        xxlJobSpringExecutor.setAppname(appname);
        xxlJobSpringExecutor.setAddress(address);
        xxlJobSpringExecutor.setIp(ip);
        xxlJobSpringExecutor.setPort(port);
        xxlJobSpringExecutor.setAccessToken(accessToken);
        xxlJobSpringExecutor.setLogPath(logPath);
        xxlJobSpringExecutor.setLogRetentionDays(logRetentionDays);
        return xxlJobSpringExecutor;
    }
}
```

```java
@Component
public class XxlJobDemoHandler {
    /**
     * Bean模式，一个方法为一个任务
     * 1、在Spring Bean实例中，开发Job方法，方式格式要求为 "public ReturnT<String> execute(String param)"
     * 2、为Job方法添加注解 "@XxlJob(value="自定义jobhandler名称", init = "JobHandler初始化方法", destroy = "JobHandler销毁方法")"，注解value值对应的是调度中心新建任务的JobHandler属性的值。
     * 3、执行日志：需要通过 "XxlJobLogger.log" 打印执行日志；
     */
    @XxlJob("demoJobHandler")
    public ReturnT<String> demoJobHandler(String param) throws Exception {
        XxlJobLogger.log("java, Hello World~~~");
        XxlJobLogger.log("param:" + param);
        return ReturnT.SUCCESS;
    }
}
```

# 调度器

调度器，即 XXL-JOB 中的调度中心，是整个任务调度系统的核心枢纽，本质上是一个基于 Spring Boot 开发的微服务应用。它负责对任务进行统一管理和调度，协调任务的执行计划和分配。

- **任务管理**：提供可视化界面，用于创建、修改、删除任务。可设置任务的执行周期（如每分钟执行一次、每天凌晨两点执行等）、任务超时时间、失败重试次数等参数。
- **执行器管理**：管理执行器的注册、发现和状态监控。执行器启动后会自动向调度中心注册，调度中心可以实时查看执行器的在线状态、运行负载等信息，当执行器离线时，还能触发相应的报警机制。
- **任务调度**：按照设定的任务执行计划，将任务分配给合适的执行器进行执行。它维护着任务的调度队列，根据任务的优先级、执行时间等因素，决定任务的触发时机。
- **监控报警**：实时监控任务的执行状态，包括任务的执行时间、执行结果（成功或失败）等。当任务执行失败、超时，或者执行器出现故障时，能够通过邮件、钉钉、短信等多种方式发送报警信息，以便及时处理问题。
- **日志管理**：存储和管理任务的执行日志，方便开发人员和运维人员查看任务的执行过程，排查问题。

# 执行器

执行器是实际执行任务的组件，也是基于 Spring Boot 的应用。它部署在任务执行的服务器上，负责接收调度中心分配的任务，并按照任务要求执行具体的业务逻辑。

- **任务执行**：接收调度中心发送的任务指令，根据任务类型（Bean 模式、GLUE 模式等）执行相应的业务代码。比如在一个电商系统中，执行器可以执行定时订单清理、库存同步等任务。
- **任务结果反馈**：将任务的执行结果（成功、失败、超时等）反馈给调度中心，以便调度中心记录任务状态，并进行后续处理，如任务失败后的重试操作。
- **日志记录**：通过特定的日志记录方式（如 XXL-JOB 中的 XxlJobLogger.log）记录任务执行过程中的详细信息，这些日志会同步到调度中心，方便统一查看和分析。

# 其他

- **任务**：指需要执行的具体工作单元，例如定时备份数据库、定时发送营销邮件、定时更新缓存数据等。在 XXL-JOB 中，任务与执行器和调度中心紧密关联，通过调度中心配置任务的属性（如执行周期、JobHandler 等），由执行器实际执行任务。
- **JobHandler**：是任务处理的具体实现，是执行器中处理任务的方法或类。在 Bean 模式下，开发人员通过在 Spring Bean 中定义带有`@XxlJob`注解的方法来创建 JobHandler。注解中的`value`值对应调度中心配置任务时的 JobHandler 属性值，调度中心根据该值将任务分配到对应的执行器方法上执行。
- **分片**：当有大量任务需要处理，单个执行器难以在规定时间内完成时，可采用分片机制。将一个任务拆分成多个子任务，分配给不同的执行器实例并行处理。每个执行器实例只负责处理其中一个分片的数据，通过这种方式提高任务的执行效率。比如，要处理 100 万条数据的统计任务，可将其分为 10 个分片，每个执行器处理 10 万条数据 。
- **GLUE**：一种在线编码模式，允许用户在调度中心直接编写任务的执行代码，支持 Java、Shell、Python、PHP 等多种语言。无需在执行器工程中编写代码，方便快速实现一些简单任务或临时任务的开发和调试，如临时的数据清理脚本、简单的接口调用任务等。
- **故障转移**：当某个执行器出现故障（如服务器宕机、进程崩溃）时，调度中心能够自动将原本分配给该执行器的任务重新分配给其他正常运行的执行器，以保证任务的持续执行，提升系统的可靠性和稳定性。
- **任务依赖**：在一些复杂的业务场景中，任务之间可能存在先后顺序或依赖关系。例如，任务 B 必须在任务 A 执行成功后才能执行。XXL-JOB 支持配置任务依赖，确保任务按照预定的顺序和条件执行，保证业务流程的正确性。

# GLUE模式

GLUE模式是直接在xxljob调度器页面编写java，实现提供的接口，xxljob会将其使用groovy编译后放到执行器的bean容器中

# 多实例路由策略

- 轮询
- 故障转移：按顺序心跳检测，第一个有心跳的几位目标执行器
- 分片广播：出发所有机器中的任务同时传递分片参数