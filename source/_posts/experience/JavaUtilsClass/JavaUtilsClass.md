---
title: JavaUtilsClass
date: 2023-01-13 16:50:30
tags:
  - 工具类
categories:
  - 经验
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

```java
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.dom4j.*;

import java.util.HashMap;
import java.util.List;

public class TransformXmlToJson {
    private static final String ARRAY_SIGN = "this_is_array";

    public static void main(String[] args) {
        String xmlNeedTransform = "<a>\n" +
                "    <b>bvalue</b>\n" +
                "    <c>cvalue</c>\n" +
                "    <c>cvalue</c>\n" +
                "    <c>cvalue</c>\n" +
                "    <d>\n" +
                "        <da>12</da>\n" +
                "        <db>bvalue</db>\n" +
                "        <dc>cvalue</dc>\n" +
                "        <dc>cvalue</dc>\n" +
                "        <dc>cvalue</dc>\n" +
                "    </d>\n" +
                "</a>";
        String needArrayXpath = "";
        String res = transformToJson(xmlNeedTransform,needArrayXpath);
        System.out.println(res);
    }

    /**
     * 将xml字符串转换为json字符串
     * @param xmlNeedTransform 需要转换为json的xml字符串
     * @param needArrayXpath 需要转为数组的节点xpath
     * @return
     */
    private static String transformToJson(String xmlNeedTransform, String needArrayXpath) {
        Document d = null;

        try {
            d = DocumentHelper.parseText(xmlNeedTransform);
        } catch (DocumentException e) {
            e.printStackTrace();
        }
        setArrayName(d, needArrayXpath);
        JSONObject res = transformToJsonObject(d);
        return res.toJSONString();
    }

    /**
     * 给需要转为数组的节点加标签
     * @param d
     * @param needArrayXpath
     */
    private static void setArrayName(Document d, String needArrayXpath) {
        if(needArrayXpath==null || needArrayXpath.trim().equals("")){
            return;
        }
        // 获取需要转换为数组格式的节点
        List<Node> nodes = d.selectNodes(needArrayXpath);
        for (Node node : nodes) {
            node.setName(node.getName()+ ARRAY_SIGN);
        }
    }

    /**
     * 获取xml根节点, 返回json对象
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
        if(rootElementName.endsWith(ARRAY_SIGN)){
            rootElementName = rootElementName.split(ARRAY_SIGN)[0];
            JSONArray jsonArray = new JSONArray();
            jsonArray.add(childJsonObject);
            res.put(rootElementName,jsonArray);
        }else{
            res.put(rootElementName, childJsonObject);
        }
        return res;
    }

    /**
     * 递归将当前层xml转为json
     * @param rootElement
     * @return
     */
    private static Object doTransformToJsonObject(Element rootElement) {
        JSONObject res = new JSONObject();
        List<Element> elements = rootElement.elements();
        HashMap<String, Object> currentMap = new HashMap<>();
        // 如果其下没有节点, 说明当前就是根节点
        if (elements.size() == 0) {
            return rootElement.getData();
        } else {
            for (Element element : elements) {
                boolean isArray = false;
                String elementName = element.getName();
                if(elementName.endsWith(ARRAY_SIGN)){
                    isArray  = true;
                    elementName = elementName.split(ARRAY_SIGN)[0];
                }
                // 判断当前层是否已经存在该name
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
                    if(isArray){
                        JSONArray jsonArray = new JSONArray();
                        jsonArray.add(doTransformToJsonObject(element));
                        currentMap.put(elementName,jsonArray);

                    }else {
                        currentMap.put(elementName, doTransformToJsonObject(element));
                    }


                }
            }
        }
        // 获取到了一个map, 遍历
        for (String s : currentMap.keySet()) {
            res.put(s, currentMap.get(s));
        }
        return res;
    }
}

```

# 文件解压

```java
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-compress</artifactId>
            <version>1.22</version>
        </dependency>
/**
     * 可解压中文文件名
     * 但不支持windows自带的zip压缩的中文文件名
     * @param zipFilePath
     * @param targetSaveDirPath
     * @throws FileNotFoundException
     */
    private static void unzipFile(String zipFilePath, String targetSaveDirPath) throws FileNotFoundException {
        // 检查文件是否存在
        File zipFile = new File(zipFilePath);
        if (!zipFile.exists()) {
            throw new FileNotFoundException("can not find zip file");
        }
        File targetSaveDir = new File(targetSaveDirPath);
        if (!targetSaveDir.exists()) {
            targetSaveDir.mkdirs();
        }
        // 获取输入流
        ZipArchiveInputStream zipArchiveInputStream = new ZipArchiveInputStream(new BufferedInputStream(new FileInputStream(zipFile)));
        try {
            ZipArchiveEntry entry = null;
            while ((entry = zipArchiveInputStream.getNextZipEntry()) != null) {
                if (entry.isDirectory()) {
                    File directory = new File(targetSaveDir, entry.getName());
                    directory.mkdirs();
                } else {
                    OutputStream outputStream = null;
                    try {
                        File targetFile = new File(targetSaveDir, entry.getName());
                        File parentFile = targetFile.getParentFile();
                        if(!parentFile.exists()){
                            parentFile.mkdirs();
                        }
                        outputStream = new BufferedOutputStream(new FileOutputStream(targetFile));
                        IOUtils.copy(zipArchiveInputStream, outputStream);
                    } finally {
                        IOUtils.closeQuietly(outputStream);
                    }
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
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
private String getRandomPassword() {
        char[] spec = new char[]{'@','#','$'};
        StringBuilder resBuilder = new StringBuilder();
        for (int i = 0; i < 10; i++) {
            // 字符种类判定
            final int random = getRandom(0, 3);
            switch (random) {
                case 0:
                    // 数字
                    final int randomInt = getRandom(0, 9);
                    resBuilder.append(randomInt);
                    break;
                case 1:
                    // 英文大写
                    final int randomUpCase = getRandom(65,90);
                    resBuilder.append((char)randomUpCase);
                    break;
                case 2:
                    // 英文小写
                    final int randomLowCase = getRandom(97, 122);
                    resBuilder.append((char)randomLowCase);
                    break;
                case 3:
                    final int randomIndex = getRandom(0, spec.length-1);
                    resBuilder.append(spec[randomIndex]);
                    break;
                default:
            }
        }
        // 密码要求必须有一个数字位
        resBuilder.append(getRandom(0,9));
        return resBuilder.toString();
    }

    private int getRandom(int left, int right) {
        int bound = right - left + 1;
        return new Random().nextInt(bound) + left;
    }
```

