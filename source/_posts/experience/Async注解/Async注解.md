---
title: Async注解
date: 2023-11-29 15:35:19
tags:
  - Async注解
categories:
  - 经验
---

# 作用

标注在方法上，当调用该方法时，spring会启用一个线程去执行该方法

# 使用

- 启用@Async注解

    在某个配置类上比如启动类上标注@EnableAsync注解

    ```java
    @SpringBootTest
    @EnableAsync
    public class AsyncTest {
       
    }
    ```

- 定义接口用于让spring注入

    ```java
    /**
     * @author boranget
     * @date 2023/11/29
     */
    public interface IAsyncMethod {
        void A();
        void B();
    }
    ```

- 实现类

    ```java
    package com.example.springweb;
    
    import org.springframework.scheduling.annotation.Async;
    import org.springframework.stereotype.Service;
    
    /**
     * @author boranget
     * @date 2023/11/29
     */
    @Service
    public class AsyncMethodImpl implements IAsyncMethod{
        @Override
        public void A() {
    
        }
    
        @Override
        @Async
        public void B() {
            System.out.println(Thread.currentThread().getName());
        }
    }
    ```

- 调用

    ```java
    package com.example.springweb;
    
    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.scheduling.annotation.EnableAsync;
    import org.springframework.test.context.junit4.SpringRunner;
    
    /**
     * @author boranget
     * @date 2023/11/29
     */
    
    @SpringBootTest
    @EnableAsync
    public class AsyncTest {
        @Autowired
        IAsyncMethod iAsyncMethod;
    
      @Test
       void testAsync(){
          for (int i = 0; i < 100; i++) {
              iAsyncMethod.B();
          }
      }
    }
    
    ```

# 自定义线程池

源码：

```java
@Nullable
    protected Executor getDefaultExecutor(@Nullable BeanFactory beanFactory) {
        if (beanFactory != null) {
            try {
                return (Executor)beanFactory.getBean(TaskExecutor.class);
            } catch (NoUniqueBeanDefinitionException var6) {
                this.logger.debug("Could not find unique TaskExecutor bean. Continuing search for an Executor bean named 'taskExecutor'", var6);

                try {
                    return (Executor)beanFactory.getBean("taskExecutor", Executor.class);
                } catch (NoSuchBeanDefinitionException var4) {
                    if (this.logger.isInfoEnabled()) {
                        this.logger.info("More than one TaskExecutor bean found within the context, and none is named 'taskExecutor'. Mark one of them as primary or name it 'taskExecutor' (possibly as an alias) in order to use it for async processing: " + var6.getBeanNamesFound());
                    }
                }
            } catch (NoSuchBeanDefinitionException var7) {
                this.logger.debug("Could not find default TaskExecutor bean. Continuing search for an Executor bean named 'taskExecutor'", var7);

                try {
                    return (Executor)beanFactory.getBean("taskExecutor", Executor.class);
                } catch (NoSuchBeanDefinitionException var5) {
                    this.logger.info("No task executor bean found for async processing: no bean of type TaskExecutor and no bean named 'taskExecutor' either");
                }
            }
        }

        return null;
    }
```

可以看到Spring会默认寻找类型为TaskExecutor的Bean，若找不到，则寻找名称为taskExecutor且类型为Executor的Bean，所以可以写一个Executor且名字为taskExecutor的bean放入容器

另一种方法：@Async注解有一个参数，指定了线程池的Bean名称

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Async {

	/**
	 * A qualifier value for the specified asynchronous operation(s).
	 * <p>May be used to determine the target executor to be used when executing
	 * the asynchronous operation(s), matching the qualifier value (or the bean
	 * name) of a specific {@link java.util.concurrent.Executor Executor} or
	 * {@link org.springframework.core.task.TaskExecutor TaskExecutor}
	 * bean definition.
	 * <p>When specified on a class-level {@code @Async} annotation, indicates that the
	 * given executor should be used for all methods within the class. Method-level use
	 * of {@code Async#value} always overrides any value set at the class level.
	 * @since 3.1.2
	 */
	String value() default "";

}

```

