---
title: SpringSecurity
date: 2023-01-03 16:50:30
tags:
  - spring security
categories:
  - 笔记
---

#  HTTP Basic 登陆模式

SS实现登录认证最简单的一种方式，密码相当于明文传输，防君子不防小人

适合守护不是很重要的数据。

用户名密码经过组合并Base64加密后存入请求的Header中的Authorization中：

格式如: admin:password

 ```java
 http.httpBasic()//开启httpbasic
                 .and()
                 .authorizeRequests()
                 .anyRequest()
                 .authenticated();// 所有请求都需要登录认证才能访问
 ```



![image-20221202143656863](SpringSecurity/image-20221202143656863.png)

# PasswordEncoder

密码单向加密, 不比较原文, 而是比较加密后密文是否相等

encode(rawPassword) 用于加密

matches(comparePassword, encodePassword) 用于比较

## BCryptPasswordEncoder

同一个原始密码,每一次加密结果不同，但仍然可用match，添加随机盐值的原因应该是防止单向加密的撞库

60位字符串 组成:

```
$2a // 算法版本
$10 // 算法强度
$............前22位 // 随机盐
.................. // hash值
$2a $10 $1u8dKM3NSo8DnnJuVjhTYe VvHrlw.uXUS8k/hmsR8OXkf2mO5oi6q
```

# FormLogin登录认证模式

## 关键概念

- formLogin登录认证不写Controller方法
- 使用UsernamePasswordAuthenticationFilter过滤器来进行登录认证
- 该过滤器默认集成，但需要配置

## 配置

- 登录认证逻辑
  - 登录URL
  - 如何接收登陆参数
  - 登陆成功后逻辑
- 资源访问控制
  - 什么角色访问什么资源
- 用户角色权限
  - 用户拥有什么角色

### 登录认证逻辑

```java
 http.csrf().disable()
                .formLogin()
                    .loginPage("/login.html")
                    .loginProcessingUrl("/login")
                    .usernameParameter("username")
                    .passwordParameter("password")
                    .defaultSuccessUrl("/")
```



### 资源访问控制

角色是一种特殊的权限

hasAnyAuthority("ROLE_user")

等价于

hasAnyRole("user")

其中 ROLE 为固定前缀

```java
.authorizeRequests()
                    .antMatchers("/login.html","/login")
                        .permitAll()
                    .antMatchers("/","biz1","biz2")
                        .hasAnyAuthority("ROLE_user","ROLE_admin")
                    .antMatchers("/syslog","/sysuser")
                        .hasAnyRole("admin")
//                    .antMatchers("syslog").hasAuthority("sys:log")
//                    .antMatchers("sysuser").hasAuthority("sys:user")
```



### 用户角色权限

```java
 @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        super.configure(auth);
        auth.inMemoryAuthentication()
                .withUser("user")
                .password(getPasswordEncoder().encode("123456"))
                .roles("user")
            .and()
                .withUser("admin")
                .password(getPasswordEncoder().encode("123456"))
                .roles("admin")
//                .authorities("sys:log","sys:user")
            .and()
                .passwordEncoder(getPasswordEncoder());
    }
    @Bean
    public PasswordEncoder getPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }
```

##  静态资源配置

静态资源不经过过滤器

```java
@Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        super.configure(auth);
        auth.inMemoryAuthentication()
                .withUser("user")
                .password(getPasswordEncoder().encode("123456"))
                .roles("user")
            .and()
                .withUser("admin")
                .password(getPasswordEncoder().encode("123456"))
                .roles("admin")
//                .authorities("sys:log","sys:user")
            .and()
                .passwordEncoder(getPasswordEncoder());
    }
    @Bean
    public PasswordEncoder getPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }
```



## 总览

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    /**
     * 进行安全认证及授权规则配置
     *
     * @param http
     * @throws Exception
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        super.configure(http);
//        http.httpBasic()//开启httpbasic
//                .and()
//                .authorizeRequests()
//                .anyRequest()
//                .authenticated();// 所有请求都需要登录认证才能访问
        http.csrf().disable()
                .formLogin()
                    .loginPage("/login.html")
                    .loginProcessingUrl("/login")
                    .usernameParameter("username")
                    .passwordParameter("password")
                    .defaultSuccessUrl("/")
                .and()
                .authorizeRequests()
                    .antMatchers("/login.html","/login")
                        .permitAll()
                    .antMatchers("/","biz1","biz2")
                        .hasAnyAuthority("ROLE_user","ROLE_admin")
                    .antMatchers("/syslog","/sysuser")
                        .hasAnyRole("admin")
//                    .antMatchers("syslog").hasAuthority("sys:log")
//                    .antMatchers("sysuser").hasAuthority("sys:user")
        ;

    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        super.configure(auth);
        auth.inMemoryAuthentication()
                .withUser("user")
                .password(getPasswordEncoder().encode("123456"))
                .roles("user")
            .and()
                .withUser("admin")
                .password(getPasswordEncoder().encode("123456"))
                .roles("admin")
//                .authorities("sys:log","sys:user")
            .and()
                .passwordEncoder(getPasswordEncoder());
    }
    @Bean
    public PasswordEncoder getPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
//        super.configure(web);
        web.ignoring().antMatchers("/css/**","/fonts/**","/img/**","/js/**");
    }
}

```

# 登录认证流程

Authentication 登录认证主体对象

![image-20221202173134811](SpringSecurity/image-20221202173134811.png)

![image-20221202184017978](SpringSecurity/image-20221202184017978.png)

# 自定义登陆验证结果的处理

SavedRequestAwareAuthenticationSuccessHandler

可记住企图访问的地址，登陆成功后重定向

## 自定义验证结果处理器

yml配置文件中

```yml
spring:
 security:
    logintype: JSON
```



**成功处理器**

```java
/**
 * SavedRequestAwareAuthenticationSuccessHandler
 * 可记住企图访问的地址，登陆成功后重定向
 */
@Component
public class MyAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
    @Value("${spring.security.logintype}")
    private String loginType;
    private static ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) throws ServletException, IOException {
//        super.onAuthenticationSuccess(request, response, authentication);
        if(loginType.equalsIgnoreCase("JSON")){
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(AjaxResponse.success()));
        }else{
            super.onAuthenticationSuccess(request,response,authentication);
        }
    }
}
```

**失败处理器**

```java
@Component
public class MyAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {
    @Value("${spring.security.logintype}")
    private String loginType;
    private static ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {

        if(loginType.equalsIgnoreCase("JSON")){
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(AjaxResponse.useInputError("请检查输入是否正确")));
        }else{
            super.onAuthenticationFailure(request, response, exception);
        }
    }
}
```

## config中表单登陆配置

```java
 @Resource
    private MyAuthenticationSuccessHandler myAuthenticationSuccessHandler;
    @Resource
    private MyAuthenticationFailureHandler myAuthenticationFailureHandler;

 http.csrf().disable()
                .formLogin()
                    .loginPage("/login.html")
                    .loginProcessingUrl("/login")
                    .usernameParameter("username")
                    .passwordParameter("password")
     // 不使用默认成功页面而是使用处理器
//                    .defaultSuccessUrl("/")
                    .successHandler(myAuthenticationSuccessHandler)
                    .failureHandler(myAuthenticationFailureHandler)
```

**html中返回json处理**

```html
<script type="text/javascript">
    function loginhandle(){

        const username = $("#username").val();
        const password = $("#password").val();
        if(username == ""||password==""){
            alert("用户名或密码不能为空");
            return;
        }
        $.ajax({
            type:"POST",
            url:"/login",
            data:{
                "username":username,
                "password":password
            },
            success:function(json){
                if(json.isok){
                    location.href = '/';
                }else {
                    alert(json.message);
                    location.href='login.html';
                }
            },
            error:function (e){
                alert(e);
            }
        })
        return;
    }
</script>
<form>
    <span>用户名称</span><input type="text" name="username" id = "username"/> <br>
    <span>用户密码</span><input type="password" name="password"  id = "password"/> <br>
    <input type="button" value="登陆" onclick="loginhandle()">
</form>
```

# Session会话的安全管理

## Spring Security 中的session创建策略

- always 如果当前请求没有对应的session,则出样建一个session
- ifRequired(默认),在需要使用到session的时候chuangjiansession
- never 不会主动创建session,但会使用session
- statless 不创建也不使用

```java
.and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
```

## 会话超时

spring boot中

server.servlet.session

.timeout=15m

spring.session.timeout = 15m(需要引入 session包,优先级高,超时时间最短一分钟, 设置小于一分钟也是一分钟)

  ```java
  .and()
                  .sessionManagement()
                  .invalidSessionUrl("/")
  ```

## session保护

对同一个session用户,每次登录会创建一个新的session, 此时sessionID会改变,将旧的session内容复制到新的session中

- migrationSession(默认) 以上保护机制
- none 原始会话不失效
- newSession 创建新session,但不会复制

```java
                .and()
                .sessionManagement()
                .sessionFixation()
                .migrateSession()
//                .newSession()
//                .none()
```

## Cookie安全

httpOnly:true 浏览器脚本无法获取cookie

secure:true: 仅能通过HTTPS发送coolkie

# 被顶下线

```java
public class CustomExpiredSessionStrategy implements SessionInformationExpiredStrategy {
    // 页面跳转
    private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
    private ObjectMapper objectMapper = new ObjectMapper();
    @Override
    public void onExpiredSessionDetected(SessionInformationExpiredEvent event) throws IOException, ServletException {
        Map<String,Object> map = new HashMap<>();
        map.put("code",403);
        map.put("msg","被迫下线"+event.getSessionInformation().getLastRequest());
        event.getResponse().setContentType("application/json;charset=utf-8");
        event.getResponse().getWriter().write(objectMapper.writeValueAsString(map));
//         页面重定向
//        redirectStrategy.sendRedirect(event.getRequest(),event.getResponse(),"/");
    }
}
```

```java
                .and()
                .sessionManagement()
                // 允许同时只有几个用户登录
                .maximumSessions(1)
                // 已经登陆的用户是否允许在其他客户端登录
                .maxSessionsPreventsLogin(false)
                .expiredSessionStrategy(new CustomExpiredSessionStrategy())
```

# Remember me

## RememberMeToken

RememberMeToken = Base64（username + expiryTime + sinatureValue）

signatureValue = userName，expirationTime 和 password 和 一个预定义的key组合起来进行MD5签名得到

![image-20221207135722118](SpringSecurity/image-20221207135722118.png)

## http配置

```java
.and()
.rememberMe()
.rememberMeParameter("remember-me-ao")
.rememberMeCookieName("token-cookie")
.tokenValiditySeconds(60*60*24*2)
.tokenRepository(getPersistentTokenRepository())
    
```

```java
 @Resource
    private DataSource dataSource;
    @Bean
    public PersistentTokenRepository getPersistentTokenRepository(){
        JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
        tokenRepository.setDataSource(dataSource);
        return  tokenRepository;
    }
```

## 数据表固定配置

![image-20221204171706523](SpringSecurity/image-20221204171706523.png)

## 前端配置

```http
<form>
	<input type = "checkbox" name = "remember-me"/>记住密码
</form>
```

# RBAC

- 用户(User)
  - userRole 多2多
- 角色 (Role)
  - userMenu 多2多
- 权限(Menu/API)

![image-20221204184016878](SpringSecurity/image-20221204184016878.png)

# Spring动态加载用户角色权限

## 重写UserDetails

相当于一个实体类

## 重写UserDetailsService

重写**loadUserByUserName**方法，返回一个UserDeatils对象。

这里注意一下，传入的参数username就是config中配置的usernamePara配置的接收到的值

针对于RBAC模型中的角色，在spring中是一种特殊的权限，可以在值之前加“ROLE_”前缀放入权限集合

```java
List<String> roleCodes;
List<String> authorities;
// 批量处理
roleCodes = roleCodes.stream()
    		.map(
				rc -> "ROLE_" + rc
			)
    		.collect(Collectors.toList())
```

userDetails 列表中存储的并不是字符串格式,可做如下处理:

```java
authorities.addAll(roleCodes);
userDetails.setAuthorities(
    AuthorityUtils.commaSeparatedStringToAuthorityList(
	String.join(","authorities)
))
```



## configure配置

```java
// 注入userdetailservice
@Resource
MyUserDetailService mds;
auth.userDetailsService(mds).passwordEncoder(passwordEncoder())
```

# 动态加载鉴权规则

## 鉴权失败

```java
.and().exceptionHandling().accessDeniedHandler()
```

## 自定义鉴权规则

 ```java
@Component
public class MyRBACService{
	public boolean suibianqv(HttpServletRequest request, Authentication authentication){
        Object pricipal = authentication.getPrincipal();
        if(principal instanceof UserDetails){
            UserDetails userDestils = ((UserDetails)principal);
            SimpleGrantedAuthority  simpleGrantedAuthority = new SimpleGrantedAuthority(request.getRequestURI());
            return userDetails.getAuthorities().contains(simpleGantedAuthority);
        }
        return false;
    }
}
 ```

```java
and()
                .authorizeRequests()
                    .antMatchers("/login.html","/login")
                        .permitAll()
//                    .antMatchers("/","biz1","biz2")
//                        .hasAnyAuthority("ROLE_user","ROLE_admin")
//                    .antMatchers("/syslog","/sysuser")
//                        .hasAnyRole("admin")
                // 这里使用spel表达式
                .anyRequest().access("@myRBACService.suibianqv(request,authentication)")
```

# SpEL

## 表示或者

```spel
hasRole('admin') or hasAuthority('ROLE_admin') 
```

## 自定义验证逻辑和参数

```java
config.andMatch("/person/{id}")
    .access("r bacService.checkUserId(authentication,#id)")
    .anyRequest()
    .access("@rbacService.hasPermission(request,authentication)")
```

## 在方法上使用

需要开启配置

```java
@EnableGlobalMethodSecurity(prePostEnabled = true)
```



@PreAuthorize("SPEL")

@PreFilter("SPEL")

@PostAuthorize("SPEL")

@PostFilter("SPEL")

post类型的注解用于判断返回值

pre类型的注解用于判断传入的参数

filter可以操作list中的值,不满足会剔除

# 退出

config中

```java
http.logout();
```

前端

```html
<a href="/logout">退出</a>
```

## 默认行为

- 核心需求:当前的session失效,回收访问权限
- 删除当前用户的remember-me 的 cookie信息
- clear 清除当前的SecurityContext认证的上下文信息
- 重定向到登陆页面,loginPage配置项指定的页面

```java
 logout()
                .logoutUrl("/tuichu")
                .logoutSuccessUrl("http://www.baidu.com")
                .deleteCookies("JSESSIONID","token-cookie")
```

## loginOutHandler

```java
@Component
public class MyLogOutHandler implements LogoutSuccessHandler {
    @Override
    public void onLogoutSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        response.sendRedirect("/login");
    }   
}
```



```java
  logout()
//                .logoutUrl("/tuichu")
                .logoutSuccessUrl("http://www.baidu.com")
                .deleteCookies("JSESSIONID","token-cookie")
                .logoutSuccessHandler(myLogOutHandler)
```

# 概念

## 认证 

Authentication

登录，判断是否为系统合法用户

## 授权

Authorization

分配权限，判断该合法用户的权限

## 曾用名

acegi security

# 整体架构

## 认证

authentication

### AuthenticationManager

```java
public interface AuthenticationManager {
    Authentication authenticate(Authentication var1) throws AuthenticationException;
}

```



- 返回Authentication 代表认证成功
- 抛出AuthenticationException异常，表示认证失败

主要实现类为ProviderManager

```java
public class ProviderManager implements AuthenticationManager, MessageSourceAware, InitializingBean {
    private static final Log logger = LogFactory.getLog(ProviderManager.class);
    private AuthenticationEventPublisher eventPublisher;
    private List<AuthenticationProvider> providers;
```

其中含有很多AuthenticationProvider的实现类,用于提供多种认证

```java
public interface AuthenticationProvider {
    Authentication authenticate(Authentication var1) throws AuthenticationException;

    boolean supports(Class<?> var1);
}
```

### Authentication

```java
public interface Authentication extends Principal, Serializable {
    // 权限信息
    Collection<? extends GrantedAuthority> getAuthorities();
	
    // 密码
    Object getCredentials();

    // 用户身份详细信息
    Object getDetails();

    // 用户名
    Object getPrincipal();

    // 是否认证
    boolean isAuthenticated();

    void setAuthenticated(boolean var1) throws IllegalArgumentException;
}
 
```

### SecurityContextHolder

获取Authentication

实现了线程绑定,只能被当前线程访问  

:

认证成功后返回Authentication对象,其中保存用户信息,同时将该对象放入ThreadLocal中的SecurityContextHolder中. 等登陆成功后响应时,会将Authentication拿出存入session

此后每次有请求, 都会将Authentication取出并存入SecurityContextHolder,待请求处理结束, 再次存入session

## 授权

authorization

### AccessDecisionManager

```java
public interface AccessDecisionManager {
    void decide(Authentication var1, Object var2, Collection<ConfigAttribute> var3) throws AccessDeniedException, InsufficientAuthenticationException;

    boolean supports(ConfigAttribute var1);

    boolean supports(Class<?> var1);
}

```

 访问决策管理器，用来决定此次访问是否被允许，基于投票者的投票

### AccessDecisionVoter\<T\>

```java
public interface AccessDecisionVoter<S> {

	int ACCESS_GRANTED = 1;
	int ACCESS_ABSTAIN = 0;
	int ACCESS_DENIED = -1;


	boolean supports(ConfigAttribute attribute);

	boolean supports(Class<?> clazz);

	
	int vote(Authentication authentication, S object,
			Collection<ConfigAttribute> attributes);
}
```

投票器，检查当前用户是否具备访问某资源的条件，投出赞成反对或弃权，比较用户所带权限与当前请求资源的configAttribute中的权限是否吻合

### ConfigAttribute

```java
public interface ConfigAttribute extends Serializable {
	
	String getAttribute();
}
```

保存请求一个接口需要的授权的角色信息

# 环境搭建

```xml
<parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.6.11</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.example</groupId>
    <artifactId>spring-security-bl</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>spring-security-bl</name>
    <description>spring-security-bl</description>

    <properties>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
    </dependencies>

```

 

# 实现原理

底层使用了filter，但由于原生的filter需要手动注册到tomcat中，springsecurity提供了DelegatingFilterProxy，可以让开发者通过spring的bean注册的方式注册securityfilter的Bean

DelegatingFilterProxy 管理了一个chain, 其中包含各种SecurityFilter的实现类, 通过FIlterProxy相当于间接放入了Java web filter中

# 默认配置

## SpringBootWebSecurityConfiguration

会将配置包装成一个chain返回

```java
@Configuration(proxyBeanMethods = false)
@ConditionalOnDefaultWebSecurity
@ConditionalOnWebApplication(type = Type.SERVLET)
class SpringBootWebSecurityConfiguration {

	@Bean
	@Order(SecurityProperties.BASIC_AUTH_ORDER)
	SecurityFilterChain defaultSecurityFilterChain(HttpSecurity http) throws Exception {
		http.authorizeRequests().anyRequest().authenticated().and().formLogin().and().httpBasic();
		return http.build();
	}

}
```

满足条件

```java
@Target({ ElementType.TYPE, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Conditional(DefaultWebSecurityCondition.class)
public @interface ConditionalOnDefaultWebSecurity {

}
```

```java
class DefaultWebSecurityCondition extends AllNestedConditions {

	DefaultWebSecurityCondition() {
		super(ConfigurationPhase.REGISTER_BEAN);
	}

	@ConditionalOnClass({ SecurityFilterChain.class, HttpSecurity.class })
	static class Classes {

	}

	@ConditionalOnMissingBean({ WebSecurityConfigurerAdapter.class, SecurityFilterChain.class })
	static class Beans {

	}

}
```

### 默认登陆页面

```java
private void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws IOException, ServletException {
        boolean loginError = this.isErrorPage(request);
        boolean logoutSuccess = this.isLogoutSuccess(request);
    	// 如果当前不是登录请求且不是登陆错误且不是登出成功,就不管
    	// 就是说只有在当前页面为登录请求或者登陆错误或者登出成功时才进行处理  
        if (!this.isLoginUrlRequest(request) && !loginError && !logoutSuccess) {
            chain.doFilter(request, response);
        } else {
            // 在这里组合登陆页面
            String loginPageHtml = this.generateLoginPageHtml(request, loginError, logoutSuccess);
            
            response.setContentType("text/html;charset=UTF-8");
            response.setContentLength(loginPageHtml.getBytes(StandardCharsets.UTF_8).length);
            response.getWriter().write(loginPageHtml);
        }
    }
```

### 默认账号密码

```java
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass(AuthenticationManager.class)
@ConditionalOnBean(ObjectPostProcessor.class)
@ConditionalOnMissingBean(
		value = { AuthenticationManager.class, AuthenticationProvider.class, UserDetailsService.class,
				AuthenticationManagerResolver.class },
		type = { "org.springframework.security.oauth2.jwt.JwtDecoder",
				"org.springframework.security.oauth2.server.resource.introspection.OpaqueTokenIntrospector",
				"org.springframework.security.oauth2.client.registration.ClientRegistrationRepository" })
public class UserDetailsServiceAutoConfiguration {

	private static final String NOOP_PASSWORD_PREFIX = "{noop}";

	private static final Pattern PASSWORD_ALGORITHM_PATTERN = Pattern.compile("^\\{.+}.*$");

	private static final Log logger = LogFactory.getLog(UserDetailsServiceAutoConfiguration.class);

	@Bean
	@Lazy
	public InMemoryUserDetailsManager inMemoryUserDetailsManager(SecurityProperties properties,
			ObjectProvider<PasswordEncoder> passwordEncoder) {
		SecurityProperties.User user = properties.getUser();
		List<String> roles = user.getRoles();
		return new InMemoryUserDetailsManager(
				User.withUsername(user.getName()).password(getOrDeducePassword(user, passwordEncoder.getIfAvailable()))
						.roles(StringUtils.toStringArray(roles)).build());
	}

	private String getOrDeducePassword(SecurityProperties.User user, PasswordEncoder encoder) {
		String password = user.getPassword();
		if (user.isPasswordGenerated()) {
			logger.warn(String.format(
					"%n%nUsing generated security password: %s%n%nThis generated password is for development use only. "
							+ "Your security configuration must be updated before running your application in "
							+ "production.%n",
					user.getPassword()));
		}
		if (encoder != null || PASSWORD_ALGORITHM_PATTERN.matcher(password).matches()) {
			return password;
		}
		return NOOP_PASSWORD_PREFIX + password;
	}

}
```

```java
	public static class User {

		/**
		 * Default user name.
		 */
		private String name = "user";

		/**
		 * Password for the default user name.
		 */
		private String password = UUID.randomUUID().toString();
```

# 登录流程

1. 请求/hello接口, 在引入spring security之后会引入一系列的过滤器
2. 在请求到达FilterSecurityInterceptor时, 请求未认证,将其拦截,抛出AccessDeniedException异常
3. 抛出的Access Denied异常被ExceptionTranslationFilter捕获,该fiter会返回302要求重庆顶下到/login
4. 客户端发送login请求
5. /login请求呗DefaultLoginPageGeneratingFilter拦截,并在其中返回登录界面

# 认证逻辑

AuthenticationManager有一个实现类：ProviderManger，ProviderManager中有许多的AuthenticationProvider实现，分别提供不同的认证逻辑	

只要有一个认证成功，就会返回一个完整的Authentication

# 自定义认证

所有放行要放到认证请求之前

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {
     @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .mvcMatchers("/index", "/login.html")
                .permitAll()
                .anyRequest()
                .authenticated()
                .and()
                .formLogin()
                .usernameParameter("uname")
                .passwordParameter("pword")
                // 请求成功跳转路径(转发)
                .successForwardUrl("/hello")
                // 默认认证成功跳转(重定向), 与forward二选一
                // 默认根据被拦截的请求决定跳转地址
                // alwaysUse不会跳转到之前被拦截地址
                .defaultSuccessUrl("/hello",true)
                //指定登录页面同时需要指定登录处理url
                .loginPage("/login.html")
                .loginProcessingUrl("/doLogin")
                .and()
                // 未配置需要关闭csrf
                .csrf().disable()

        ;
    }
}  
```

有几个注意点

1. 需要禁用csrf ： csrf().disable()

2. 建议使用mvcMathers来匹配路径

3. 不管成功处理还是失败处理都有三种方式：

   1. 转发

      异常信息SPRING_SECURITY_LAST_EXCEPTION会保存在request作用域

   2. 重定向

      异常信息SPRING_SECURITY_LAST_EXCEPTION会保存在session作用域

   3. 自定义处理器

   其中自定义处理器的方式更适合用来前后端分离

## 成功异常处理器

```java
@Component
public class MyAuthenticationSuccessFailureHandler implements AuthenticationSuccessHandler, AuthenticationFailureHandler {
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(JSONObject.toJSONString(authentication));
    }

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(JSONObject.toJSONString(exception));
    }
}
```

# 注销登录

默认只需访问/logout 

## 非前后端分离

```java
.logout()
                // 退出出口,与logoutRequestMatcher冲突,会被覆盖
                .logoutUrl("/exit")
                .logoutRequestMatcher(
                        new OrRequestMatcher(
                                new AntPathRequestMatcher("/getLogout","GET"),
                                new AntPathRequestMatcher("/postLogout","POST")
                        )
                )
                // 默认会话失效
                .invalidateHttpSession(true)
                // 默认清除认证信息
                .clearAuthentication(true)
                // 注销成功跳转页面
                .logoutSuccessUrl("/login.html")
```

# 前后端分离

```java
// 前后端分离
                .logoutSuccessHandler(myLogoutSuccessHandler)
                    
//=================================                  
                    
@Component
public class MyLogoutSuccessHandler implements LogoutSuccessHandler {
    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        response.setContentType("application/json;charSet=UTF-8");
        response.getWriter().write(JSONObject.toJSONString(authentication));
    }
}

```

# 获取认证信息

会将Authentication放入本线程中的  securityContextHolder中, 本次会话结束会取出放入session,下次会话开始会从session中取出,再次放入线程中的securityContextHolder中

在securityContextHolder中有四种存储策略

- ThreadLocal

  将security Context存放在ThreadLocal中,在哪个线程中存储就要在哪个线程中读取,非常适合web应用, 因为在默认情况下, 一个请求无论经过多少歌filter到达servlet, 都是由一个线程处理的, 这种存储策略意味着如果在具体的业务处理代码中开启了子线程,在子线程中去获取用户数据获取不到

- InheritableThreadLocal

  适用于多线程环境,可在子线程中获取

- Global

  将数据保存在一个静态变量中, 很少用到

更改策略模式需要设置虚拟机参数

```
-Dspring.security.strategy=MODE_INHERITABLETHREADLOCAL
```

## thymeleaf获取认证信息

需要引入命名空间

```html
<!DOCTYPE html>
<html lang="en"
    xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/extras/spring-security"
>
<head>
    <meta charset="UTF-8">
    <title>退出</title>
</head>
<body>
<form action="/postLogout" method="post">
    <input type="submit" value="exit">
</form>
<h2>获取认证的用户信息</h2>
<ul>
    <li sec:authentication="principal.username"></li>
    <li sec:authentication="principal.authorities"></li>
    <li sec:authentication="principal.accountNonExpired"></li>
    <li sec:authentication="principal.accountNonLocked"></li>
    <li sec:authentication="principal.credentialsNonExpired"></li>
</ul>
</body>
</html>
```

# 自定义数据源

## 基于内存的认证流程的认证分析

![abstractauthenticationprocessingfilter](SpringSecurity/abstractauthenticationprocessingfilter.png)

比如

![usernamepasswordauthenticationfilter](SpringSecurity/usernamepasswordauthenticationfilter.png)

1. 发起认证请求, 请求中携带用户名,密码,该请求会被usernamePasswordAuthenticationFilter拦截
2. 在usernamePasswordAuthenticationFilter中的attemptAuthentication方法中将请求中的用户名和密码封装为Authentication对象(UsernamePasswordAuthenticationToken)交给AuthenticationManager进行认证
3. 认证若成功,将认证信息存储到SecurityContextHolder以及调用记住我等,并调用AuthenticationSuccessHandler处理成功结果
4. 若认证失败,清除SecurityContextHodler以及记住我中的信息,回调AuthenticationFailureHandler处理失败结果

## 三者关系（AM，PM，AP）

AuthenticationManager是认证的核心类，但真正认证离不开ProviderManager以及其中的AuthenticationProvider

- AuthenticationManager是一个认证管理器，它定义了SpringSecurity过滤器要执行的认证操作
- ProviderManager是AuthenticationManager的默认实现类
- AuthenticationProvider是针对不同的身份类型执行的具体身份认证

![providermanager](SpringSecurity/providermanager.png)

多个AuthenticationProvider组成一个列表，由provider代理——在providerManager中存在一个AuthenticationProvider列表，在providerManager中会遍历列表中的每一个AuthenticationProvider去执行身份认证，最终得到认证结果。

providerManger可以配置一个AuthenticationManager作为parent，这样当providerManager认证失败后可以进入parent中进行认证

设计原因：比如账号名密码，是一种兜底的策略，孩子认证不通过可以用parent的认证策略，比如添加了手机登录的功能，但是认证不通过，就可以看是不是账号密码登录

或者可以理解为是全局的AuthenticationManager和局部的AuthenticationManager

认证时底层数据源需要调用UserDetailService来实现

## 全局配置AuthenticationManager方式

- 修改默认

```java
@Autowired
    public void ini(AuthenticationManagerBuilder builder) throws Exception {
        System.out.println("默认配置"+builder);
        InMemoryUserDetailsManager userDetailsService = new InMemoryUserDetailsManager();
        userDetailsService.createUser(User.withUsername("aa").password("{noop}123").roles("admin").build());
        builder.userDetailsService(userDetailsService);
    }
```

默认的manager发现容器中如果有userDetailService的bean也会覆盖默认manager中的sercice

springboot对security进行自动配置时自动在工厂中创建一个全局的AM

**总结**

1. 默认的自动配置全局AM会自动寻找当前项目中是否存在自定义的userDetailService实例，从而将其设为数据源
2. 默认自动配置创建全局AM在工厂中，使用时直接在代码中注入即可

- 自定义覆盖默认

  自定义的不会自动寻找容器中的userDetailService,需要自己设置

```java
 @Bean
    @Override
    public UserDetailsService userDetailsService(){
        InMemoryUserDetailsManager userDetailsService = new InMemoryUserDetailsManager();
        userDetailsService.createUser(User.withUsername("aa").password("{noop}123").roles("admin").build());
    return  userDetailsService;
    }
    /**
     *
     * @param auth
     * @throws Exception
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService());
    }
```

**总结**

1. 一旦通过configure方法自定义了全局的AM实现，会将工厂中自动配置创建的AM覆盖。
2. 一旦通过configure方法中定义A
3. M实现，需要在实现中指定认证对象userdetailsservice的实现
4. 一旦通过configure方法中定义AM实现，该对象为为工厂内部本地的AM对象，不允许在其他的自定义组件中使用，若有需求，需要覆盖，将authenticationManagerBean覆盖即可，且加@Bean注解

- 用来在工厂中暴露自定义的AM

  ```java
   @Bean
      @Override
      public UserDetailsService userDetailsService(){
          InMemoryUserDetailsManager userDetailsService = new InMemoryUserDetailsManager();
          userDetailsService.createUser(User.withUsername("aa").password("{noop}123").roles("admin").build());
      return  userDetailsService;
      }
      /**
       *
       * @param auth
       * @throws Exception
       */
      @Override
      protected void configure(AuthenticationManagerBuilder auth) throws Exception {
          auth.userDetailsService(userDetailsService());
      }
  
      @Override
      @Bean
      public AuthenticationManager authenticationManagerBean() throws Exception {
          return super.authenticationManagerBean();
      }
  ```

# 数据库数据源认证

## 数据库表

```sql
CREATE TABLE `user`(
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(32) DEFAULT NULL,
		`password` VARCHAR(255) DEFAULT NULL,
		`enabled`	TINYINT(1) DEFAULT NULL,
		`accountNonExpired` TINYINT(1) DEFAULT NULL,
		`accountNonLocked` TINYINT(1) DEFAULT NULL,
		`credentialsNonExpired` TINYINT(1) DEFAULT NULL,
		PRIMARY KEY (`id`)
)ENGINE=INNODB auto_increment=4 DEFAULT CHARSET = utf8;
CREATE TABLE `role`(
	`id`	INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) DEFAULT NULL,
	`name_zh` VARCHAR(32) DEFAULT NULL,
	PRIMARY KEY (`id`)
)ENGINE=INNODB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `user_role`(
	`id`	INT(11) NOT NULL AUTO_INCREMENT,
	`uid` INT(11) DEFAULT NULL,
	`rid` INT(11) DEFAULT NULL,
	PRIMARY KEY (`id`)
)ENGINE=INNODB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

```

## 依赖配置

```xml
<!--druid-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.2.8</version>
        </dependency>
        <!--mysql-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.2.0</version>
        </dependency>
```

# 阶段总结

## 传统web开发

### 环境搭建

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.6.11</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.orange</groupId>
    <artifactId>security_web_together</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>security_web_together</name>
    <description>security_web_together</description>

    <properties>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>com.alibaba.fastjson2</groupId>
            <artifactId>fastjson2</artifactId>
            <version>2.0.20</version>
        </dependency>


        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <!--thymeleaf-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
        <!--thymeleaf引入springsecurity-->
        <dependency>
            <groupId>org.thymeleaf.extras</groupId>
            <artifactId>thymeleaf-extras-springsecurity5</artifactId>
            <version>3.0.4.RELEASE</version>
        </dependency>
        <!--druid-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.2.8</version>
        </dependency>
        <!--mysql-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.2.0</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```

#### yml

```yml
spring:
  application:
    name: security_web_together
  thymeleaf:
    cache: false
    # 默认
    prefix: classpath:/templates/
    suffix: .html
    encoding: UTF-8
    mode: HTML
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/sstestdb?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
    username: root
    password: 123456
mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.orange.entity
server:
  port: 8081
```

#### 页面

**login**

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>登录页</title>
</head>
<body>
<h1>登录</h1>
<h3 th:text="${session.SPRING_SECURITY_LAST_EXCEPTION.getMessage()}"></h3>
<form method="post" th:action="@{/doLogin}">
    用户名 : <input name="uname" type="text"><br>
    密码 : <input name="pword" type="password"><br>
    <input type="submit" value="登录">
</form>
</body>
</html>
```

**index**

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns:sec="http://www.thymeleaf.org/extras/spring-security">
<head>
    <meta charset="UTF-8">
    <title>系统主页</title>
</head>
<body>
<h1>系统主页</h1>
<h2>欢迎<span sec:authentication="principal.username"></span>进入系统</h2>
<ul>
    <li sec:authentication="principal.username"></li>
    <li sec:authentication="principal.authorities"></li>
    <li sec:authentication="principal.accountNonExpired"></li>
    <li sec:authentication="principal.accountNonLocked"></li>
    <li sec:authentication="principal.credentialsNonExpired"></li>
</ul>
<hr>
<a th:href="@{/doLogout}">退出登录</a>
</body>
</html>
```

#### 数据库

**DAO**

```java
package com.orange.dao;


import com.orange.entity.Role;
import com.orange.entity.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserDao {
    public User loadUserByUsername(String username);
    public List<Role> getRolesByUserId(Integer id);
}

```



**Mapper**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybais.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.orange.dao.UserDao">
    <select id="loadUserByUsername" resultType="com.orange.entity.User">
        select id,
               username,
               password,
               enabled,
               accountNonExpired,
               accountNonLocked,
               credentialsNonExpired
        from user
        where username = #{username}
    </select>

    <select id="getRolesByUserId" resultType="com.orange.entity.Role">
        select r.id,
               r.name,
               r.name_zh nameZh
        from role r
                 left join user_role ur
        on r.id = ur.rid
          where ur.uid = #{uid}

    </select>
</mapper>
```

### Controller

```java
@RestController
public class UserController {
    @RequestMapping("/user")
    public String getUserInfo(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User principal = (User) authentication.getPrincipal();
        return JSONObject.toJSONString(principal);
    }
}
```



### SecurityConfig

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {
//    public UserDetailsService getUserDetailsService() throws Exception {
//        InMemoryUserDetailsManager inMemoryUserDetailsManager = new InMemoryUserDetailsManager();
//        inMemoryUserDetailsManager.createUser(User.withUsername("admin").password("{noop}123").roles("admin").build());
//        return  inMemoryUserDetailsManager;
//    }
    @Autowired
    MyUserDetailService myUserDetailService;
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable()
                .authorizeRequests()
                .mvcMatchers("/login.html").permitAll()
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/login.html")
                .defaultSuccessUrl("/index.html",true)
                .usernameParameter("uname")
                .passwordParameter("pword")
                .loginProcessingUrl("/doLogin")
                .failureUrl("/login.html")
                .and()
                .logout()
                .logoutUrl("/doLogout")
                .logoutSuccessUrl("/login.html")
        ;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(myUserDetailService);
    }
}

```

### MvcConfig

```java
@Configuration
public class MvcConfigure implements WebMvcConfigurer {
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
//        WebMvcConfigurer.super.addViewControllers(registry);
        registry.addViewController("/index.html").setViewName("index");
        registry.addViewController("/login.html").setViewName("login");
    }
}

```

### MyUserDetailService

```java
@Service
public class MyUserDetailService implements UserDetailsService {
//    @Autowired
//    private UserDao userDao;
    private final UserDao userDao;
    @Autowired
    public MyUserDetailService(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userDao.loadUserByUsername(username);
        if(ObjectUtils.isEmpty(user)){
            throw new UsernameNotFoundException("用户名不存在");
        }
        List<Role> rolesByUserId = userDao.getRolesByUserId(user.getId());
        user.setRoles(rolesByUserId);
        return user;
    }

}

```

### 验证码

**验证码包**

```xml
		<dependency>
            <groupId>com.github.penggle</groupId>
            <artifactId>kaptcha</artifactId>
            <version>2.3.2</version>
        </dependency>
```

**验证码配置类**

```java
import java.util.Properties;

@Configuration
public class KaptchaConfig {
    @Bean
    public Producer kaptcha(){
        Properties properties = new Properties();
        properties.setProperty("kaptcha.image.width","150");
        properties.setProperty("kaptcha.image.height","50");
        properties.setProperty("kaptcha.textproducer.char.string","12");
        properties.setProperty("kaptcha.textproducer.char.length","4");
        Config config = new Config(properties);
        DefaultKaptcha defaultKaptcha = new DefaultKaptcha();
        defaultKaptcha.setConfig(config);
        return defaultKaptcha;
    }
}

```

**验证异常**

```java
public class VerifyCodeException extends AuthenticationException {

    public VerifyCodeException(String msg, Throwable cause) {
        super(msg, cause);
    }

    public VerifyCodeException(String msg) {
        super(msg);
    }
}

```

**下载验证码的Controlelr**

```java
	private final Producer producer;
    @Autowired
    public VerifyCodeController(Producer producer) {
        this.producer = producer;
    }

    @RequestMapping("/verfyCode.jpeg")
    public void verfyCode(HttpServletResponse httpServletResponse, HttpSession session) throws IOException {

        String text = producer.createText();
        session.setAttribute("verifyCode",text);
        BufferedImage image = producer.createImage(text);
        httpServletResponse.setContentType(MediaType.IMAGE_JPEG_VALUE);
        ServletOutputStream outputStream = httpServletResponse.getOutputStream();
        ImageIO.write(image,"jpg",outputStream);
    }
```



**验证码的认证需要自定义filter**

```java
public class VerifyCodeFilter extends UsernamePasswordAuthenticationFilter {
    public static final String FORM_VERIFY_CODE_KEY = "verifyCode";
    private String verifyCodeParameter = FORM_VERIFY_CODE_KEY;

    public String getVerifyCodeParameter() {
        return verifyCodeParameter;
    }

    public void setVerifyCodeParameter(String verifyCodeParameter) {
        this.verifyCodeParameter = verifyCodeParameter;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        if (!request.getMethod().equals("POST")) {
            throw new AuthenticationServiceException("Authentication method not supported: " + request.getMethod());
        }
        String reqVeriFyCode = request.getParameter(verifyCodeParameter);
        String sessionVerifyCode = (String) request.getSession().getAttribute("verifyCode");
        if(!ObjectUtils.isEmpty(reqVeriFyCode)&&!ObjectUtils.isEmpty(sessionVerifyCode)&&reqVeriFyCode.equals(sessionVerifyCode)){

            return super.attemptAuthentication(request, response);
        }else {
            throw new VerifyCodeException("验证失败");
        }
    }
}

```

**过滤器在securityConfig中的配置**

```java
	http.addFilterAt(verifyCodeFilter(), UsernamePasswordAuthenticationFilter.class);



	@Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Bean
    public VerifyCodeFilter verifyCodeFilter() throws Exception {
        VerifyCodeFilter verifyCodeFilter = new VerifyCodeFilter();
        verifyCodeFilter.setFilterProcessesUrl("/doLogin");
        verifyCodeFilter.setUsernameParameter("uname");
        verifyCodeFilter.setPasswordParameter("pword");
        verifyCodeFilter.setVerifyCodeParameter("verifyCode");
        // 指定认证管理器
        verifyCodeFilter.setAuthenticationManager(authenticationManagerBean());
        verifyCodeFilter.setAuthenticationSuccessHandler((req,resp,auth)->{
            resp.sendRedirect("/index.html");
        });
        verifyCodeFilter.setAuthenticationFailureHandler((req,resp,ex)->{
            resp.sendRedirect("/login.html");
        });
        return verifyCodeFilter;
    }
```



## 前后端分离

### 自定义Filter

```java
public class LoginFilter extends UsernamePasswordAuthenticationFilter {
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        // 判断是否为Post请求
        if (!request.getMethod().equals("POST")) {
            throw new AuthenticationServiceException("Authentication method not supported: " + request.getMethod());
        }
        // 判断请求体是否为json格式
        if(!request.getContentType().equalsIgnoreCase(MediaType.APPLICATION_JSON_VALUE)){
            throw new AuthenticationServiceException("Authentication method not supported: " + request.getMethod());
        }
        // 从json中获取用户输入的用户名和密码
        try {
            ServletInputStream inputStream = request.getInputStream();
            Map<String,String> map = new ObjectMapper().readValue(inputStream, Map.class);
            String username =map.get(this.getUsernameParameter());
            username = username != null ? username : "";
            username = username.trim();
            String password = map.get(this.getPasswordParameter());
            password = password != null ? password : "";
            System.out.println("用户名: "+username+",密码: "+password);
            UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password);
            this.setDetails(request, authRequest);
            return this.getAuthenticationManager().authenticate(authRequest);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return super.attemptAuthentication(request,response);
    }
}
```

### configure

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {
//    @Bean
//    @Override
//    public UserDetailsService userDetailsService(){
//        InMemoryUserDetailsManager inMemoryUserDetailsManager = new InMemoryUserDetailsManager();
//        inMemoryUserDetailsManager.createUser(User.withUsername("root").password("{noop}123").roles("admin","root").build());
//        return inMemoryUserDetailsManager;
//    }

    private final MyUserDetailService myUserDetailService;
    @Autowired
    public SecurityConfig(MyUserDetailService myUserDetailService) {
        this.myUserDetailService = myUserDetailService;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(myUserDetailService);
    }

    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Bean
    public LoginFilter loginFilter() throws Exception {
        LoginFilter loginFilter = new LoginFilter();
        loginFilter.setUsernameParameter("uname");
        loginFilter.setPasswordParameter("pword");
        loginFilter.setFilterProcessesUrl("/doLogin");
        loginFilter.setAuthenticationManager(authenticationManagerBean());
        loginFilter.setAuthenticationSuccessHandler((req,resp,authentication)->{
            Map<String , Object> result = new HashMap<>();
            result.put("msg","登录成功");
            result.put("user",authentication.getPrincipal());
            resp.setContentType("application/json;charset=utf-8");
            resp.setStatus(HttpStatus.OK.value());
            String resStr = new ObjectMapper().writeValueAsString(result);
            resp.getWriter().println(resStr);

        });
        loginFilter.setAuthenticationFailureHandler((req,resp,exception)->{
            Map<String , Object> result = new HashMap<>();
            result.put("msg","登录失败"+exception.getMessage());
            resp.setContentType("application/json;charset=utf-8");
            resp.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            String resStr = new ObjectMapper().writeValueAsString(result);
            resp.getWriter().println(resStr);
        });
        return loginFilter;
    }
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .csrf().disable()
                .authorizeRequests()
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .and()
                .logout()
                .logoutRequestMatcher(new OrRequestMatcher(
                        new AntPathRequestMatcher("/logout", HttpMethod.DELETE.name()),
                        new AntPathRequestMatcher("/logout", HttpMethod.GET.name())
                ))
                .logoutSuccessHandler((req,resp,authentication)->{
                    Map<String , Object> result = new HashMap<>();
                    result.put("msg","退出成功");
                    result.put("user",authentication.getPrincipal());
                    resp.setContentType("application/json;charset=utf-8");
                    resp.setStatus(HttpStatus.OK.value());
                    String resStr = new ObjectMapper().writeValueAsString(result);
                    resp.getWriter().println(resStr);

                })
                .and()
                .exceptionHandling()
                .authenticationEntryPoint((req,resp,exception)->{
                    resp.setContentType("application/json;charset=utf-8");
                    resp.setStatus(HttpStatus.UNAUTHORIZED.value());
                    resp.getWriter().println("请先认证");
                })
        ;
        // at替换, before 放在之前, after 放在之后
        http.addFilterAt(loginFilter(), UsernamePasswordAuthenticationFilter.class);
    }
}

```

重点在于filter的替换与配置:

使用自定义的filter来从请求体的json中获取用户名和密码信息

### 验证码

```java
  @RequestMapping("/verifyCode")
    public String getVerifyCode(HttpSession httpSession) throws Exception{
        String text = producer.createText();
        System.out.println(text);
        httpSession.setAttribute(VERIFY_STRING,text);
        BufferedImage image = producer.createImage(text);
        FastByteArrayOutputStream stream = new FastByteArrayOutputStream();
        ImageIO.write(image,"jpg",stream);
        return "data:image/png;base64,"+Base64.encodeBase64String(stream.toByteArray());
    }
```

# 密码加密

## PasswordEncoder

接口,制定了密码加密器所要实现的功能

## DelegatingPasswordEncoder

用于根据数据库中存储的密码前缀{id}寻找指定的加密器

这种方式适用于加密方式的更新



## 使用指定(固定)的密码加密器(不推荐)

往spring容器中注入一个密码加密器的bean

```java
@Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
```

此时数据库中存储的密码将没有且不应该有{id}前缀

## 密码自动更新

在容器中设置UserDetailsPasswordService,如不做任何设置,默认会更新为bcrypt

```java
@Service
public class MyUserDetailService implements UserDetailsService, UserDetailsPasswordService {
    @Autowired
    UserDao userDao;
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userDao.loadUserByUsername(username);
        if(ObjectUtils.isEmpty(user)){
            throw new UsernameNotFoundException("用户名不存在");
        }
        List<Role> rolesByUserId = userDao.getRolesByUserId(user.getId());
        user.setRoles(rolesByUserId);
        return user;
    }

    @Override
    public UserDetails updatePassword(UserDetails user, String newPassword) {
        Integer res = userDao.updatePassword(user.getUsername(), newPassword);
        if(res == 1){
            ((User)user).setPassword(newPassword);
        }
        return user;
    }
}

```

```java
    public Integer updatePassword(@Param("username") String username,@Param("password") String password);

```

```xml
 <update id="updatePassword">
        update `user`
        set password=#{password}
        where username=#{username}
    </update>
```

# Remember Me

```java
.and()
.rememberMe()
.rememberMeOarameter("remember-me")// 请求中作为开启记住我的参数
.alwaysRemember(true)// 是否总是记住
```

开启rememberMe之后，会在现有的过滤器链中引入一个新的filter：RememberMeAuthenticationFilter

请求时需要携带rememberMe参数: "remember-me: on"

该请求会被RememberMeAuthenticationFilter进行拦截,调用autoLogin()方法自动登录

当自动登录成功,返回的rememberMeAuth不为null时,表示自动登陆成功,此时调用authenticate方法对key进行校验,并将登录成功的用户信息保存到SecurityContextHolder对象中,然后调用登陆成功的回调:onSuccessfulAuthentication,并发布登陆成功时间,登录成功的回调并不包含RememberMeService中的loginSuccess方法

如果自动登录失败,则调用rememberMeServices中的loginFail方法处理登录失败,onUnsuccessfulAuthentication和onSuccessfulAuthentication都是该过滤器中定义的空方法,并没有实现,

## RememberMeServices

- autoLogin方法可以送请求中提取出需要的参数,完成自动登录
- loginFail方法是自动登录失败的回调
- loginSuccess方法是非自动登陆成功的回调

## 过程总结

当洪湖通过用户名,密码形式登陆成功后, 系统会根据用户名,密码以及令牌的过期时间计算出一个签名, 这个签名使用MD5进行加密,不可逆,然后将用户名, 过期时间, 以及签名拼接成一个字符串, 中间用":"隔开,最后通过Base64进行编码, 然后见编码后的结果返回到前端,也就是我们在浏览器中看到的令牌,当会话过期,浏览器访问资源时会携带Cookie中的令牌, 服务端拿到后,进行Base64解码,切割,判断是否过期,若没有国企,则根据用户名查出用户信息,接着计算签名,比较签名,若签名一致?则登陆成功,否则自动登陆失败.

## 提高安全性

使用PersistentTokenBasedRenmemberMeServices取代TokenBasedRememberMeServices

- 不同于TokenBasedRememberMeService,PersistentTokenBasedRememberMeServices中在Cookies中存放的信息长度为2,第一项是series,第二项是token
- 从ciikiues中提取出series和token吗根据seies去内存中查询出一个PersustentRememberMeToken对象, 如果查询出的对象为努力了,则表示内存中并没有series对应的值,本次登陆失败,如果查询出的token与cookie中携带的token值不同,则说明令牌已泄露, 移除用户的自动登陆信息并抛出异常
- 根据token中解析出的信息判断是否过期,过期抛异常
- 生成一个新的PersistentRememberMeToken对象,series与用户名不变,token重新生成,date使用当前时间,新的token生成后,修改内存中的token和date
- 将新token写入cookie
- 根据用户名查询用户信息并返回
- 如果一直是一台客户端登陆这个账号,则浏览器的cookie中和服务端中的token信息会一直保持一致,一旦有两台客户端使用同一个token登录,其中一个客户端的token就会与服务端不一致,若该不一致客户端要再次访问,则服务端会认为token泄露,删除服务端的cookie信息,要求用户重新登陆
- 恶意程序还是会有一次访问机会

**配置方式**

```java
.rememberMe()
                .rememberMeServices(new PersistentTokenBasedRememberMeServices(
                        UUID.randomUUID().toString(),
                        userDetailsService(),
                        new InMemoryTokenRepositoryImpl()
                ))
```

同时rememberMe可以单独允许指定路径使用

## 持久化

方法一：需自己建表

```java
.and()
                .rememberMe()
                .rememberMeServices(rememberMeServices())  



public RememberMeServices rememberMeServices() {
        JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
        tokenRepository.setDataSource(dataSource);
        return new PersistentTokenBasedRememberMeServices(
                UUID.randomUUID().toString(),
                myUserDetailService,
                tokenRepository

        );

    }
```

方法二,自动生成表

```java
.and()
                .rememberMe()
//                .rememberMeServices(rememberMeServices())
                .tokenRepository(persistentTokenRepository())
    
 @Bean
    public PersistentTokenRepository persistentTokenRepository(){
        JdbcTokenRepositoryImpl jdbcTokenRepository = new JdbcTokenRepositoryImpl();
        jdbcTokenRepository.setDataSource(dataSource);
        // 自动建表
        jdbcTokenRepository.setCreateTableOnStartup(true);
        return jdbcTokenRepository;
    }
    
    
    
```

## 前后端分离

remember-me参数不在放到请求参数中，而是放入请求体，故这里需要重新编写获取remember-me的值的逻辑

由于是先进行usernamepassword过滤，而请求体输入流只能读取一次。故在该filter中获取到remember的值并保存在request域，在rememberMeService中获得值并进行判断

```java
 String rememberMe = map.get(AbstractRememberMeServices.DEFAULT_PARAMETER);
            rememberMe = rememberMe!= null?rememberMe:"";
            rememberMe = rememberMe.trim();
            request.setAttribute(AbstractRememberMeServices.DEFAULT_PARAMETER,rememberMe);
```

```java
public class MyRememberMeServices extends PersistentTokenBasedRememberMeServices {
    public MyRememberMeServices(String key, UserDetailsService userDetailsService, PersistentTokenRepository tokenRepository) {
        super(key, userDetailsService, tokenRepository);
    }

    @Override
    protected boolean rememberMeRequested(HttpServletRequest request, String parameter) {
        String paramValue = (String) request.getAttribute(DEFAULT_PARAMETER);
        if (paramValue != null) {
            if (paramValue.equalsIgnoreCase("true") || paramValue.equalsIgnoreCase("on")
                    || paramValue.equalsIgnoreCase("yes") || paramValue.equals("1")) {
                return true;
            }
        }
        return  false;

    }
}

```

```java
.rememberMe()
.rememberMeServices(rememberMeServices())



@Bean
    public RememberMeServices rememberMeServices(){
        MyRememberMeServices myRememberMeServices = new MyRememberMeServices(UUID.randomUUID().toString(),myUserDetailService,new InMemoryTokenRepositoryImpl());
        return myRememberMeServices;
    }
```

# 会话管理

## 会话并发管理

默认情况下，ss允许同一个用户同时 在多台设备上登录，可配置  

```java
.and()
.sessionManagement()
.maximumSessions(1)
```

## 会话失效管理

### 传统web

```java
.and()
                .sessionManagement()
                .maximumSessions(1)
                .expiredUrl("/login")
```

### 前后端分离

```java
.and()
                .sessionManagement()
                .maximumSessions(1)
                .expiredSessionStrategy((event) -> {
                    // 注意字符集设置需要在获取流之前
                    event.getResponse().setContentType("application/json;charset=utf-8");
                    event.getResponse().getWriter().write("{\"msg\":\"session expired: 会话已过期\"}");
                })
```

## 禁止同一用户再次登录

```java
.maxSessionsPreventsLogin(true)
```

## redis实现会话共享

```xml
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.session</groupId>
            <artifactId>spring-session-data-redis</artifactId>
        </dependency>
```

```yml
spring:
  application:
    name: security_web_session
  redis:
    host: localhost
    port: 6379
```

```java
 private final FindByIndexNameSessionRepository findByIndexNameSessionRepository;
    @Autowired
    public SecurityConfig(FindByIndexNameSessionRepository findByIndexNameSessionRepository) {
        this.findByIndexNameSessionRepository = findByIndexNameSessionRepository;
    }



@Bean
    public SpringSessionBackedSessionRegistry sessionRegistry(){
        return new SpringSessionBackedSessionRegistry(findByIndexNameSessionRepository);
    }



.and()
                .sessionManagement()
                .maximumSessions(1)
                .sessionRegistry(sessionRegistry())
```

# CSRF

cross-site request forgery 跨站请求伪造，也称为一键式攻击，通常缩写为csrf或xsrf

比如在支付宝的网页登录之后，在另一个非支付宝的官方网页中有一个隐藏在图片中的链接，该链接比如为支付宝的转账请求（要求在域名完全相同），由于是同一个浏览器，服务器会以为是用户操作，发生危险

解决：

给出一个令牌，令牌为随机生成，保存在session中，同时前端form表单提交时要带上，服务器进行比较，若不一致则拒绝请求

## 传统web

直接开启csrf即可，会自动在请求中增加csrf 的key-value

```html
<input type="hidden" th:name="${_csrf.parameterName}" th:value="${_csrf.token}"/>
```

## 前后端分离

**配置令牌存储位置为cookies**

```java
                .csrf()
                // 将令牌保存到cookie允许前端获取
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
```



- 请求参数中携带令牌
  - _csrf=....
- 请求头中携带令牌（更建议）
  - X_XSRF_TOKEN:value

# CORS跨域

同源策略, 同源共享

options 预检请求

## 请求方式

### 简单请求

Get请求为例拿, 如果需要发起一个跨域请求, 则请求头如下

```http
Host:localhost:8080
Origin:http://localhost:8081
Referer:http://localhost:8081/index.html
```

若服务端支持跨域请求,则响应头包含

```http
Access-Control-Allow-Origin:http://localhost:8081
```

Access-Control-Allow-Origin字段用来告诉浏览器可以访问该资源的域,当浏览器收到这样的响应头信息之后,提取出值,发现改制包含当前所在的域,则不对该请求做限制

属于简单请求,不需要进行预检请求的跨域

### 非简单请求

会首先发送一个预检请求

```http
OPTIONS /put HTTP/1.1
Host:localhost:8080
Connection:keep-alive
Accept: */*
Access-Control-Request-Method:PUT
Origin: http://localhost:8081
Referer:http://localhost:8081/index.html
```

请求方法是OPTIONS, 请求头Origin就告诉服务端当前所在域, 请求头Access-Control-Request-Methods告诉服务器端浏览器即将发起的跨域请求所使用的方法. 服务端对此进行判断, 如果允许即将发起的跨域请求, 给出如下相应

```http
HTTP/1.1 200
Access-Control-Allow-Origin: http://localhost:8081
Access-Control-Request-Method:PUT
Access-Control-Max-Age: 3600
```

Max-Age字段表示有效期,有效期内不用再次发起option请求,预检请求结束后,发起一个真正的跨域请求

## Spring跨域解决方案

### @CrossOrigin

通过@CrossOrigin注解标记支持跨越,该注解可添加于方法,也可添加于Controller

```java
@CrossOrigin(origins="http://localhost:8081")
```

该注解有如下属性

- alowCredentials: 浏览器是否应该发送凭证信息,比如Cookie
- allowedFeaders: 请求被允许的请求头字段,*表示所有字段

- exposedHeaders: 哪些响应头可以作为响应的一部分暴露无法使用*
- maxAge: 默认1800秒
- methods: 允许的请求方法,*表示所有方法
- origins: 允许的域, *表示允许所有的域 

不加任何属性表示允许所有

### addCorsMappings

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedMethods("*")
                .allowedOrigins("*")
                .allowedHeaders("*")
                .allowCredentials(false)
                .exposedHeaders("")
                .maxAge(3600)
                ;
    }
}
```

### 使用filter

```java
@Bean
FilterRegistrationBean<CorsFilter> corsFilter(){
    FilterRegistrationBean<CorsFilter> registrationBean = new FilterRegistrationBean<>();
    CorsConfiguration corsConfiguration = new CorsConfiguration();
    corsConfiguration.setAllowedHeaders(Arrays.asList("*"));
    corsConfiguration.setAllowedMethods(Arrays.asList("*"));
    corsConfiguration.setAllowedOrigins(Arrays.asList("*"));
    corsConfiguration.setMaxAge(3600L);
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**",corsConfiguration);
    registrationBean.setFilter(new CorsFilter(source));
    registrationBean.setOrder(-1);
    return registrationBean;
}
```

## SpringSecurity解决方案

![image-20221219170657864](SpringSecurity/image-20221219170657864.png)

由于@CrosOrigin与addCorsMapping的解决方案都是在拦截器层实现的, 而spring security多数是从filter层实现的,故在引入security之后,这两种方式都会失效, 至于filter的方式,则要看filter的优先级是否在security之前

```java
       .and()
            .cors().configurationSource(configurationSource())

    ;
}
CorsConfigurationSource configurationSource (){
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedHeaders(Arrays.asList("*"));
    configuration.setAllowedMethods(Arrays.asList("*"));
    configuration.setAllowedOrigins(Arrays.asList("*"));
    configuration.setMaxAge(3600L);
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**",configuration);
    return source;
}
```

# 异常处理

- AuthenticationException：认证异常
- AccessDeniedException： 授权异常

```java
.and()
.exceptionHandling()
.authenticationEntryPoint((request,response,e)->{
    // 认证异常处理逻辑
})
.accessDeniedHandler((request,response,e)->{
    // 授权异常处理逻辑
})
```

# 权限

.roles 分配角色

.authorities 分配权限

## 接口层级匹配

匹配路径

.mvcMathcers 建议使用

.antMatchers 旧方法

.regexMatchers 正则表达式

## 方法层级匹配

底层AOP

**全局开启权限注解**

```java
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled=true,securedEnabled=true,jsr250Enabled=true)
```

- perPostEnable: 开启Spring Security提供的四个权限注解, 
  - PostAuthorize
  - PostFilter
  - PreAuthorize
  - PreFilter
- securedEnabled: 开启SpringSecurity提供的@Secured注解
- jsr250Enabled: 开启 JSR-250 提供的注解
  - DenyAll
  - PermitAll
  - RolesAll

## 表达式

```java
@PreAuthorize("hasAuthority('aa')") // 是否拥有角色
String hello(String name){...}

@PreAuthorize("authentication.name==#name") // 认证名是否为方法接受的name参数的值
String hello(String name){...}

@PreFilter(value = "filterObject.id%2!=0", filterTarget = "users") // 过滤请求参数
String hello(ArrayList<User> users){...}

@PostFilter(value = "filterObject.id%2!=0")// 过滤返回值
ArrayList<User> hello(){...}
```



```java
@Secured({"ROLE_a"})
@Secured({"ROLE_a","ROLE_b"}) // 只能判断角色,并且是或的关系

@PermitAll
@DenyAll

@RolesAllowed({"ROLE_a","ROLE_b"}) // 只能判断角色,并且是或的关系
```

## 原理

**ConfigAttribute**

在SpringSecurity中， 用户请求一个资源， 需要的角色会封装成一个ConfigAttribute对象， 在ConfigAttribute中只有一个getAttribute方法，该方法返回一个String字符串，就是角色的名称，一般来说，角色名称都要有一个ROLE_前缀，投票器AccessDecisionVoter所做的事情，其实就是比较用户所具备的角色和请求某个资源所需的ConfigAttribute之间的关系

**AccesDecisionVoter和AccessDecisionManager**

有众多的实现， 在ADM中会挨个遍历ADV，进而决定是否允许用户访问，

## 数据库实现

```java
@Component
public class CustomerSecurityMetaSource implements FilterInvocationSecurityMetadataSource {
    private final MenuService menuService;

    public CustomerSecurityMetaSource(MenuService menuService) {
        this.menuService = menuService;
    }

    @Override
    public Collection<ConfigAttribute> getAttributes(Object object) throws IllegalArgumentException {
        AntPathMatcher antPathMatcher = new AntPathMatcher();
        String resuestURI = ((FilterInvocation)object).getRequest().getRequestURI();
        List<Menu> menus = menuService.getAllMenu();
        for (Menu menu : menus) {
            if(antPathMatcher.match(menu.getPattern(),resuestURI)){
                String[] roles = menu.getRoles().stream().map(r -> r.getName()).toArray(String[]::new);
                return SecurityConfig.createList(roles);
            }
        }
        return null;
    }

    @Override
    public Collection<ConfigAttribute> getAllConfigAttributes() {
        return null;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return FilterInvocation.class.isAssignableFrom(clazz);
    }
}

```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybais.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.orange.dao.MenuMapper">
    <resultMap id="MenuResultMap" type="com.orange.entity.Menu">
        <id property="id" column="id"/>
        <result property="pattern" column="pattern"/>
        <collection property="roles" ofType="com.orange.entity.Role">
            <id column="rid" property="id"/>
            <result column="rname" property="name"/>
            <result column="rnameZh" property="nameZh"/>
        </collection>
    </resultMap>
    <select id="getAllMenu" resultMap="MenuResultMap">
        select m.*, r.id rid, r.name rname, r.name_zh rnameZh
        from menu m
                 left join menu_role mr on m.`id` = mr.`mid`
                 left join `role` r on r.`id` = mr.`rid`
    </select>
</mapper>
```

```java
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Autowired
    public SecurityConfig(CustomerSecurityMetaSource customerSecurityMetaSource, MyUserDetailService myUserDetailService) {
        this.customerSecurityMetaSource = customerSecurityMetaSource;
        this.myUserDetailService = myUserDetailService;
    }

    private final CustomerSecurityMetaSource customerSecurityMetaSource;

    private final MyUserDetailService myUserDetailService;


    @Override
    protected void configure(HttpSecurity http) throws Exception {
        ApplicationContext applicationContext = http.getSharedObject(ApplicationContext.class);
        http.apply(new UrlAuthorizationConfigurer<>(applicationContext))
                .withObjectPostProcessor(new ObjectPostProcessor<FilterSecurityInterceptor>() {
                    @Override
                    public <O extends FilterSecurityInterceptor> O postProcess(O object) {
                        object.setSecurityMetadataSource(customerSecurityMetaSource);
                        // 拒绝公共资源的访问
                        object.setRejectPublicInvocations(false);
                        return object;
                    }
                });
        http
                .formLogin()
                .and()
                .csrf().disable()
        ;
    }



    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(myUserDetailService);
    }
}

```

# OAuth2

github测试

```json
{
  "authorities": [
    {
      "authority": "ROLE_USER",
      "attributes": {
        "login": "Boranget",
        "id": 50385405,
        "node_id": "MDQ6VXNlcjUwMzg1NDA1",
        "avatar_url": "https://avatars.githubusercontent.com/u/50385405?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/Boranget",
        "html_url": "https://github.com/Boranget",
        "followers_url": "https://api.github.com/users/Boranget/followers",
        "following_url": "https://api.github.com/users/Boranget/following{/other_user}",
        "gists_url": "https://api.github.com/users/Boranget/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/Boranget/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/Boranget/subscriptions",
        "organizations_url": "https://api.github.com/users/Boranget/orgs",
        "repos_url": "https://api.github.com/users/Boranget/repos",
        "events_url": "https://api.github.com/users/Boranget/events{/privacy}",
        "received_events_url": "https://api.github.com/users/Boranget/received_events",
        "type": "User",
        "site_admin": false,
        "name": null,
        "company": null,
        "blog": "",
        "location": null,
        "email": null,
        "hireable": null,
        "bio": null,
        "twitter_username": null,
        "public_repos": 3,
        "public_gists": 0,
        "followers": 0,
        "following": 0,
        "created_at": "2019-05-07T23:17:50Z",
        "updated_at": "2022-11-04T06:07:08Z",
        "private_gists": 0,
        "total_private_repos": 3,
        "owned_private_repos": 3,
        "disk_usage": 2947,
        "collaborators": 0,
        "two_factor_authentication": false,
        "plan": {
          "name": "free",
          "space": 976562499,
          "collaborators": 0,
          "private_repos": 10000
        }
      }
    },
    {
      "authority": "SCOPE_read:user"
    }
  ],
  "attributes": {
    "login": "Boranget",
    "id": 50385405,
    "node_id": "MDQ6VXNlcjUwMzg1NDA1",
    "avatar_url": "https://avatars.githubusercontent.com/u/50385405?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/Boranget",
    "html_url": "https://github.com/Boranget",
    "followers_url": "https://api.github.com/users/Boranget/followers",
    "following_url": "https://api.github.com/users/Boranget/following{/other_user}",
    "gists_url": "https://api.github.com/users/Boranget/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/Boranget/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/Boranget/subscriptions",
    "organizations_url": "https://api.github.com/users/Boranget/orgs",
    "repos_url": "https://api.github.com/users/Boranget/repos",
    "events_url": "https://api.github.com/users/Boranget/events{/privacy}",
    "received_events_url": "https://api.github.com/users/Boranget/received_events",
    "type": "User",
    "site_admin": false,
    "name": null,
    "company": null,
    "blog": "",
    "location": null,
    "email": null,
    "hireable": null,
    "bio": null,
    "twitter_username": null,
    "public_repos": 3,
    "public_gists": 0,
    "followers": 0,
    "following": 0,
    "created_at": "2019-05-07T23:17:50Z",
    "updated_at": "2022-11-04T06:07:08Z",
    "private_gists": 0,
    "total_private_repos": 3,
    "owned_private_repos": 3,
    "disk_usage": 2947,
    "collaborators": 0,
    "two_factor_authentication": false,
    "plan": {
      "name": "free",
      "space": 976562499,
      "collaborators": 0,
      "private_repos": 10000
    }
  },
  "name": "50385405"
}
```

## 搭建授权服务器

### 基于内存的

**注意：springboot和springcloud版本选择2.2.5**

高版本会显示过时

```xml
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.5.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-oauth2</artifactId>
            <version>2.2.5.RELEASE</version>
        </dependency>
```

**授权服务器配置**

```java
@Configuration
// 指定当前应用为授权服务器
@EnableAuthorizationServer
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {
    private final PasswordEncoder passwordEncoder;
    @Autowired
    public AuthorizationServerConfig(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    // 配置授权服务器可以给哪些客户端授权
    // id, secret, redirectURI, 授权模式
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.inMemory()
                .withClient("client001")
                .secret(passwordEncoder.encode("secret001"))
                .redirectUris("http://www.baidu.com")
                .authorizedGrantTypes("authorization_code")
                .scopes("read:user");
    }
}
```

**授权码访问地址**

```http
http://localhost:8080/oauth/authorize?client_id=client001&response_type=code&redirect_uri=http://www.baidu.com
```

**token获取地址**

```http
curl -X POST -H "Content-Type: application/x-www-form-urlencode" -d 'grant_type=authorization_code&code=XKzNAG&redirect_uri=http://www.baidu.com' 
"http://client001:secret001@localhost:8080/oauth/token"
```

client001:secret001部分代表客户端和密钥

**刷新**

```java
.authorizedGrantTypes("authorization_code","refresh_token")
@Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
    endpoints.userDetailsService(userDetailsService);
}
```

### 基于数据库

```sql
CREATE TABLE `clientdetails` (
  `appId` varchar(128) NOT NULL,
  `resourceIds` varchar(256) DEFAULT NULL,
  `appSecret` varchar(256) DEFAULT NULL,
  `scope` varchar(256) DEFAULT NULL,
  `grantTypes` varchar(256) DEFAULT NULL,
  `redirectUrl` varchar(256) DEFAULT NULL,
  `authorities` varchar(256) DEFAULT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `additionalInformation` varchar(4096) DEFAULT NULL,
  `autoApproveScopes` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`appId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_access_token` (
  `token_id` varchar(256) DEFAULT NULL,
  `token` blob,
  `authentication_id` varchar(128) NOT NULL,
  `user_name` varchar(256) DEFAULT NULL,
  `client_id` varchar(256) DEFAULT NULL,
  `authentication` blob,
  `refresh_token` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`authentication_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_approvals` (
  `userId` varchar(256) DEFAULT NULL,
  `clientId` varchar(256) DEFAULT NULL,
  `scope` varchar(256) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `expiresAt` timestamp NULL DEFAULT NULL,
  `lastModifiedAt` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_client_details` (
  `client_id` varchar(128) NOT NULL,
  `resource_ids` varchar(256) DEFAULT NULL,
  `client_secret` varchar(256) DEFAULT NULL,
  `scope` varchar(256) DEFAULT NULL,
  `authorized_grant_types` varchar(256) DEFAULT NULL,
  `web_server_redirect_uri` varchar(256) DEFAULT NULL,
  `authorities` varchar(256) DEFAULT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `additional_information` varchar(4096) DEFAULT NULL,
  `autoapprove` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_client_token` (
  `token_id` varchar(256) DEFAULT NULL,
  `token` blob,
  `authentication_id` varchar(128) NOT NULL,
  `user_name` varchar(256) DEFAULT NULL,
  `client_id` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`authentication_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_code` (
  `code` varchar(256) DEFAULT NULL,
  `authentication` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_refresh_token` (
  `token_id` varchar(256) DEFAULT NULL,
  `token` blob,
  `authentication` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

```sql
INSERT INTO `sstestdb`.`oauth_client_details`(`client_id`, `resource_ids`, `client_secret`, `scope`, `authorized_grant_types`, `web_server_redirect_uri`, `authorities`, `access_token_validity`, `refresh_token_validity`, `additional_information`, `autoapprove`) VALUES ('client001', NULL, '$2a$10$IUm3zsL409bLrsxXGw7rZ.BLw70Vhd1fF8pBj4CIK5Ln.0Dcs2hci', 'read:user', 'authorization_code,refresh_token', 'http://www.baidu.com', NULL, NULL, NULL, NULL, NULL);

```

```java
@Configuration
// 指定当前应用为授权服务器
@EnableAuthorizationServer
public class JDBCAuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {
    private final PasswordEncoder passwordEncoder;
    private final UserDetailsService userDetailsService;
    private final DataSource dataSource;
    private final AuthenticationManager authenticationManager;
    @Autowired
    public JDBCAuthorizationServerConfig(PasswordEncoder passwordEncoder, UserDetailsService userDetailsService, DataSource dataSource, AuthenticationManager authenticationManager) {
        this.passwordEncoder = passwordEncoder;
        this.userDetailsService = userDetailsService;
        this.dataSource = dataSource;
        this.authenticationManager = authenticationManager;
    }

    // 配置授权服务器可以给哪些客户端授权
    // id, secret, redirectURI, 授权模式
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.withClientDetails(clientDetailsServicee());
    }
    @Bean
    public ClientDetailsService clientDetailsServicee(){
        JdbcClientDetailsService jdbcClientDetailsService = new JdbcClientDetailsService(dataSource);
        jdbcClientDetailsService.setPasswordEncoder(passwordEncoder);
        return jdbcClientDetailsService;
    }
    @Bean
    public TokenStore tokenStore(){
        return new JdbcTokenStore(dataSource);
    }
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints.authenticationManager(authenticationManager);
        endpoints.tokenStore(tokenStore());

        DefaultTokenServices tokenServices = new DefaultTokenServices();
        // 设置存储方式
        tokenServices.setTokenStore(endpoints.getTokenStore());
        // 是否支持刷新令牌
        tokenServices.setSupportRefreshToken(true);
        // 是否支持重复刷新
        tokenServices.setReuseRefreshToken(true);
        // 客户端信息
        tokenServices.setClientDetailsService(endpoints.getClientDetailsService());
        // token编码
        tokenServices.setTokenEnhancer(endpoints.getTokenEnhancer());
        // 令牌有效期
        tokenServices.setAccessTokenValiditySeconds((int) TimeUnit.DAYS.toSeconds(30));
        // 刷新令牌有效期
        tokenServices.setRefreshTokenValiditySeconds((int)TimeUnit.DAYS.toSeconds(3));

        endpoints.tokenServices(tokenServices);
    }
}

```

## 资源服务器

```java
@Configuration
@EnableResourceServer
public class ResourceServerConfig extends ResourceServerConfigurerAdapter {
    private final DataSource dataSource;
    @Autowired
    public ResourceServerConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public TokenStore tokenStore(){
        return  new JdbcTokenStore(dataSource);
    }
    @Override
    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
        resources.tokenStore(tokenStore());
    }
}

```

```
Authorization=bearer ecf05753-2a26-4539-9d22-9c542d29b259
```

## JWT

**授权服务器**

```java
@Configuration
// 指定当前应用为授权服务器
@EnableAuthorizationServer
public class JWTAuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {
    private final PasswordEncoder passwordEncoder;
    private final UserDetailsService userDetailsService;
    private final DataSource dataSource;
    private final AuthenticationManager authenticationManager;
    @Autowired
    public JWTAuthorizationServerConfig(PasswordEncoder passwordEncoder, UserDetailsService userDetailsService, DataSource dataSource, AuthenticationManager authenticationManager) {
        this.passwordEncoder = passwordEncoder;
        this.userDetailsService = userDetailsService;
        this.dataSource = dataSource;
        this.authenticationManager = authenticationManager;
    }

    // 配置授权服务器可以给哪些客户端授权
    // id, secret, redirectURI, 授权模式
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.withClientDetails(clientDetailsServicee());
    }
    /**
     * 数据库中存储客户端信息,并且需要配置密码加密器,否则无法进行匹配
     */
    @Bean
    public ClientDetailsService clientDetailsServicee(){
        JdbcClientDetailsService jdbcClientDetailsService = new JdbcClientDetailsService(dataSource);
        jdbcClientDetailsService.setPasswordEncoder(passwordEncoder);
        return jdbcClientDetailsService;
    }
    /**
     * 配置密钥
     */
    @Bean
    public JwtAccessTokenConverter jwtAccessTokenConverter(){
        JwtAccessTokenConverter jwtAccessTokenConverter = new JwtAccessTokenConverter();
        jwtAccessTokenConverter.setSigningKey("123");
        return jwtAccessTokenConverter;
    }
    @Bean
    public TokenStore tokenStore(){
        return new JwtTokenStore(jwtAccessTokenConverter());
    }
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints.authenticationManager(authenticationManager);
        endpoints.tokenStore(tokenStore());
        endpoints.accessTokenConverter(jwtAccessTokenConverter());
    }
}
```

**资源服务器**

```java
@Configuration
@EnableResourceServer
public class JWTResourceServerConfig extends ResourceServerConfigurerAdapter {
    /**
     * 配置密钥
     */
    @Bean
    public JwtAccessTokenConverter jwtAccessTokenConverter(){
        JwtAccessTokenConverter jwtAccessTokenConverter = new JwtAccessTokenConverter();
        jwtAccessTokenConverter.setSigningKey("123");
        return jwtAccessTokenConverter;
    }
    public TokenStore tokenStore(){
        return  new JwtTokenStore(jwtAccessTokenConverter());
    }
    @Override
    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
        resources.tokenStore(tokenStore());
    }
}

```

# @EnableWebSecurity

需要将其加到配置类上，才能启用Security的自定义配置，SpringBoot项目可以省略，单纯的Spring项目需要添加