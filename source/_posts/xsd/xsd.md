---
title: xsd
date: 2023-12-01 10:35:19
updated: 2023-12-02 10:35:19
tags:
  - xsd
  - xml
categories:
  - notes
---

# Schema

xsd是Schema的后缀，故通常使用xsd表示Schema

# 能做什么

- 定义可以出现在文档中的元素
- 定义可以出现在文档中的属性
- 定义哪个元素是子元素
- 定义子元素的次序
- 定义子元素的数目
- 定义元素是否为空，或者是否可包含文本
- 定义元素和属性的数据类型
- 定义元素和属性的默认值以及固定值

# 例子

```xml
<?xml version="1.0"?>
<note>
    <to>George</to>
    <from>John</from>
    <heading>Reminder</heading>
    <body>Don't forget the meeting!</body>
</note>
```

对应的

```xml
<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="http://www.w3school.com.cn"
    xmlns="http://www.w3school.com.cn" elementFormDefault="qualified">

    <xs:element name="note">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="to" type="xs:string"/>
                <xs:element name="from" type="xs:string"/>
                <xs:element name="heading" type="xs:string"/>
                <xs:element name="body" type="xs:string"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>

</xs:schema>
```

# 引用

```xml
<?xml version="1.0"?>
<note xmlns="http://www.w3school.com.cn"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.w3school.com.cn note.xsd">

    <to>George</to>
    <from>John</from>
    <heading>Reminder</heading>
    <body>Don't forget the meeting!</body>
</note>
```

# Schema元素

## 属性

schema是每一个xsd文件的根元素

```xml
<?xml version="1.0"?>
 
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
targetNamespace="http://www.w3school.com.cn"
xmlns="http://www.w3school.com.cn"
elementFormDefault="qualified">

...
...
</xs:schema>
```

其中:

- xmlns:xs="http://www.w3.org/2001/XMLSchema"
    表明schema中用到的元素和数据类型来自命名空间"http://www.w3.org/2001/XMLSchema"。同时规定了来自该命名空间的元素和数据类型应该使用前缀xs

- targetNamespace="http://www.w3school.com.cn"
    表明被此schema定义的元素（note, to, from等）来自命名空间"http://www.w3school.com.cn"
- xmlns="http://www.w3school.com.cn"
    表明默认的命名空间是"http://www.w3school.com.cn"，没有特殊标记命名空间的元素都在这个命名空间中
- elementFormDefault="qualified"
    指出使用本schema的文档中，在此schema中出现的元素必须被命名空间限定

## 引用

```xml
<?xml version="1.0"?>

<note xmlns="http://www.w3school.com.cn"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.w3school.com.cn note.xsd">

<to>George</to>
<from>John</from>
<heading>Reminder</heading>
<body>Don't forget the meeting!</body>
</note>
```

其中：

- xmlns="http://www.w3school.com.cn" 
    规定了默认的命名空间，此声明会告知schema验证器，此xml文档中所有元素都被声明于命名空间"http://www.w3school.com.cn" 

- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    规定XML Schema实例命名空间
- xsi:schemaLocation="http://www.w3school.com.cn note.xsd"
    规定使用的命名空间与命名空间使用的schema位置，xmlns:xsi说明了xsi表示的命名空间为"http://www.w3.org/2001/XMLSchema-instance" ，而xsi:schemaLocation表示的是使用上一步导入的命名空间为"[http://www.w3.org/2001/XMLSchema-instance](https://link.zhihu.com/?target=http%3A//www.w3.org/2001/XMLSchema-instance)"的schemaLocation标签。

# 简易元素

定义方式

```xml
<xs:element name="xxx" type="yyy"/>
```

其中name为元素的名称，type为元素类型

元素类型可以为：

- xs:string
- xs:decimal
- xs:integer
- xs:boolean
- xs:Date
- xs:time

比如：

```xml
<lastname>Smith</lastname>
<age>28</age>
<dateborn>1980-03-27</dateborn>
```

对应的：

```xml
<xs:element name="lastname" type="xs:string"/>
<xs:element name="age" type="xs:integer"/>
<xs:element name="dateborn" type="xs:date"/> 
```

可设置元素的默认值和固定值，固定值要求元素无法给定其他值

```xml
<xs:element name="color" type="xs:string" default="red"/>
<xs:element name="color" type="xs:string" fixed="red"/>
```

# 属性

简易元素无法拥有属性，如果某个元素拥有属性，它会被当作某种复合类型，但属性本身总是作为简易类型被声明。

## 定义

```xml
<xs:attribute name="xxx" type="yyy"/>
```

属性与元素类似，也拥有名字和类型，其中类型有如下：

- xs:string
- xs:decimal
- xs:integer
- xs:boolean
- xs:date
- xs:time

例：

```xml
<lastname lang="EN">Smith</lastname>
```

对应的属性定义

```xml
<xs:attribute name="lang" type="xs:string"/>
```

同样的，属性也有默认值和固定值

```xml
<xs:attribute name="lang" type="xs:string" default="EN"/>
<xs:attribute name="lang" type="xs:string" fixed="EN"/>
```

默认情况下，属性是可选的，但可设为必须

```xml
<xs:attribute name="lang" type="xs:string" use="required"/>
```

# 限定

可对值根据不同的值类型对其进行不同维度的限定

- integer
    可限定其数值范围

    ```xml
    <!--其实回过头来看这个也像是匿名类型-->
    <xs:element name="age">
        <xs:simpleType>
            <xs:restriction base="xs:integer">
                <xs:minInclusive value="0"/>
                <xs:maxInclusive value="120"/>
            </xs:restriction>
        </xs:simpleType>
    </xs:element> 
    ```

- 枚举限定
    表现上相当于定义了自己的type

    ```xml
    <!-- 我愿称之为匿名类型 -->
    <xs:element name="car">
        <xs:simpleType>
            <xs:restriction base="xs:string">
                <xs:enumeration value="Audi"/>
                <xs:enumeration value="Golf"/>
                <xs:enumeration value="BMW"/>
            </xs:restriction>
        </xs:simpleType>
    </xs:element>
    <!-- 或者分开定义 -->
    <xs:element name="car" type="carType"/>
    <xs:simpleType name="carType">
        <xs:restriction base="xs:string">
            <xs:enumeration value="Audi"/>
            <xs:enumeration value="Golf"/>
            <xs:enumeration value="BMW"/>
        </xs:restriction>
    </xs:simpleType>
    ```

- 正则约束

    ```xml
    <xs:element name="initials">
        <xs:simpleType>
            <xs:restriction base="xs:string">
                <xs:pattern value="[a-zA-Z][a-zA-Z][a-zA-Z]"/>
            </xs:restriction>
        </xs:simpleType>
    </xs:element> 
    ```

    ```xml
    <xs:element name="prodid">
        <xs:simpleType>
            <xs:restriction base="xs:integer">
                <xs:pattern value="[0-9][0-9][0-9][0-9][0-9]"/>
            </xs:restriction>
        </xs:simpleType>
    </xs:element>
    ```

- 空白字符限定

    - 不对空白字符处理

        ```xml
        <xs:element name="address">
            <xs:simpleType>
                <xs:restriction base="xs:string">
                    <xs:whiteSpace value="preserve"/>
                </xs:restriction>
            </xs:simpleType>
        </xs:element> 
        ```

    - 移除空白字符

        ```xml
        <xs:element name="address">
            <xs:simpleType>
                <xs:restriction base="xs:string">
                    <xs:whiteSpace value="replace"/>
                </xs:restriction>
            </xs:simpleType>
        </xs:element> 
        ```

    - 移除头尾空白字符，多个空白字符压缩为单一空格

        ```xml
        <xs:element name="address">
            <xs:simpleType>
                <xs:restriction base="xs:string">
                    <xs:whiteSpace value="collapse"/>
                </xs:restriction>
            </xs:simpleType>
        </xs:element> 
        ```

- 长度限定

    ```xml
    <xs:element name="password">
        <xs:simpleType>
            <xs:restriction base="xs:string">
                <xs:length value="8"/>
            </xs:restriction>
        </xs:simpleType>
    </xs:element>
    <!-- 范围限制 -->
    <xs:element name="password">
        <xs:simpleType>
            <xs:restriction base="xs:string">
                <xs:minLength value="5"/>
                <xs:maxLength value="8"/>
            </xs:restriction>
        </xs:simpleType>
    </xs:element> 
    ```

| 限定           | 描述                                                      |
| :------------- | :-------------------------------------------------------- |
| enumeration    | 定义可接受值的一个列表                                    |
| fractionDigits | 定义所允许的最大的小数位数。必须大于等于0。               |
| length         | 定义所允许的字符或者列表项目的精确数目。必须大于或等于0。 |
| maxExclusive   | 定义数值的上限。所允许的值必须小于此值。                  |
| maxInclusive   | 定义数值的上限。所允许的值必须小于或等于此值。            |
| maxLength      | 定义所允许的字符或者列表项目的最大数目。必须大于或等于0。 |
| minExclusive   | 定义数值的下限。所允许的值必需大于此值。                  |
| minInclusive   | 定义数值的下限。所允许的值必需大于或等于此值。            |
| minLength      | 定义所允许的字符或者列表项目的最小数目。必须大于或等于0。 |
| pattern        | 定义可接受的字符的精确序列。                              |
| totalDigits    | 定义所允许的阿拉伯数字的精确位数。必须大于0。             |
| whiteSpace     | 定义空白字符（换行、回车、空格以及制表符）的处理方式。    |

# 复合元素

- 空元素
- 包含其他元素的元素
- 仅包含文本的元素
- 包含元素和文本的元素

上述元素均可包含属性

## 示例

- 空元素

    ```xml
    <product pid="1345"/>
    ```

- 包含其他元素的元素

    ```xml
    <employee>
    	<firstname>John</firstname>
    	<lastname>Smith</lastname>
    </employee>
    ```

- 仅包含文本的元素

    ```xml
    <food type="dessert">Ice cream</food>
    ```

- 包含元素和文本的元素

    ```xml
    <description>
    	It happened on <date lang="norwegian">03.03.99</date> ....
    </description>
    ```

## 定义

```xml
<employee>
	<firstname>John</firstname>
	<lastname>Smith</lastname>
</employee>
```

对应的

```xml
<xs:element name="employee">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="firstname" type="xs:string"/>
      <xs:element name="lastname" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

其中，firstname与lastname被包裹在sequence中，意味着子元素必须以他们被声明的次序出现

同样的可以将type提取出来

```xml
<xs:element name="employee" type="personinfo"/>
<xs:element name="student" type="personinfo"/>
<xs:element name="member" type="personinfo"/>
<xs:complexType name="personinfo">
  <xs:sequence>
    <xs:element name="firstname" type="xs:string"/>
    <xs:element name="lastname" type="xs:string"/>
  </xs:sequence>
</xs:complexType>
```

同时，可以以已有type为基础

```xml
<xs:element name="employee" type="fullpersoninfo"/>

<xs:complexType name="personinfo">
  <xs:sequence>
    <xs:element name="firstname" type="xs:string"/>
    <xs:element name="lastname" type="xs:string"/>
  </xs:sequence>
</xs:complexType>

<xs:complexType name="fullpersoninfo">
  <xs:complexContent>
    <xs:extension base="personinfo">
      <xs:sequence>
        <xs:element name="address" type="xs:string"/>
        <xs:element name="city" type="xs:string"/>
        <xs:element name="country" type="xs:string"/>
      </xs:sequence>
    </xs:extension>
  </xs:complexContent>
</xs:complexType>
```

## 复合空元素

定义一个类型，其中只能包含元素，但是不声明任何元素

```xml
<product prodid="1345" />
```

```xml
<xs:element name="product">
  <xs:complexType>
    <xs:complexContent>
      <xs:restriction base="xs:integer">
        <xs:attribute name="prodid" type="xs:positiveInteger"/>
      </xs:restriction>
    </xs:complexContent>
  </xs:complexType>
</xs:element>
```

或者

```xml
<xs:element name="product">
  <xs:complexType>
    <xs:attribute name="prodid" type="xs:positiveInteger"/>
  </xs:complexType>
</xs:element>
```

也可以

```xml
<xs:element name="product" type="prodtype"/>
<xs:complexType name="prodtype">
  <xs:attribute name="prodid" type="xs:positiveInteger"/>
</xs:complexType>
```

## 仅含元素

```xml
<xs:element name="person">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="firstname" type="xs:string"/>
      <xs:element name="lastname" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

## 仅含文本

向type中添加 simpleContent 元素。在 simpleContent 元素内定义扩展或限定类型

```xml
<xs:element name="某个名称">
  <xs:complexType>
    <xs:simpleContent>
      <xs:extension base="basetype">
        ....
        ....
      </xs:extension>     
    </xs:simpleContent>
  </xs:complexType>
</xs:element>
<!--或者-->
<xs:element name="某个名称">
  <xs:complexType>
    <xs:simpleContent>
      <xs:restriction base="basetype">
        ....
        ....
      </xs:restriction>     
    </xs:simpleContent>
  </xs:complexType>
</xs:element>
```

使用 extension 或 restriction 元素来扩展或限制元素的基本简易类型

如：

```xml
<shoesize country="france">35</shoesize>
```

对应着(这里和空元素的声明区别就只在于complexContent和simpleContent？)

```xml
<xs:element name="shoesize">
  <xs:complexType>
    <xs:simpleContent>
      <xs:extension base="xs:integer">
        <xs:attribute name="country" type="xs:string" />
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>
</xs:element>
<!--or-->
<xs:element name="shoesize" type="shoetype"/>
<xs:complexType name="shoetype">
  <xs:simpleContent>
    <xs:extension base="xs:integer">
      <xs:attribute name="country" type="xs:string" />
    </xs:extension>
  </xs:simpleContent>
</xs:complexType>
```

## 混合内容

```xml
<letter>
    Dear Mr.<name>John Smith</name>.
    Your order <orderid>1032</orderid>
    will be shipped on <shipdate>2001-07-13</shipdate>.
</letter>
```

对应的，注意mixed=true

```xml
<xs:element name="letter">
  <xs:complexType mixed="true">
    <xs:sequence>
      <xs:element name="name" type="xs:string"/>
      <xs:element name="orderid" type="xs:positiveInteger"/>
      <xs:element name="shipdate" type="xs:date"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
<!---->
<xs:element name="letter" type="lettertype"/>
<xs:complexType name="lettertype" mixed="true">
  <xs:sequence>
    <xs:element name="name" type="xs:string"/>
    <xs:element name="orderid" type="xs:positiveInteger"/>
    <xs:element name="shipdate" type="xs:date"/>
  </xs:sequence>
</xs:complexType>
```

# 指示器

规定元素出现的方式

- all，规定子元素任意顺序出现，且每个子元素必须只出现一次
    当使用 all>指示器时，你可以把 minOccurs 设置为 0 或者 1，而只能把 maxOccurs 指示器设置为 1

    ```xml
    <xs:element name="person">
      <xs:complexType>
        <xs:all>
          <xs:element name="firstname" type="xs:string"/>
          <xs:element name="lastname" type="xs:string"/>
        </xs:all>
      </xs:complexType>
    </xs:element>
    ```

- choice，规定单选子元素，只有一个能出现

    ```xml
    <xs:element name="person">
      <xs:complexType>
        <xs:choice>
          <xs:element name="employee" type="employee"/>
          <xs:element name="member" type="member"/>
        </xs:choice>
      </xs:complexType>
    </xs:element>
    ```

- sequence，规定子元素必须按照特定顺序出现

    ```xml
    <xs:element name="person">
      <xs:complexType>
        <xs:sequence>
          <xs:element name="firstname" type="xs:string"/>
          <xs:element name="lastname" type="xs:string"/>
        </xs:sequence>
      </xs:complexType>
    </xs:element>
    ```

- maxOccurs与minOccurs

    ```xml
    <xs:element name="person">
      <xs:complexType>
        <xs:sequence>
          <xs:element name="full_name" type="xs:string"/>
          <xs:element name="child_name" type="xs:string"
          maxOccurs="10" minOccurs="0"/>
        </xs:sequence>
      </xs:complexType>
    </xs:element>
    ```

    如需使某个元素的出现次数不受限制，使用 maxOccurs="unbounded"

- group，元素组

    ```xml
    <xs:group name="persongroup">
      <xs:sequence>
        <xs:element name="firstname" type="xs:string"/>
        <xs:element name="lastname" type="xs:string"/>
        <xs:element name="birthday" type="xs:date"/>
      </xs:sequence>
    </xs:group>
    
    <xs:element name="person" type="personinfo"/>
    
    <xs:complexType name="personinfo">
      <xs:sequence>
        <xs:group ref="persongroup"/>
        <xs:element name="country" type="xs:string"/>
      </xs:sequence>
    </xs:complexType>
    ```

- attributeGroup，属性组

    ```xml
    <xs:attributeGroup name="personattrgroup">
      <xs:attribute name="firstname" type="xs:string"/>
      <xs:attribute name="lastname" type="xs:string"/>
      <xs:attribute name="birthday" type="xs:date"/>
    </xs:attributeGroup>
    
    <xs:element name="person">
      <xs:complexType>
        <xs:attributeGroup ref="personattrgroup"/>
      </xs:complexType>
    </xs:element>
    ```

# any

运行任何元素追加

```xml
<xs:element name="person">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="firstname" type="xs:string"/>
      <xs:element name="lastname" type="xs:string"/>
      <xs:any minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

# anyAttribute

同理可扩展属性

```xml
<xs:element name="person">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="firstname" type="xs:string"/>
      <xs:element name="lastname" type="xs:string"/>
    </xs:sequence>
    <xs:anyAttribute/>
  </xs:complexType>
</xs:element>
```

# 元素替换

比如允许用户选择在 XML 文档中使用挪威语的元素名称还是英语的元素名称

不得不说多语言向来是麻烦的

```xml
<xs:element name="name" type="xs:string"/>
<xs:element name="navn" substitutionGroup="name"/>

<xs:complexType name="custinfo">
  <xs:sequence>
    <xs:element ref="name"/>
  </xs:sequence>
</xs:complexType>

<xs:element name="customer" type="custinfo"/>
<xs:element name="kunde" substitutionGroup="customer"/>
```

阻止替换，替换标签将不再生效（暂时想不到什么场景会用：别人开发？

```xml
<xs:element name="name" type="xs:string" block="substitution"/>
<xs:element name="navn" substitutionGroup="name"/>

<xs:complexType name="custinfo">
  <xs:sequence>
    <xs:element ref="name"/>
  </xs:sequence>
</xs:complexType>

<xs:element name="customer" type="custinfo" block="substitution"/>
<xs:element name="kunde" substitutionGroup="customer"/>
```

