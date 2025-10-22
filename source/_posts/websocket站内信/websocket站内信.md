---
title: websocket站内信
date: 2025-10-27 10:35:19
updated: 2025-10-27 16:35:19
tags:
  - websocket
categories:
  - 笔记
---

# 参考资料

# 代码

依赖：

```xml
<dependencies>
    <!-- Spring WebSocket -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-websocket</artifactId>
    </dependency>
    <!-- Spring Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

WebSocket 配置类

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // 注册WebSocket处理器，允许跨域
        registry.addHandler(new MessageHandler(), "/ws/messages")
                .setAllowedOrigins("*");
    }
}
```

消息处理器

```java
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class MessageHandler extends TextWebSocketHandler {

    // 存储用户会话 (简化：用户ID -> 会话)
    private static final Map<String, WebSocketSession> sessions = new HashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        // 从连接参数获取用户ID
        String userId = session.getUri().getQuery().split("=")[1];
        sessions.put(userId, session);
        System.out.println("用户 " + userId + " 已连接");
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
        // 消息格式：目标用户ID|消息内容
        String[] parts = message.getPayload().split("\\|", 2);
        if (parts.length == 2) {
            String targetUserId = parts[0];
            String content = parts[1];
            
            // 发送给目标用户
            WebSocketSession targetSession = sessions.get(targetUserId);
            if (targetSession != null && targetSession.isOpen()) {
                String senderId = session.getUri().getQuery().split("=")[1];
                targetSession.sendMessage(new TextMessage(senderId + "：" + content));
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        String userId = session.getUri().getQuery().split("=")[1];
        sessions.remove(userId);
        System.out.println("用户 " + userId + " 已断开");
    }
}
```

启动类

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MessageApplication {
    public static void main(String[] args) {
        SpringApplication.run(MessageApplication.class, args);
    }
}
```

网页

```html
<!DOCTYPE html>
<html>
<body>
    <h3>用户1的消息框</h3>
    <div id="messages" style="height:300px; border:1px solid #000; margin:10px 0; overflow:auto;"></div>
    发送给用户2: <input type="text" id="content">
    <button onclick="sendMessage('2')">发送</button>

    <script>
        // 连接WebSocket（用户ID=1）
        const ws = new WebSocket('ws://localhost:8080/ws/messages?userId=1');

        // 接收消息
        ws.onmessage = function(event) {
            const messages = document.getElementById('messages');
            messages.innerHTML += '<div>' + event.data + '</div>';
        };

        // 发送消息
        function sendMessage(targetUserId) {
            const content = document.getElementById('content').value;
            if (content) {
                ws.send(targetUserId + '|' + content);
                document.getElementById('content').value = '';
            }
        }
    </script>
</body>
</html>
```

