---
title: JavaUtilsClass
date: 2023-01-13 16:50:30
updated: 2023-09-04 16:50:30
tags:
  - 工具类
categories:
  - experience
---

# json匹配

```java
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;

import java.util.*;

public class JsonModifyUtil {
    /**
     * 存放模板路径的集合
     */
    static HashSet<String> frameLocSet = new HashSet<>();
    public static boolean easyMode = true;

    public static void main(String[] args) {
		  // 需要转换的原文
          String needTrimString =
                "{}";
        // 模板：一个需要的结果示例
        String frame =
                "{\"data\":{\"billCode\":\"PA02221115000023\"},\"message\":\"\",\"messageType\":\"INFO\",\"success\":true}";

        easyMode = false;
        System.out.println(trimJson(needTrimString, frame));
        clearGlobal();
        easyMode = true;
        System.out.println(trimJson(needTrimString, frame));

    }

    private static void clearGlobal() {
        frameLocSet.clear();
    }

    public static JSONObject trimJson(String needTrimString, String frame) {
        JSONObject frameJsonObject = JSONObject.parseObject(frame);
        initLocSetByFrame(frameJsonObject, "");
        JSONObject needTrimJsonObject = JSONObject.parseObject(needTrimString);
        removeByLoc(needTrimJsonObject, "");
        return needTrimJsonObject;
    }

    /**
     * 根据模板初始化路径集合
     *
     * @param o
     * @param loc
     */
    private static void initLocSetByFrame(Object o, String loc) {
        if (!easyMode) {
            // 不加入中间值
            frameLocSet.add(loc);
        }
        if (o instanceof JSONObject) {
            for (String s : ((JSONObject) o).keySet()) {
                initLocSetByFrame(((JSONObject) o).get(s), loc + "->" + s);
            }
        } else if (o instanceof JSONArray) {
            for (int i = 0; i < ((JSONArray) o).size(); i++) {
                String arraySign = "&";
                boolean withUUID = false;
                if (withUUID) {
                    UUID uuid = UUID.randomUUID();
                    arraySign += uuid;
                }

                initLocSetByFrame(((JSONArray) o).get(i), loc + arraySign);
            }
        } else {
            boolean needValue = false;
            String resLoc = loc;
            if (needValue) {
                resLoc += "->" + o;
            }
            frameLocSet.add(resLoc);
        }

    }

    /**
     * 根据 locSet中的路径进行保留
     *
     * @param o
     * @param loc
     */
    private static void removeByLoc(Object o, String loc) {
        if (o instanceof JSONObject) {
            Set<String> childKeys = ((JSONObject) o).keySet();
            Iterator<String> iterator = childKeys.iterator();
            while (iterator.hasNext()) {
                String childKey = iterator.next();
                String childLoc = loc + "->" + childKey;
                // 如果当前路径不属于模板中路径
                // 删除并返回
                if (!containsMaybe(childLoc, easyMode)) {
                    // JsonObject 删除元素的原理是map移除
                    // 这里获得了jsonobject的keyset,在其中移除key有相同的效果
                    // 但如果在遍历的时候直接移除key是不合法的
                    // 故需要使用iterator的remove方法
                    // ((JSONObject) o).remove(childKey);
                    iterator.remove();
                    continue;
                }
                removeByLoc(((JSONObject) o).get(childKey), childLoc);
            }
        } else if (o instanceof JSONArray) {
            for (int i = 0; i < ((JSONArray) o).size(); i++) {
                String arraySign = "&";
                boolean withUUID = false;
                if (withUUID) {
                    UUID uuid = UUID.randomUUID();
                    arraySign += uuid;
                }

                removeByLoc(((JSONArray) o).get(i), loc + arraySign);
            }
        }

    }

    static boolean containsMaybe(String loc, boolean ifEasy) {
        if (ifEasy) {
            for (String s : frameLocSet) {
                // 如果模板里一条记录，是当前路径的开头，说明当前路径是全部保留
                // 如果当前路径是模板里的一个值的开头,说明当前路径下的子值中有需要保留的,暂且不删
                if (loc.startsWith(s) || s.startsWith(loc)) {
                    return true;
                }
            }
            return false;
        } else {
            return frameLocSet.contains(loc);
        }
    }
}

```

# xml转json

可指定数组xpth，numberxpth以及是否要去掉最外层结构

```java
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.sun.org.apache.xpath.internal.operations.Bool;
import org.dom4j.*;

import java.util.*;

public class Xml2Json {
    private static final String ARRAY_SIGN = "boranget_say_this_is_array";
    private static final String NUMBER_SIGN = "boranget_say_this_is_number";

    public static void main(String[] args) {
        String xmlNeedTransform = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                "<ns0:MT_ACE_JBEAN_REQ xmlns:ns0=\"http://pi.amersports.com/bpm_ace\"><DATA1>aa</DATA1><DATA2>bb</DATA2><DATA3>cc</DATA3><DATA4>dd</DATA4><DATA5>ee</DATA5><array><test>11</test></array><obj><dec>22</dec></obj></ns0:MT_ACE_JBEAN_REQ>";
        List<String> needArrayXpaths = new ArrayList<>();
        needArrayXpaths.add("/MT_ACE_JBEAN_REQ/array");
        List<String> needNumberXpaths = new ArrayList<>();
        needNumberXpaths.add("/MT_ACE_JBEAN_REQ/obj/dec");
        boolean stripOutElement = true;
        String res = transformToJson(xmlNeedTransform, needArrayXpaths, needNumberXpaths, stripOutElement);
        System.out.println(res);
    }

    /**
     * 将xml字符串转换为json字符串
     *
     * @param xmlNeedTransform 需要转换为json的xml字符串
     * @param needArrayXpaths  需要转为数组的节点xpath
     * @return
     */
    private static String transformToJson(String xmlNeedTransform, List<String> needArrayXpaths, List<String> needNumberXpaths, Boolean stripOutElement) {
        String res = null;
        Document d = null;

        try {
            d = DocumentHelper.parseText(xmlNeedTransform);
        } catch (DocumentException e) {
            e.printStackTrace();
        }

        setSpecName(d, needArrayXpaths, needNumberXpaths);

        JSONObject resJson = transformToJsonObject(d);
        // 删除JSON最外层节点
        if(stripOutElement){
            Set<Map.Entry<String, Object>> entries = resJson.entrySet();
            if (entries != null&&entries.size() == 1){
                String rootKey = entries.iterator().next().getKey();
                Object root = resJson.get(rootKey);
                if(root instanceof JSONObject){
                    JSONObject newRoot = new JSONObject();
                    ((JSONObject) root).forEach((k, v) -> newRoot.put(k, v));
                    res = newRoot.toJSONString();
                }
                if(root instanceof JSONArray){
                    res = ((JSONArray) root).toJSONString();
                }
            }
        }else {
            res = resJson.toJSONString();
        }
        return res ;
    }

    private static void setSpecName(Document d, List<String> needArrayXpaths, List<String> needNumberXpaths) {
        // 获取需要转换为数组格式的节点
        List<Node> needArrayNodes = new ArrayList<>();
        needArrayXpaths.forEach(needArrayXpath -> {
            needArrayNodes.addAll(d.selectNodes(needArrayXpath));
        });
        List<Node> needNumberNodes = new ArrayList<>();
        needNumberXpaths.forEach(needNumberXpath -> {
            needNumberNodes.addAll(d.selectNodes(needNumberXpath));
        });
        for (Node node : needArrayNodes) {
            node.setName(node.getName() + ARRAY_SIGN);
        }
        for (Node node : needNumberNodes) {
            node.setName(node.getName() + NUMBER_SIGN);
        }
    }

    /**
     * 给需要转为数组的节点加标签
     *
     * @param d
     * @param needArrayXpath
     */
    private static void setArrayName(Document d, String needArrayXpath) {
        if (needArrayXpath == null || needArrayXpath.trim().equals("")) {
            return;
        }
        // 获取需要转换为数组格式的节点
        List<Node> nodes = d.selectNodes(needArrayXpath);
        for (Node node : nodes) {
            node.setName(node.getName() + ARRAY_SIGN);
        }
    }

    /**
     * 给需要转为数字的节点加标签
     *
     * @param d
     * @param needNumberXpath
     */
    private static void setNumberName(Document d, String needNumberXpath) {
        if (needNumberXpath == null || needNumberXpath.trim().equals("")) {
            return;
        }
        // 获取需要转换为数组格式的节点
        List<Node> nodes = d.selectNodes(needNumberXpath);
        for (Node node : nodes) {
            node.setName(node.getName() + NUMBER_SIGN);
        }
    }

    /**
     * 获取xml根节点, 返回json对象
     *
     * @param d
     * @return
     */
    private static JSONObject transformToJsonObject(Document d) {
        if (d == null) {
            return null;
        }
        Element rootElement = d.getRootElement();
        JSONObject childJsonObject = (JSONObject) doTransformToJsonObject(rootElement);
        JSONObject res = new JSONObject();
        String rootElementName = rootElement.getName();
        // 判断根节点是否标记为数组
        if (rootElementName.contains(ARRAY_SIGN)) {
            rootElementName = rootElementName.split(ARRAY_SIGN)[0];
            JSONArray jsonArray = new JSONArray();
            jsonArray.add(childJsonObject);
            res.put(rootElementName, jsonArray);
        } else {
            res.put(rootElementName, childJsonObject);
        }
        return res;
    }

    /**
     * 递归将当前层xml转为json
     *
     * @param rootElement
     * @return
     */
    private static Object doTransformToJsonObject(Element rootElement) {
        JSONObject res = new JSONObject();
        List<Element> elements = rootElement.elements();
        HashMap<String, Object> currentMap = new HashMap<>();
        // 如果其下没有节点, 说明当前就是叶子节点，返回值
        if (elements.size() == 0) {
            Object data = rootElement.getData();
            String name = rootElement.getName();
            if (name.contains(NUMBER_SIGN)) {
                return toNumber(data.toString());
            }
            return data;
        } else {
            for (Element element : elements) {
                boolean isArray = false;
                String elementName = element.getName();
                if (elementName.contains(ARRAY_SIGN)) {
                    isArray = true;
                }
                // 判断当前层是否已经存在该name（多个同名节点自动转为数组）
                if (currentMap.containsKey(elementName)) {
                    // 若存在, 则将已存在的拿出,与当前一起放入jsonArray
                    Object o = currentMap.get(elementName);
                    if (o instanceof JSONArray) {
                        // 如果已经存了JsonArray, 则往该Array中存入获取到的对象
                        ((JSONArray) o).add(doTransformToJsonObject(element));
                    } else {
                        // 如果已经存放的不是JsonArray, 则将该对象拿出来,放入Array再存入
                        JSONArray jsonArray = new JSONArray();
                        jsonArray.add(currentMap.get(elementName));
                        jsonArray.add(doTransformToJsonObject(element));
                        currentMap.put(elementName, jsonArray);
                    }
                } else {
                    // 若不存在
                    // 如果提前标注为数组,则放入数组
                    // 如果没有提前标注,则直接放入map
                    if (isArray) {
                        JSONArray jsonArray = new JSONArray();
                        jsonArray.add(doTransformToJsonObject(element));
                        currentMap.put(elementName, jsonArray);

                    } else {
                        currentMap.put(elementName, doTransformToJsonObject(element));
                    }


                }
            }
        }
        // 获取到了一个map, 遍历
        for (String s : currentMap.keySet()) {
            String key = s;
            if (s.contains(ARRAY_SIGN)) {
                key = key.replace(ARRAY_SIGN, "");
            }
            if (s.contains(NUMBER_SIGN)) {
                key = key.replace(NUMBER_SIGN, "");
            }
            res.put(key, currentMap.get(s));
        }
        return res;
    }

    private static Number toNumber(String str) {
        if (str.contains(".")) {
            try {
                return Double.valueOf(str);
            } catch (Exception e) {
                return Float.valueOf(str);
            }
        } else {
            try {
                long value = Long.valueOf(str);
                if (value <= Integer.MAX_VALUE && value >= Integer.MIN_VALUE) {
                    return (int) value;
                } else {
                    return value;
                }
            } catch (Exception e) {
                return Double.valueOf(str);
            }
        }
    }
}
```

# 文件压缩解压

```java
package com.boranget;

import java.io.*;
import java.nio.charset.Charset;
import java.util.Stack;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 * @author boranget
 * @date 2023/8/30
 */
public class ZipUtil {
    /**
     * 编码 charset
     */
    public static final String UTF_8 = "UTF-8";
    public static final String GBK = "GBK";

    public static void main(String[] args) throws IOException {
//        // 压缩示例
//        String originalFilePath = ("./zip/b");
//        String targetFilePath = ("./zip/res.zip");
//        zip(originalFilePath, targetFilePath, GBK, false);
//        // 解压示例
//        String zipFilePath = "./zip/你好.zip";
//        String targetSavePath = ("./zip/");
//        unzip(zipFilePath, targetSavePath, GBK);

    }


    /**
     * 解压
     * 支持压缩包内多个文件，或者目录嵌套
     *
     * @param zipFilePath       压缩文件地址
     * @param targetSaveDirPath 目标解压目录
     * @param charset           文件名编码格式
     * @throws FileNotFoundException
     */
    static void unzip(String zipFilePath, String targetSaveDirPath, String charset) throws FileNotFoundException {
        // 检查待解压文件是否存在
        File zipFile = new File(zipFilePath);
        if (!zipFile.exists()) {
            throw new FileNotFoundException("can not find zip file");
        }
        // 创建带解压文件夹,不存在则创建
        File targetSaveDir = new File(targetSaveDirPath);
        if (!targetSaveDir.exists()) {
            targetSaveDir.mkdirs();
        }
        // 获取zip包输入流,第二个参数为读取压缩包名时的编码格式
        ZipInputStream zipInputStream = new ZipInputStream(new FileInputStream(zipFile), Charset.forName(charset));
        ZipEntry zipEntry = null;
        try {
            while ((zipEntry = zipInputStream.getNextEntry()) != null) {
                FileOutputStream fileOutputStream = null;
                try {
                    // 创建解压后的文件
                    File afterUnzipFile = new File(targetSaveDir, zipEntry.getName());
                    // 如果文件名以”/“结尾，说明是文件夹
                    if (zipEntry.getName().endsWith("/")) {
                        afterUnzipFile.mkdirs();
                        // 解析下一个文件
                        continue;
                    }
                    // 如果是文件
                    // 1. 建立上层文件夹
                    File parentFile = afterUnzipFile.getParentFile();
                    if (!parentFile.exists()) {
                        parentFile.mkdirs();
                    }
                    // 2. 写入文件
                    fileOutputStream = new FileOutputStream(afterUnzipFile);
                    byte[] buffer = new byte[1024];
                    int len = 0;
                    while ((len = zipInputStream.read(buffer)) > 0) {
                        fileOutputStream.write(buffer, 0, len);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    if (fileOutputStream != null) {
                        fileOutputStream.close();
                    }

                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            // 重新包装异常
            new IllegalArgumentException("请检查编码格式是否正确", e).printStackTrace();
        } finally {
            try {
                if (zipInputStream != null) {
                    zipInputStream.closeEntry();
                    zipInputStream.close();
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 压缩，支持文件夹嵌套，空文件夹压缩
     * @param originalFilePath 待压缩文件夹或文件路径
     * @param targetZipFilePath 压缩包路径（包括压缩包文件名）
     * @param charset 压缩时文件名的字符集
     * @param includeTopDir 是否要包含最顶层文件夹
     * @throws FileNotFoundException
     */
    static void zip(String originalFilePath, String targetZipFilePath, String charset, boolean includeTopDir) throws FileNotFoundException {
        // 创建输出流
        ZipOutputStream zipOutputStream = null;
        // 输入流
        FileInputStream fileInputStream = null;
        // 检查源文件对象是否存在
        File originalFile = new File(originalFilePath);
        if (!originalFile.exists()) {
            throw new FileNotFoundException("can not find zip file");
        }
        // 创建目标文件对象
        File zipFile = new File(targetZipFilePath);
        File parentFile = zipFile.getParentFile();
        if (parentFile.exists()) {
            parentFile.mkdirs();
        }
        try {
            // 打开输出流
            zipOutputStream = new ZipOutputStream(new FileOutputStream(zipFile));
            Stack<FileWithPath> dirStack = new Stack<>();
            dirStack.push(new FileWithPath(originalFile, includeTopDir ? originalFile.getName() + "/" : ""));
            while (!dirStack.empty()) {
                FileWithPath currentDir = dirStack.pop();
                // 当前文件路径前缀
                // 如果当前Path是个文件夹
                if (currentDir.getFile().isDirectory()) {
                    // 在不包含最顶层文件夹时，会出现空名Entry
                    if (!currentDir.getPath().trim().equals("")) {
                        // 创建文件夹Entry
                        zipOutputStream.putNextEntry(new ZipEntry(currentDir.getPath()));
                    }
                    for (File currentFile : currentDir.getFile().listFiles()) {
                        if (currentFile.isDirectory()) {
                            dirStack.push(new FileWithPath(currentFile, currentDir.getPath() + currentFile.getName() + "/"));
                        } else {
                            // 组装元素名
                            final StringBuilder entryName = new StringBuilder();
                            entryName.append(currentDir.getPath()).append(currentFile.getName());
                            zipOutputStream.putNextEntry(new ZipEntry(entryName.toString()));
                            fileInputStream = new FileInputStream(currentFile);
                            int temp = 0;
                            while ((temp = fileInputStream.read()) != -1) {
                                zipOutputStream.write(temp);
                            }
                        }
                    }
                } else {
                    // 由于在处理过程中只有文件夹会进入栈，
                    // 故如果出现栈中弹出文件的情况则说明本来就只需要压缩一个文件
                    zipOutputStream.putNextEntry(new ZipEntry(currentDir.getFile().getName()));
                    fileInputStream = new FileInputStream(currentDir.getFile());
                    int temp = 0;
                    while ((temp = fileInputStream.read()) != -1) {
                        zipOutputStream.write(temp);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if(fileInputStream!=null){
                    fileInputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (zipOutputStream != null) {
                    zipOutputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    /**
     * 包装文件与其路径的类
     */
    static class FileWithPath {
        String path;
        File file;

        public FileWithPath(File file, String path) {
            this.path = path;
            this.file = file;
        }

        public String getPath() {
            return path;
        }

        public File getFile() {
            return file;
        }
    }
}

```

# 文件按行拷贝并筛除不需要的行

```java
import java.io.*;

/**
 * @author boranget
 * @date 2023/8/16
 */
public class CollectUserInfo {
    public static final String ROLE_PREFIX = "role=";
    public static final String GROUP_PREFIX = "group=";

    public static void main(String[] args) {
        File to = new File("./to.txt");
        // 删除已有结果
        if(to.exists()){
            to.delete();
        }
        File fromDir = new File("./User Export");
        if (fromDir.exists()&&fromDir.isDirectory()) {
            for (File file : fromDir.listFiles()) {
                if(file.isDirectory()){
                    for (File listFile : file.listFiles()) {
                        copy(listFile, to);
                    }
                }
            }
        }
    }

    static void copy(File from, File to) {
        BufferedReader bufferedReader = null;
        BufferedWriter bufferedWriter = null;
        try {
            bufferedReader = new BufferedReader(new FileReader(from));
            // new FileWriter(to, true) true：追加形式打开文件
            bufferedWriter = new BufferedWriter(new FileWriter(to, true));
            String tempStr = null;
            while ((tempStr = bufferedReader.readLine()) != null) {
                if (!(tempStr.startsWith(ROLE_PREFIX) || tempStr.startsWith(GROUP_PREFIX))) {
                    System.out.println(tempStr);
                    bufferedWriter.write(tempStr + "\n");
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (bufferedWriter != null) {
                try {
                    bufferedWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```

# 生成随机密码

```java

/**
 * @author boranget
 * @date 2023/9/4
 * 生成随机密码组合
 * 调用示例：
 * getRandomPassword(5, 5, 2, 5,'@','&')
 *
 */
public class RandomPasswordUtil {
    /**
     *
     * @param numCount 数字数量
     * @param lowCaseCount 英文小写数量
     * @param upCaseCount 英文大写数量
     * @param specCharCount 特殊字符数量
     * @param spec 允许的特殊字符
     * @return
     */
    public static String getRandomPassword(int numCount, int lowCaseCount, int upCaseCount, int specCharCount, char... spec) {
        StringBuilder resBuilder = new StringBuilder();
        if(specCharCount>0&&spec.length==0){
            throw new RuntimeException("specCharCount不为0时需要至少提供一个特殊字符");
        }
        next:
        while ((numCount + lowCaseCount + upCaseCount + specCharCount) != 0) {
            // 字符种类判定
            final int random = getRandom(0, 3);
            switch (random) {
                case 0:
                    // 数字
                    if(numCount<=0){
                        continue next;
                    }
                    numCount--;
                    final int randomInt = getRandom(0, 9);
                    resBuilder.append(randomInt);
                    break;
                case 1:
                    // 英文大写
                    if(upCaseCount<=0){
                        continue next;
                    }
                    upCaseCount--;
                    final int randomUpCase = getRandom(65, 90);
                    resBuilder.append((char) randomUpCase);
                    break;
                case 2:
                    // 英文小写
                    if(lowCaseCount<=0){
                        continue next;
                    }
                    lowCaseCount--;
                    final int randomLowCase = getRandom(97, 122);
                    resBuilder.append((char) randomLowCase);
                    break;
                case 3:
                    // 特殊字符
                    if(specCharCount<=0){
                        continue next;
                    }
                    specCharCount--;
                    final int randomIndex = getRandom(0, spec.length - 1);
                    resBuilder.append(spec[randomIndex]);
                    break;
                default:
            }
        }
        return resBuilder.toString();
    }

    /**
     * 随机数生成，包括 left 和 right
     *
     * @param left
     * @param right
     * @return
     */
    private static int getRandom(int left, int right) {
        int bound = right - left + 1;
        return new Random().nextInt(bound) + left;
    }
}

```

# AES加密

```java
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * @author boranget
 * @date 2023/8/17
 */
public class CryptUtils {
    // 加密算法
    public static final String ALGORITHM = "AES";

    /**
     * base64加密
     * @param original
     * @return
     */
    static byte[] base64Encrypt(byte[] original) {
        return Base64.getEncoder().encode(original);
    }

    /**
     * base64解密
     * @param original
     * @return
     */
    static byte[] base64Decrypt(String original){
        return Base64.getDecoder().decode(original.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * aes加密 字节数组
     * @param original
     * @param password
     * @return
     */
    static byte[] aesEncrypt(byte[] original, String password) {
        try{
            // 获取加密器
            Cipher cipher = Cipher.getInstance("AES");
            // 使用密钥初始化加密器，设置为加密模式
            cipher.init(Cipher.ENCRYPT_MODE, getKey(password));
            // 加密
            byte[] result = cipher.doFinal(original);
            return result;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
    /**
     * aes 解密
     * @param ciphertext
     * @param password
     * @return
     */
    static byte[] aesDecrypt(byte[] ciphertext, String password) {
        try{
            // 获取加密器
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, getKey(password));
            byte[] result = cipher.doFinal(ciphertext);
            return result;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取密钥
     * 传入的参数取其utf8编码值作为密钥，有长度要求
     * @param password
     * @return
     */
    static SecretKeySpec getKey(String password) {
        try {
            SecretKeySpec key = new SecretKeySpec(password.getBytes(StandardCharsets.UTF_8), ALGORITHM);
            return key;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}
```