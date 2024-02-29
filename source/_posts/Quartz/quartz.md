---
title: Quartz
date: 2023-02-27 16:50:30
updated: 2023-05-31 16:40:19
tags:
  - job
  - qartz
categories:
  - notes
---

# 基本概念

## Job

指定任务的具体内容

## Trigger

指定执行的策略

## Scheduler

调度器，用于将Job和Trigger整合

# 入门案例

**引入依赖**

```xml
<!--quartz-->
<dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
    <version>2.3.2</version>
</dependency>
```

**job**

```java
public class MyJob implements Job {
    static int count = 0;
    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        System.out.println("the current time = "+System.currentTimeMillis());
        System.out.println("thr count = "+ count++);
    }
}

```

**测试**

```java
public class Run {
    public static void main(String[] args) throws SchedulerException {
        // JobDetail
        JobDetail jobDetail = JobBuilder.newJob(MyJob.class)
                .withIdentity("test indentity name","test indentity group")
                .build();
        // Trigger
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("test trigger","test trigger group")
                // 启动即执行
                .startNow()
                .withSchedule(SimpleScheduleBuilder.repeatSecondlyForever(3))
                .build();
        // Scheduler
        Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
        scheduler.scheduleJob(jobDetail,trigger);
        scheduler.start();
    }
}
```

# Job

## 从Job中获取运行时数据

**存**

usingJobData

```java
 JobDetail jobDetail = JobBuilder.newJob(MyJob.class)
                .usingJobData("testKeyJD","JDV")
                .withIdentity("test indentity name","test indentity group")
                .build();
        // Trigger
        Trigger trigger = TriggerBuilder.newTrigger()
                .usingJobData("testKeyT","TV")
                .withIdentity("test trigger","test trigger group")
                .startNow()
                .withSchedule(SimpleScheduleBuilder.repeatSecondlyForever(3))
                .build();
```

**取**

```java
public class MyJob implements Job {
    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        System.out.println("the current time = "+System.currentTimeMillis());
        System.out.println(jobExecutionContext.getJobDetail().getJobDataMap().get("testKeyJD"));
        System.out.println(jobExecutionContext.getTrigger().getJobDataMap().get("testKeyT"));

    }
}
```

**也可以:**

在Job实现类中添加对应key的setter方法，那么Quartz框架默认的JobFactory实现类在初始化 Job 实例对象时回自动地调用这些 setter 方法

**注：** 这种setter方法如果遇到同名的 key，比如我们在**JobDetail** 中存放值的 **key** 与在 **Trigger** 中存放值的 **key** 相同，那么最终 **Trigger** 的值会覆盖掉 **JobDetail** 中的值.



**维持参数的存在状态**

默认每次JobDataMap中的值都为初始值.

于是加 @PersistJobDataAfterExecution 注解

```java
@PersistJobDataAfterExecution
public class MyJob implements Job {
    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        System.out.println("the current time = "+System.currentTimeMillis());
        System.out.println(jobExecutionContext.getJobDetail().getJobDataMap().get("current"));
        JobDataMap jobDataMap = jobExecutionContext.getJobDetail().getJobDataMap();
        int count = (int)jobDataMap.get("count");
        System.out.println(count);
        jobDataMap.put("count",count+1);

    }
}
```

可以将JobDataMap中的信息维持存在状态, 本次在job中对map中的信息执行修改后, 在下一次任务执行时, 会传入修改后的值,而不是传入初始值.

但如果不对JobDataMap做修改,其中的值是不会变化的,还是维持在初始值, 这里做了一个实验,在初始JobDataMap时**传入**了一个时间戳, jopb的不断执行并不会更新该时间戳.

# Trigger

## SimpleTrigger

```java
Trigger trigger = TriggerBuilder.newTrigger()
    .withIdentity("testTrigger", "testTriggerGroup")
    .withSchedule(SimpleScheduleBuilder.repeatSecondlyForever(5))
    .withRepeatCount(2)) // 每5秒执行一次，连续执行3次后停止，从 0 开始计数
    .build();
```

- **SimpleTrigger具备的属性有**：开始时间、结束时间、重复次数和重复的时间间隔
- **重复次数** 的值可以为 **0**、**正整数**、**或常量 SimpleTrigger.REPEAT_INDEFINITELY**
- 重复的时间间隔属性值必须大于 **0** 或长整型的正整数，以 **毫秒** 作为时间单位，当重复的时间间隔为 **0** 时，意味着与 **Trigger** 同时触发执行
- 结束时间和重复次数同时存在时，以结束时间优先

## CronTrigger

### Corn表达式

| 字段   | 是否必填 | 允许值              | 可用特殊字符     |
| ------ | -------- | ------------------- | ---------------- |
| 秒     | 是       | 0-59                | ， - * /         |
| 分     | 是       | 0-59                | ， - * /         |
| 小时   | 是       | 0-23                | ， - * /         |
| 月中日 | 是       | 1-31                | ， - * / ? L W C |
| 月     | 是       | 1-12 或 JAN-DEC     | ， - * /         |
| 周中日 | 是       | 1-7 或 SUN-SAT      | ， - * / ? L C # |
| 年     | 否       | 不填写 或 1970-2099 | ， - * /         |

| 特殊符号 | 含义                                                         |
| -------- | ------------------------------------------------------------ |
| *        | 所有字段可用，表示对应时间域的每一个时刻，例如，***** 在分钟字段时，表示“每分钟” |
| ?        | 该字符只在月中日和周中日字段中使用，它通常指定为“无意义的值”, 比如当指定月中日的时候,周中日其实是无意义的 |
| -        | 表达一个范围，如在小时字段中使用“10-12”，则表示从10到12点，即10,11,12 |
| ,        | 表达一个列表值，如在周中日中使用“MON,WED,FRI”，则表示星期一，星期三和星期五 |
| /        | x/y表达一个等步长序列，x为起始值，y为增量步长值。如在分钟字段中使用0/15，则表示为0,15,30和45秒，而5/15在分钟字段中表示5,20,35,50，你也可以使用*/y，它等同于0/y |
| L        | 该字符只在月中日和周中日中使用，代表“Last”的意思，但它在两个字段中意思不同。L在月中日中，表示这个月份的最后一天，如一月的31号，非闰年二月的28号；<br />如果L用在周中日中，则表示星期六，等同于7。但是如果在前面有一个数值 X，则表示“这个月的最后一个X天”，例如，6L表示该月的最后星期五 |
| W        | 该字符只能出现在月中日里，是对前导日期的修饰，表示离该日期最近的工作日。例如15W表示离该月15号最近的工作日，如果该月15号是星期六，则匹配14号星期五；如果15日是星期日，则匹配16号星期一；如果15号是星期二，那结果就是15号星期二。<br />**必须注意:** 关联的匹配日期不能够跨月，如你指定1W，如果1号是星期六，结果匹配的是3号星期一，而非上个月最后的那天。<br />W字符串只能指定单一日期，而不能指定日期范围 |
| #        | 该字符只能在周中日中使用，表示当月某个工作日。如6#3表示当月的第三个星期五(6表示星期五，#3表示当前的第三个)，而4#5表示当月的第五个星期三，假设当月没有第五个星期三，忽略不触发 |

CornTrigger配置

```java
// Trigger
Trigger trigger = TriggerBuilder.newTrigger()
    .withIdentity("test trigger","test trigger group")
    // 一月六日每隔一秒执行一次
    .withSchedule(CronScheduleBuilder.cronSchedule("0/1 * * 6 1 ?"))
    .build();
```

# Scheduler

**创建**

```java
Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
```

**整合Job和Trigger**

// 可获取调度器开始的时间

```java
Date theStartTime = scheduler.scheduleJob(jobDetail, trigger);
```

**启动任务**

```java
scheduler.start();
```

**挂起任务(暂停)**

```java
scheduler.standby();
```

**关闭任务**

```java
// 等待当前任务执行完毕再关闭
scheduler.shutdown(true);
// 直接关闭
scheduler.shutdown(false);
```

**注意**

shutdown后的任务无法再启动

>  org.quartz.SchedulerException: The Scheduler cannot be restarted after shutdown() has been called.

## 配置方式

- 配置文件的方式

  [(31条消息) quartz配置详解_ssssdfdsf的博客-CSDN博客_quartz配置](https://blog.csdn.net/ssssdfdsf/article/details/91567771)

- 代码中配置的方式

```java
// Scheduler
StdSchedulerFactory stdSchedulerFactory = new StdSchedulerFactory();
// 创建配置工厂的属性对象
Properties props = new Properties();
// 线程池定义
props.put(StdSchedulerFactory.PROP_THREAD_POOL_CLASS, "org.quartz.simpl.SimpleThreadPool"); 
// 默认Scheduler的线程数
props.put("org.quartz.threadPool.threadCount", "5");
stdSchedulerFactory.initialize(props);
Scheduler scheduler = stdSchedulerFactory.getScheduler();
```

# 监听器

## JobListener

**实现**

```java
public class MyJobLinstner implements JobListener {
    Logger logger = LoggerFactory.getLogger(MyJobLinstner.class);

    @Override
    public String getName() {
        String name = getClass().getName();
        logger.info("监听器的名字为" + name);
        return name;
    }

    @Override
    public void jobToBeExecuted(JobExecutionContext jobExecutionContext) {
        String jobName = jobExecutionContext.getJobDetail().getKey().getName();
        logger.info("Job的名称是：" + jobName + "\tScheduler在JobDetail将要被执行时调用这个方法");

    }

    @Override
    public void jobExecutionVetoed(JobExecutionContext jobExecutionContext) {
        String jobName = jobExecutionContext.getJobDetail().getKey().getName();
        logger.info("Job的名称是：" + jobName + "\tScheduler在JobDetail即将被执行，但又被TriggerListerner否决时会调用该方法");
    }

    @Override
    public void jobWasExecuted(JobExecutionContext jobExecutionContext, JobExecutionException e) {
        String jobName = jobExecutionContext.getJobDetail().getKey().getName();
        logger.info("Job的名称是：" + jobName + "\tScheduler在JobDetail被执行之后调用这个方法");
    }
}

```



**注册**

```java
// 注册全局监听器
        scheduler.getListenerManager().addJobListener(new MyJobLinstner(), EverythingMatcher.allJobs());
```

## TriggerListener

```java
 @Override
    public void triggerFired(Trigger trigger, JobExecutionContext jobExecutionContext) {
        logger.info("trigger-"+"triggerFired");
    }

    @Override
    public boolean vetoJobExecution(Trigger trigger, JobExecutionContext jobExecutionContext) {
        logger.info("trigger-"+"vetoJobExecution");
        return false;
    }

    @Override
    public void triggerMisfired(Trigger trigger) {
        logger.info("trigger-"+"triggerMisfired");
    }

    @Override
    public void triggerComplete(Trigger trigger, JobExecutionContext jobExecutionContext, Trigger.CompletedExecutionInstruction completedExecutionInstruction) {
        logger.info("trigger-"+"triggerComplete");
    }

```

**注册**

```java
scheduler.getListenerManager().addTriggerListener(new MyJobLinstner(), EverythingMatcher.allTriggers());
```

```
INFO com.orange.MyJobLinstner - 监听器的名字为com.orange.MyJobLinstner
INFO com.orange.MyJobLinstner - trigger-triggerFired
INFO com.orange.MyJobLinstner - trigger-vetoJobExecution
INFO com.orange.MyJobLinstner - 监听器的名字为com.orange.MyJobLinstner
INFO com.orange.MyJobLinstner - Job的名称是：test indentity name	Scheduler在JobDetail将要被执行时调用这个方法
job执行
INFO com.orange.MyJobLinstner - 监听器的名字为com.orange.MyJobLinstner
INFO com.orange.MyJobLinstner - Job的名称是：test indentity name	Scheduler在JobDetail被执行之后调用这个方法
INFO com.orange.MyJobLinstner - 监听器的名字为com.orange.MyJobLinstner
INFO com.orange.MyJobLinstner - trigger-triggerComplete
```

## ScheduleListener

- `jobScheduled()`：用于部署JobDetail时调用
- `jobUnscheduled()`：用于卸载JobDetail时调用
- `triggerFinalized()`：当一个 Trigger 来到了再也不会触发的状态时调用这个方法。除非这个 Job 已设置成了持久性，否则它就会从 Scheduler 中移除。
- `triggersPaused()`：Scheduler 调用这个方法是发生在一个 Trigger 或 Trigger 组被暂停时。假如是 Trigger 组的话，triggerName 参数将为 null。
- `triggersResumed()`：Scheduler 调用这个方法是发生成一个 Trigger 或 Trigger 组从暂停中恢复时。假如是 Trigger 组的话，假如是 Trigger 组的话，triggerName 参数将为 null。参数将为 null。
- `jobsPaused()`：当一个或一组 JobDetail 暂停时调用这个方法。
- `jobsResumed()`：当一个或一组 Job 从暂停上恢复时调用这个方法。假如是一个 Job 组，jobName 参数将为 null。
- `schedulerError()`：在 Scheduler 的正常运行期间产生一个严重错误时调用这个方法。
- `schedulerStarted()`：当Scheduler 开启时，调用该方法
- `schedulerInStandbyMode()`： 当Scheduler处于StandBy模式时，调用该方法
- `schedulerShutdown()`)：当Scheduler停止时，调用该方法
- `schedulingDataCleared()`：当Scheduler中的数据被清除时，调用该方法。

**接口**

```java
public interface SchedulerListener {
    void jobScheduled(Trigger var1);

    void jobUnscheduled(TriggerKey var1);

    void triggerFinalized(Trigger var1);

    void triggerPaused(TriggerKey var1);

    void triggersPaused(String var1);

    void triggerResumed(TriggerKey var1);

    void triggersResumed(String var1);

    void jobAdded(JobDetail var1);

    void jobDeleted(JobKey var1);

    void jobPaused(JobKey var1);

    void jobsPaused(String var1);

    void jobResumed(JobKey var1);

    void jobsResumed(String var1);

    void schedulerError(String var1, SchedulerException var2);

    void schedulerInStandbyMode();

    void schedulerStarted();

    void schedulerStarting();

    void schedulerShutdown();

    void schedulerShuttingdown();

    void schedulingDataCleared();
}
```

**注册**

```java
scheduler.getListenerManager().addSchedulerListener(new MySchedulerListener());
```



