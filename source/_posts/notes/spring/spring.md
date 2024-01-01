---
title: Spring
date: 2022-01-08 16:50:30
tags:
  - spring
categories:
  - 笔记
---

# 一些经验

## 构造方法注入

Spring 团队提倡使用基于构造方法的注入，因为这样一方面可以将依赖注入到一个不可变的变量中 (注： final 修饰的变量)，另一方面也可以保证这些变量的值不会是 null。

## **ApplicationContextAware接口**

一个bean实现该接口，spring会自动调用该类中实现的setApplicationContext接口。

参考案例：quartz中的AutowiringSpringBeanJobFactory

```java
/**
 * 负责生成job实例
 */
public class AutoWiringSpringBeanJobFactory extends SpringBeanJobFactory implements ApplicationContextAware {
    private AutowireCapableBeanFactory beanFactory;

    @Override
    public void setApplicationContext(final ApplicationContext context) {
        beanFactory = context.getAutowireCapableBeanFactory();
    }

    @Override
    protected Object createJobInstance(final TriggerFiredBundle bundle) throws Exception {
        final Object job = super.createJobInstance(bundle);
        beanFactory.autowireBean(job);
        return job;
    }
}
```



# Spring 基本概念



## Bean的生命周期

```markdown
# Constructor say:
This is a new OrderService
OrderDao: null
# Processor say:
postProcess---Before---Initialization
The current Bean need processor is orderService
# Initialize say:
properties is already set
OrderDao: com.boranget.dao.OrderDao@3f200884
# Processor say:
postProcess---After---Initialization
The current Bean need processor is orderService
```



![image-20221013101209444](spring/image-20221013101209444.png)

## 容器处理bean的流程

![image-20221013103022824](spring/image-20221013103022824.png)

# 创建一个简单的Spring

- 一个容器

  将扫描路径存入其中可从中获取扫描路径中的Bean

  容器类: AnnotationConfigApplicationContext

- Bean的生命周期

  - 获取定义

    需要扫描整个包路径, 将符合bean要求(有@Component注解)的类进行解析,转换为定义,存入定义map

    这里需要

    1. Bean注解: @Component
    2. 扫描注解: @ComponentScan
    3. 定义类: BeanDefinition

  - 实例化

    将定义map中的所有Bean进行实例化,并存入缓存

    - 填充属性

      Bean中如果有设置了@Autowired的属性,我们需要获取一个Bean赋给它

      这里需要

      1. 自动注入注解: @Autowired

    - 初始化

      初始化及其前后置操作

      - 初始化前置操作
      - 初始化
      - 初始化后置操作

      这里需要:

      1. 初始化接口: InitializingBean
      2. 初始化前后置处理接口: BeanPostProcesser

  - 存入缓存

    将生成的Bean存入缓存

## 具体流程

### 注解

**属性注入--AutoWired**

```java
/**
 * 属性注入的标识类
 * 由于只是起标识作用,只需确定其着落点和作用范围即可
 * 本身无逻辑处理
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Autowired {
}
```



**Bean声明--Component**

```java
/**
 * 声明当前类要交由Spring管理
 * 其value值为Bean的名称
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Component {
    String value() default "";
}

```



**自动扫描--ComponentScan**

```java
/**
 * 组件扫描范围注解
 * value值为扫描范围,一个包名
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface ComponentScan {
    String value() default "";
}

```



**有效范围--Scope**

```java
/**
 * 标识当前类是单例还是别的什么
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Scope {
    String value() default ScopeType.SINGLETON;
}

```



### Bean相关

**Bean定义--BeanDefinition**

```java
/**
 * 封装一个Bean的定义
 * 包括
 *  bean Name, 类, 范围
 */
@Data
public class BeanDefinition {
    String beanName;
    Class<?> classType;
    String scope;
}

```



**初始化前后处理--BeanPostProcessor**

```java
/**
 * 初始化前后处理的接口
 */
public interface BeanPostProcessor {
    default Object postProcessBeforeInitialization(Object bean, String beanName){
        return bean;
    }
    default Object postProcessAfterInitialization(Object bean, String beanName){
        return bean;
    }
}

```



**初始化标识--InitializingBean**

```java
/**
 * 初始化接口,Bean继承该接口可以自定义属性注入后的初始化方法
 */
public interface InitializingBean {
    void afterPropertiesSet() throws Exception;
}
```



**范围类型--ScopeType**

```java
/**
 * 范围常量类
 */
public class ScopeType {
    public static final String SINGLETON = "singleton";
    public static final String PROTOTYPE = "prototype";
}

```



### 异常类

**Bean相关异常--BeanException**

```java
/**
 * Bean相关异常类
 */
public class BeanException extends RuntimeException{
    public BeanException(String message) {
        super(message);
    }
}

```



### 容器

**AnnotationConfigApplicationContext**

```java
package com.boranget.spring.context;

import com.boranget.spring.annotation.Autowired;
import com.boranget.spring.annotation.Component;
import com.boranget.spring.annotation.ComponentScan;
import com.boranget.spring.annotation.Scope;
import com.boranget.spring.bean.BeanDefinition;
import com.boranget.spring.bean.BeanPostProcessor;
import com.boranget.spring.bean.InitializingBean;
import com.boranget.spring.bean.ScopeType;
import com.boranget.spring.exception.BeanException;

import java.beans.Introspector;
import java.io.File;
import java.lang.reflect.Field;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 容器类,负责管理Bean的生命周期
 */
public class AnnotationConfigApplicationContext {
    /**
     * 负责配置当前容器的配置类
     */
    private final Class<?> configClass;
    /**
     * 存放扫描出来的Bean的定义
     */
    private Map<String, BeanDefinition> beanDefinitionMap = new ConcurrentHashMap<>(16);
    /**
     * 存放单例模式的Bean
     */
    private Map<String, Object> singletonObjects = new ConcurrentHashMap<>(16);
    /**
     * 存放扫描出来的Bean的初始化处理器
     */
    private List<BeanPostProcessor> beanPostProcessors = new ArrayList<>();


    /**
     * 本容器的构造方法
     * 在构造容器的同时完成Bean的生命周期
     *
     * @param configClass 配置类
     */
    public AnnotationConfigApplicationContext(Class<?> configClass) {
        this.configClass = configClass;
        // 扫描包路径,将符合条件的类(@Component注解标注的)注册,将bean信息转换成BeanDefinition
        // 并存入beanDefinitionMap
        doScan();
        // 寻找map中具有特殊意义的Bena,优先处理
        handlerBean();
        // 实例化:单例对象(非懒加载),将实例化完成的对象存入singletonObjects
        initializeNotLazyBean();
    }


    /**
     * 扫描包路径中的所有Bean,将其信息封装入BeanDefinition并存入map
     */
    private void doScan() {
        // 判断当前配置类是否为配置类
        if (!configClass.isAnnotationPresent(ComponentScan.class)) {
            return;
        }
        // 获取其标注的注解
        ComponentScan componentScan = configClass.getAnnotation(ComponentScan.class);
        // 获取注解中的属性:扫描范围
        String packageName = componentScan.value();
        // 将获取到的包名字符串改为路径名 replace注意正则表达式: . 为任意字符 \.为将.转义
        String filePath = packageName.replaceAll("\\.", "/");
        // 获取当前类的类加载器,用以获取资源URL
        ClassLoader classLoader = this.getClass().getClassLoader();
        // 类加载器解析路径名获取资源的URL
        URL resource = classLoader.getResource(filePath);
        // 从URL中获取资源路径
        String fileStr = resource.getFile();
        // 通过资源路径建立文件,这里是包所在的文件夹
        File scanPackageFolder = new File(fileStr);

        // 如果是个文件夹(是个包)则处理
        if (scanPackageFolder.isDirectory()) {
            // 调用处理操作
            ScanAndRegisterBeansInThisPackageFolder(scanPackageFolder, packageName);
        }
    }

    /**
     * 扫描加注册操作,由于需要递归处理文件夹所以抽离了出来
     *
     * @param packageFolder
     * @param packageName
     */
    private void ScanAndRegisterBeansInThisPackageFolder(File packageFolder, String packageName) {
        // 获取文件夹下所有文件
        File[] files = packageFolder.listFiles();
        for (File currentFile : files) {
            // 如果当前文件是个文件夹,则递归处理
            if (currentFile.isDirectory()) {
                ScanAndRegisterBeansInThisPackageFolder(currentFile, packageName + "." + currentFile.getName());
            } else {
                // 获取全类名
                String className = packageName + "." + currentFile.getName().replaceAll(".class", "");
                Class<?> currentClass = null;
                try {
                    // 通过类名获取类信息
                    currentClass = Class.forName(className);
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }
                // 如果当前类有标注@Component,则将其注册
                if (currentClass.isAnnotationPresent(Component.class)) {
                    // 获取Component注解
                    Component component = currentClass.getAnnotation(Component.class);
                    // 查看是否有指定name
                    String beanName = component.value().trim();
                    // 如果没有指定beanName
                    if (beanName.equals("")) {
                        //Generate BeanName By Class's SimpleName
                        beanName = Introspector.decapitalize(currentClass.getSimpleName());
                    }
                    // 获取当前类的范围
                    String scopeValue = ScopeType.SINGLETON;
                    if (currentClass.isAnnotationPresent(Scope.class)) {
                        scopeValue = currentClass.getAnnotation(Scope.class).value();

                    }
                    // 封装
                    // 封装Bean定义为BeanDefinition 同时保存到BeanDefinitionMap
                    BeanDefinition beanDefinition = new BeanDefinition();
                    beanDefinition.setBeanName(beanName);
                    beanDefinition.setClassType(currentClass);
                    beanDefinition.setScope(scopeValue);
                    beanDefinitionMap.put(beanName, beanDefinition);

                }

            }


        }
    }


    /**
     * 实例化Bean
     */
    private void initializeNotLazyBean() {
        // 遍历Bean定义
        for (Map.Entry<String, BeanDefinition> beanDefinitionEntry : beanDefinitionMap.entrySet()) {
            // 获取定义
            BeanDefinition beanDefinition = beanDefinitionEntry.getValue();
            // 如果是单例范围,则创建
            if (ScopeType.SINGLETON.equals(beanDefinition.getScope())) {
                Object bean = findOrCreateBean(beanDefinition);

            }
        }
    }

    /**
     * 优先处理有特殊作用的Bean
     */
    private void handlerBean() {
        for (BeanDefinition beanDefinition : beanDefinitionMap.values()) {
            Class<?> classType = beanDefinition.getClassType();
            String beanName = beanDefinition.getBeanName();
            // 父类.isAssignableFrom(子类)
            if (BeanPostProcessor.class.isAssignableFrom(classType)) {
                beanPostProcessors.add((BeanPostProcessor) getBean(beanName));
            }
        }

    }

    /**
     * 找到或创建bean
     * <p>
     * 从缓存中获取一个Bean,如果没有则进行创建
     *
     * @param beanDefinition bean定义
     * @return {@link Object}
     */
    private Object findOrCreateBean(BeanDefinition beanDefinition) {
        String beanName = beanDefinition.getBeanName();
        // 如果已经有了就不再创建
        if (singletonObjects.containsKey(beanName)) {
            return singletonObjects.get(beanName);
        }
        // 如果没有,则进行创建
        Object bean = createNewBean(beanDefinition);
        singletonObjects.put(beanName, bean);
        return bean;
    }

    /**
     * 创建新bean
     *
     * @param beanDefinition bean定义
     * @return {@link Object}
     */
    private Object createNewBean(BeanDefinition beanDefinition) {
        // 最后会返回的Bean
        Object exposedObject = null;
        try {
            // 获取类
            Class<?> classType = beanDefinition.getClassType();
            // 通过类的构造器创建新的实例
            Object instance = classType.getConstructor().newInstance();
            // 填充类的属性
            populateBean(instance, beanDefinition);
            // 做初始化操作
            exposedObject = initializing(instance, beanDefinition);
        } catch (Exception e) {
            e.printStackTrace();
            throw new BeanException(beanDefinition.getBeanName() + "创建失败");
        }
        //返回Bean
        return exposedObject;
    }


    /**
     * 填充bean属性
     *
     * @param instance       实例
     * @param beanDefinition bean定义
     */
    private void populateBean(Object instance, BeanDefinition beanDefinition) {
        // 获取bean类信息
        Class<?> classType = beanDefinition.getClassType();
        // 获取其中所有被声明的属性
        Field[] declaredFields = classType.getDeclaredFields();
        try {
            // 遍历所有属性
            for (Field declaredField : declaredFields) {
                // 如果该属性被@Autowired标注则进行属性注入
                if (declaredField.isAnnotationPresent(Autowired.class)) {
                    // 获取属性的类的类名
                    String simpleName = declaredField.getType().getSimpleName();
                    // 通过属性的类名获取其Bean的名称,这里只能使用默认的类名驼峰作为Bean名,
                    // 无法通过自己配置的Bean名注入
                    String fieldBeanName = Introspector.decapitalize(simpleName);
                    // 根据bean名获取bean
                    Object fieldBean = getBean(fieldBeanName);
                    // 配置可访问,避免有私有属性无法注入
                    declaredField.setAccessible(true);
                    // 注入
                    declaredField.set(instance, fieldBean);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new BeanException(beanDefinition.getBeanName() + "填充属性失败");
        }
    }
//    private Object initializing(Object instance, BeanDefinition beanDefinition) throws Exception {
//        Object rs = postProcessBeforeInitialization(instance, beanDefinition);
//        if (rs != null) {
//            // 为啥这里不为空要返回而不是继续处理
//            return rs;
//        }
//        if (instance instanceof InitializingBean) {
//            ((InitializingBean) instance).afterPropertiesSet();
//        }
//        rs = postProcessAfterInitialization(instance, beanDefinition);
//        if (rs != null) {
//            return rs;
//        }
//        return instance;
//
//    }


    /**
     * 自己修正后的初始化操作
     * 与老师的版本不同的是,初始化的前后置处理会直接影响实例并保留
     *
     * @param instance       实例
     * @param beanDefinition bean定义
     * @return {@link Object}
     * @throws Exception 异常
     */
    private Object initializing(Object instance, BeanDefinition beanDefinition) throws Exception {
        // 做初始化前置操作
        instance = postProcessBeforeInitialization(instance, beanDefinition);
        if (instance == null) {
            // 为空则不再处理
            return instance;
        }
        // 进行初始化操作
        if (instance instanceof InitializingBean) {
            ((InitializingBean) instance).afterPropertiesSet();
        }
        // 初始化后置操作
        instance = postProcessAfterInitialization(instance, beanDefinition);
        if (instance == null) {
            return instance;
        }
        // 返回初始化完的实例
        return instance;

    }

    /**
     * 在初始化过程
     *
     * @param instance       实例
     * @param beanDefinition bean定义
     * @return {@link Object}
     */
    private Object postProcessBeforeInitialization(Object instance, BeanDefinition beanDefinition) {
        // 如果他本身是个处理器对象,则不做处理
        if (instance instanceof BeanPostProcessor) {
            return instance;
        }
        // 遍历所有的处理器对象依次处理
        for (BeanPostProcessor beanPostProcessor : beanPostProcessors) {
            instance = beanPostProcessor.postProcessBeforeInitialization(instance, beanDefinition.getBeanName());
            // 如果有一步返回的对象为空则不再往下进行
            if (instance == null) {
                return instance;
            }
        }
        return instance;
    }

    /**
     * 发布过程初始化后
     *
     * @param instance       实例
     * @param beanDefinition bean定义
     * @return {@link Object}
     */
    private Object postProcessAfterInitialization(Object instance, BeanDefinition beanDefinition) {
        // 如果他本身是个处理器对象,则不做处理
        if (instance instanceof BeanPostProcessor) {
            return instance;
        }
        for (BeanPostProcessor beanPostProcessor : beanPostProcessors) {
            instance = beanPostProcessor.postProcessAfterInitialization(instance, beanDefinition.getBeanName());
            if (instance != null) {
                return instance;
            }
        }
        return instance;
    }


    /**
     * 获取一个Bean
     *
     * @param beanName bean名字
     * @return {@link Object}
     */
    public Object getBean(String beanName) {
        // 如果说根本没有这个bean的定义则报错
        if (!beanDefinitionMap.containsKey(beanName)) {
            throw new BeanException("找不到Bean定义:" + beanName);
        }
        // 获取定义
        BeanDefinition beanDefinition = beanDefinitionMap.get(beanName);
        // 如果是个单例范围
        if (ScopeType.SINGLETON.equals(beanDefinition.getScope())) {
            // 查找或获取一个Bean
            return findOrCreateBean(beanDefinition);
        } else {
            // 直接创建一个新的Bean
            return createNewBean(beanDefinition);
        }
    }
}

```

# Spring层次图

![image-20221017101507045](spring/image-20221017101507045.png)

# 结构体系

## BeanFactory结构体系

**BeanFactory**

所有spring Bean容器的根接口,提供了一些列获取Bean的重载方法,(支持懒加载Object Provider),提供了判断是不是单例,或者是不是原型,类型是不是匹配这样的接口.

![image-20221017141341787](spring/image-20221017141341787.png)

**ListableBeanFactory**

BeanFactory的扩展接口,主要提供了获取BeanName数组,以BeanName为Key的Map,获取指定注解BeanName数组或Map,通过Bean和注解的额类型获取指定注解.

**HierarchicalBeanFactory**

分等级的Bean工厂

: 判断当前工厂中是否存在这个Bean

: 获取父工厂

**ConfigurableBeanFactory**

Bean Factory体系中的配置Bean工厂,提供了工厂中基础设施的配置方法,为框架内部提供了一个可插拔的使用方式.

**AutoWireCapableBeanFactory**

具有自动注入能力的工厂,主要将Spring本身管理Bean生命周期的能力给暴露出来,给外部框架使用,暴露了一系列管理Bena生命周期的接口

Application Context没有继承该接口,dan可以通过方法来暴露该能力

**ConfigurableListableBeanFactory**

BeanFactory体系中的配置接口,是对ConfigurabeBeanFactory的扩展,主要提供了对于分析,修改BeanDefinition的基础设置,对于单例的预加载

**DefaultLIstableBeanFactory**

![image-20221017145926608](spring/image-20221017145926608.png)

## 注册类接口体系

**AliasRegistry**

别名注册

**SingletonBeanRegistry**

```java
public interface SingletonBeanRegistry {
	//注册单例
	void registerSingleton(String beanName, Object singletonObject);

	// 通过单例名获取单例
	@Nullable
	Object getSingleton(String beanName);

	// 是否包含此单例
	boolean containsSingleton(String beanName);
	// 获取单例名称数组
	String[] getSingletonNames();

	// 获取单例数量
	int getSingletonCount();

	// 获取一个锁?
	Object getSingletonMutex();

}

```

默认实现

```java

public class DefaultSingletonBeanRegistry extends SimpleAliasRegistry implements SingletonBeanRegistry {

	/** Cache of singleton objects: bean name to bean instance. */
	private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256);

	/** Cache of singleton factories: bean name to ObjectFactory. */
	private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16);

	/** Cache of early singleton objects: bean name to bean instance. */
	private final Map<String, Object> earlySingletonObjects = new HashMap<>(16);

	/** Set of registered singletons, containing the bean names in registration order. */
	private final Set<String> registeredSingletons = new LinkedHashSet<>(256);

	/** Names of beans that are currently in creation. */
	private final Set<String> singletonsCurrentlyInCreation =
			Collections.newSetFromMap(new ConcurrentHashMap<>(16));

	/** Names of beans currently excluded from in creation checks. */
	private final Set<String> inCreationCheckExclusions =
			Collections.newSetFromMap(new ConcurrentHashMap<>(16));

	/** List of suppressed Exceptions, available for associating related causes. */
	@Nullable
	private Set<Exception> suppressedExceptions;

	/** Flag that indicates whether we're currently within destroySingletons. */
	private boolean singletonsCurrentlyInDestruction = false;

	/** Disposable bean instances: bean name to disposable instance. */
	private final Map<String, Object> disposableBeans = new LinkedHashMap<>();

	/** Map between containing bean names: bean name to Set of bean names that the bean contains. */
	private final Map<String, Set<String>> containedBeanMap = new ConcurrentHashMap<>(16);

	/** Map between dependent bean names: bean name to Set of dependent bean names. */
	private final Map<String, Set<String>> dependentBeanMap = new ConcurrentHashMap<>(64);

	/** Map between depending bean names: bean name to Set of bean names for the bean's dependencies. */
	private final Map<String, Set<String>> dependenciesForBeanMap = new ConcurrentHashMap<>(64);


```

**BeanDefinitionRegistry**



![image-20221017155036882](spring/image-20221017155036882.png)



## ApplicationContext结构体系

一个门面类,集成了丰富的功能,集成了接口但不亲自实现

**ApplicationContext**

关键方法

```java
public interface ApplicationContext extends EnvironmentCapable, ListableBeanFactory, HierarchicalBeanFactory,
		MessageSource, ApplicationEventPublisher, ResourcePatternResolver {
         
	ApplicationContext getParent();
	
	AutowireCapableBeanFactory getAutowireCapableBeanFactory() throws IllegalStateException;

}
```

![image-20221017171728082](spring/image-20221017171728082.png)

**EnvironmentCapable**

增加了环境的配置功能

**ResourceLoader**

增加了资源加载的功能,重点关注策略接口

**MessageSource**

主要提供了国际化的功能,策略接口

**ApplicationEventPublisher**

提供了应用事件的发布功能,负责传递事件给ApplicationEventMulticaster

**ConfiguableApplicationContext**

```java

public interface ConfigurableApplicationContext extends ApplicationContext, Lifecycle, Closeable {

	void setId(String id);

	void setParent(@Nullable ApplicationContext parent);

	void setEnvironment(ConfigurableEnvironment environment);

	@Override
	ConfigurableEnvironment getEnvironment();


	void addBeanFactoryPostProcessor(BeanFactoryPostProcessor postProcessor);


	void addApplicationListener(ApplicationListener<?> listener);

	void addProtocolResolver(ProtocolResolver resolver);


	void refresh() throws BeansException, IllegalStateException;


	void registerShutdownHook();

	@Override
	void close();
	boolean isActive();

	ConfigurableListableBeanFactory getBeanFactory() throws IllegalStateException;

}

```

## SpringResource结构体系

**ResourceLoader**

```java
public interface ResourceLoader {

	
	String CLASSPATH_URL_PREFIX = "classpath:";


	// 通过传入的路径获取一个资源
	Resource getResource(String location);
	
	// 获取一个类加载器
	@Nullable
	ClassLoader getClassLoader();
}
```

**ResourcePatternResolver**

```java
public interface ResourcePatternResolver extends ResourceLoader {

	// 带*,获取所有jar下classpath下的资源文件
	String CLASSPATH_ALL_URL_PREFIX = "classpath*:";

	// 通过正则表达式路径获取一个资源数组
	Resource[] getResources(String locationPattern) throws IOException;

}
public interface ConfigurableApplicationContext extends ApplicationContext, Lifecycle, Closeable {
	// ...
    // 增加一个协议处理器
	void addProtocolResolver(ProtocolResolver resolver);
}
```

**Resource**

Resource是对Spring底层资源的抽象,定义了一系列通用操作和属性，屏蔽了底层操作细节

资源对象：

- InputStream,获取资源文件的内容-》解析内容，业务操作
- URL 统一资源定位
- 其他通用操作

关键方法：

```java
public interface InputStreamSource {
	InputStream getInputStream() throws IOException;
}

public interface Resource extends InputStreamSource {

	boolean exists();

	default boolean isReadable() {
		return exists();
	}

	default boolean isOpen() {
		return false;
	}

	default boolean isFile() {
		return false;
	}
	// 资源定位路径
	URL getURL() throws IOException;

	URI getURI() throws IOException;
	//资源是文件就返回一个文件
	File getFile() throws IOException;

	default ReadableByteChannel readableChannel() throws IOException {
		return Channels.newChannel(getInputStream());
	}

	long contentLength() throws IOException;

	long lastModified() throws IOException;

	Resource createRelative(String relativePath) throws IOException;

	@Nullable
	String getFilename();

	String getDescription();

}

```

**Java中如何处理资源**

URL:

resource location - > URL - >URLStreamHandler(协议:file, jar, war, http, httpsm ftp......) - > openConnection() - > getInputStream();

ClassLoarder:

其中的获取Resourece其实是返回一个URL

**Spring为何要封装一个Resource接口**

- Java Resource相关没有提供一些功能比如:描述, 可读性, 是否打开......
- 复杂性
  - java自定义协议比较复杂 

**Spring的内建资源**

- URL Resource

  对于java URL的实现

-  ClassPathRescource

  针对ClassPath中的资源的实现

- FileSystemResource

  文件系统资源

- ByteArrayResource

- InputStreamResource

- ServletContextResource

  针对于ServletContext对应资源的封装

## BeanDefinition 结构

### 1、 什么是BeanDefinition

简单来说，针对由开发人员提供的配置元数据（configuration metadata）的统一抽象，

配置元数据包括：bean相关的基础属性（ClassBane，beanName）bean行为相关的属性（Scope，生命周期相关回调方法，自动注入的模式），bean相关的依赖属性。

**The bean definition**

| Property                 | Explained in...                                              |
| ------------------------ | ------------------------------------------------------------ |
| class                    | [Section 5.3.2, “Instantiating beans”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-class) |
| name                     | [Section 5.3.1, “Naming beans”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-beanname) |
| scope                    | [Section 5.5, “Bean scopes”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-scopes) |
| constructor arguments    | [Section 5.4.1, “Dependency injection”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-collaborators) |
| properties               | [Section 5.4.1, “Dependency injection”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-collaborators) |
| autowiring mode          | [Section 5.4.5, “Autowiring collaborators”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-autowire) |
| lazy-initialization mode | [Section 5.4.4, “Lazy-initialized beans”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-lazy-init) |
| initialization method    | [the section called “Initialization callbacks”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-lifecycle-initializingbean) |
| destruction method       | [the section called “Destruction callbacks”](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/beans.html#beans-factory-lifecycle-disposablebean) |

![image-20221024140642455](spring/image-20221024140642455.png)

### 2. BeanDefinition扩展

BeanDefinition的扩展：BeanFactoryPostProcessor

Spring容器的三大扩展点：{BeanPostProcesser， BeanFactoryPostProcessor， FactoryBean}

## Spring源码走读

### 初始化操作

```java
public AnnotationConfigApplicationContext(Class<?>... componentClasses) {
		this();
		register(componentClasses);
		refresh();
	}


public AnnotationConfigApplicationContext() {
		this.reader = new AnnotatedBeanDefinitionReader(this);
		this.scanner = new ClassPathBeanDefinitionScanner(this);
	}
```

子类的无参构造方法会先调用父类的无参构造方法 

```java
public GenericApplicationContext() {
		this.beanFactory = new DefaultListableBeanFactory();
	}

// 初始化扩充资源加载器
public AbstractApplicationContext() {
		this.resourcePatternResolver = getResourcePatternResolver();
	}


public DefaultResourceLoader() {
		this.classLoader = ClassUtils.getDefaultClassLoader();
	}
// 获取默认加载器
	public static ClassLoader getDefaultClassLoader() {
		ClassLoader cl = null;
		try {
			cl = Thread.currentThread().getContextClassLoader();
		}
		catch (Throwable ex) {
			// Cannot access thread context ClassLoader - falling back...
		}
		if (cl == null) {
			// No thread context class loader -> use class loader of this class.
			cl = ClassUtils.class.getClassLoader();
			if (cl == null) {
				// getClassLoader() returning null indicates the bootstrap ClassLoader
				try {
					cl = ClassLoader.getSystemClassLoader();
				}
				catch (Throwable ex) {
					// Cannot access system ClassLoader - oh well, maybe the caller can live with null...
				}
			}
		}
		return cl;
	}
```

整体过程:

初始化类加载器——》初始化扩展资源加载器——》初始化IOC容器（Factory）——》Reader，Scanner初始化——》AnnotationConfigApplicationContext的构造方法

### 注册程序主配置类

```java
public AnnotationConfigApplicationContext(Class<?>... componentClasses) {
		this();
		register(componentClasses);
		refresh ();
	}
```

```java
private <T> void doRegisterBean(Class<T> beanClass, @Nullable String name,
			@Nullable Class<? extends Annotation>[] qualifiers, @Nullable Supplier<T> supplier,
			@Nullable BeanDefinitionCustomizer[] customizers) {
		// 创建Bean定义
		AnnotatedGenericBeanDefinition abd = new AnnotatedGenericBeanDefinition(beanClass);
	// 判断是否符合条件,不符合就跳过	
    if (this.conditionEvaluator.shouldSkip(abd.getMetadata())) {
			return;
		}
		
		abd.setInstanceSupplier(supplier);
    	// 获取Scope元数据
		ScopeMetadata scopeMetadata = this.scopeMetadataResolver.resolveScopeMetadata(abd);			
	// 设置Scope	
    abd.setScope(scopeMetadata.getScopeName());
	// 创建BenaName	
    String beanName = (name != null ? name : this.beanNameGenerator.generateBeanName(abd, this.registry));
		// 一些注解属性的设置
		AnnotationConfigUtils.processCommonDefinitionAnnotations(abd);
		if (qualifiers != null) {
			for (Class<? extends Annotation> qualifier : qualifiers) {
				if (Primary.class == qualifier) {
					abd.setPrimary(true);
				}
				else if (Lazy.class == qualifier) {
					abd.setLazyInit(true);
				}
				else {
					abd.addQualifier(new AutowireCandidateQualifier(qualifier));
				}
			}
		}
		if (customizers != null) {
			for (BeanDefinitionCustomizer customizer : customizers) {
				customizer.customize(abd);
			}
		}
		// 创建Holder
		BeanDefinitionHolder definitionHolder = new BeanDefinitionHolder(abd, beanName);
    	// 应用代理模式,如果需要代理,注入一个Scope.BeanName
		definitionHolder = AnnotationConfigUtils.applyScopedProxyMode(scopeMetadata, definitionHolder, this.registry);
    	// 注册定义
		BeanDefinitionReaderUtils.registerBeanDefinition(definitionHolder, this.registry);
	}
```

### 刷新/应用上下文启动

接口方法定义:ConfigurableApplicationContext

方法实现:AbstractApplicationContext

```java
public void refresh() throws BeansException, IllegalStateException {
		synchronized (this.startupShutdownMonitor) {
			// Prepare this context for refreshing.
            // 准备工作
			prepareRefresh();

			// Tell the subclass to refresh the internal bean factory.
            // 获取一个bean工厂,工厂不存在则创建 
			ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();

			// Prepare the bean factory for use in this context.
            // 工厂准备工作,核心组件的设置,包括BeanPostProcesser
			prepareBeanFactory(beanFactory);

			try {
				// Allows post-processing of the bean factory in context subclasses.
                // 子类应用上下文对于工厂的准备阶段
				postProcessBeanFactory(beanFactory);

				// Invoke factory processors registered as beans in the context.
				invokeBeanFactoryPostProcessors(beanFactory);

				// Register bean processors that intercept bean creation.
				registerBeanPostProcessors(beanFactory);

				// Initialize message source for this context.
				initMessageSource();

				// Initialize event multicaster for this context.
				initApplicationEventMulticaster();

				// Initialize other special beans in specific context subclasses.
				onRefresh();

				// Check for listener beans and register them.
				registerListeners();

				// Instantiate all remaining (non-lazy-init) singletons.
				finishBeanFactoryInitialization(beanFactory);

				// Last step: publish corresponding event.
				finishRefresh();
			}

			catch (BeansException ex) {
				if (logger.isWarnEnabled()) {
					logger.warn("Exception encountered during context initialization - " +
							"cancelling refresh attempt: " + ex);
				}

				// Destroy already created singletons to avoid dangling resources.
				destroyBeans();

				// Reset 'active' flag.
				cancelRefresh(ex);

				// Propagate exception to caller.
				throw ex;
			}

			finally {
				// Reset common introspection caches in Spring's core, since we
				// might not ever need metadata for singleton beans anymore...
				resetCommonCaches();
			}
		}
	}
```

![image-20221107161945361](spring/image-20221107161945361.png)

? 默认的定义是在哪里注册的

### BeanDefination 扫描&注册

入口：org.springframework.context.support.AbstractApplicationContext#invokeBeanFactoryPostProcessors

ConfigurationClassPostProcessor 实现了接口 BeanDefinitionRegistryPostProcessor

```java
public interface BeanDefinitionRegistryPostProcessor extends BeanFactoryPostProcessor {

	/**
	 * Modify the application context's internal bean definition registry after its
	 * standard initialization. All regular bean definitions will have been loaded,
	 * but no beans will have been instantiated yet. This allows for adding further
	 * bean definitions before the next post-processing phase kicks in.
	 * @param registry the bean definition registry used by the application context
	 * @throws org.springframework.beans.BeansException in case of errors
	 */
	void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) throws BeansException;

}

```

   关键获取定义的地方

```java
protected void processConfigurationClass(ConfigurationClass configClass) throws IOException {
		// ................
		SourceClass sourceClass = asSourceClass(configClass);
		do {
            // 在这里进行具体的定义获取
			sourceClass = doProcessConfigurationClass(configClass, sourceClass);
		}
		while (sourceClass != null);

		this.configurationClasses.put(configClass, configClass);
	}

	@Nullable
	protected final SourceClass doProcessConfigurationClass(ConfigurationClass configClass, SourceClass sourceClass)
			throws IOException {
		// 其他的一些注解的扫描处理
		//....................

		// Process any @ComponentScan annotations
        // 获取所有的ComponentScan注解
		Set<AnnotationAttributes> componentScans = AnnotationConfigUtils.attributesForRepeatable(
				sourceClass.getMetadata(), ComponentScans.class, ComponentScan.class);
        // 如果注解列表不为空
		if (!componentScans.isEmpty() &&
				!this.conditionEvaluator.shouldSkip(sourceClass.getMetadata(), ConfigurationPhase.REGISTER_BEAN)) {
            // 遍历所有componentScan注解
			for (AnnotationAttributes componentScan : componentScans) {
				// The config class is annotated with @ComponentScan -> perform the scan immediately
                // 根据注解获取对应的Bean定义
				Set<BeanDefinitionHolder> scannedBeanDefinitions =
						this.componentScanParser.parse(componentScan, sourceClass.getMetadata().getClassName());
				// Check the set of scanned definitions for any further config classes and parse recursively if needed
                // 判断扫描进来的注解有没有别的配置需要扫描
				for (BeanDefinitionHolder holder : scannedBeanDefinitions) {
					BeanDefinition bdCand = holder.getBeanDefinition().getOriginatingBeanDefinition();
					if (bdCand == null) {
						bdCand = holder.getBeanDefinition();
					}
					if (ConfigurationClassUtils.checkConfigurationClassCandidate(bdCand, this.metadataReaderFactory)) {
						parse(bdCand.getBeanClassName(), holder.getBeanName());
					}
				}
			}
		}
    }
```

# @Import注解

## 引入其他的configuration 

```java
package com.test
interface ServiceInterface {
    void test();
}

class ServiceA implements ServiceInterface {

    @Override
    public void test() {
        System.out.println("ServiceA");
    }
}

class ServiceB implements ServiceInterface {

    @Override
    public void test() {
        System.out.println("ServiceB");
    }
}
```

```java
package com.test
@Import(ConfigB.class)
@Configuration
class ConfigA {
    @Bean
    @ConditionalOnMissingBean
    public ServiceInterface getServiceA() {
        return new ServiceA();
    }
}

@Configuration
class ConfigB {
    @Bean
    @ConditionalOnMissingBean
    public ServiceInterface getServiceB() {
        return new ServiceB();
    }
}
```

```java
public static void main(String[] args) {
    // 这里使用A类来构造容器，会发现最后的输出是ServiceB，这里证明Import不止可以引入配置，并且优先级比当前类中配置更高
    ApplicationContext ctx = new AnnotationConfigApplicationContext(ConfigA.class);
    ServiceInterface bean = ctx.getBean(ServiceInterface.class);
    bean.test();
}
```

## 直接引入Bean

自Spring4.2后，如果在上面的Import中改为@Import(ServiceB.class)可以直接将ServiceB作为Bean引入而无需通过Configuration引入。

同样的还是会优先于当前配置（如果冲突的话）

## Selector

实现 ImportSelector 或者DefferredServiceImportSelector的类，需要实现selectImports方法，返回一个字符串数组，其中元素是要引入的configuration或者bean类的全限定类名

