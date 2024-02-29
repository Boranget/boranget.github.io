---
title: echarts
date: 2023-04-22 10:35:19
updated: 2023-11-06 10:35:19
tags:
  - echarts
categories:
  - notes
---

# 系统图遍历各关系突出显示

```js
// 获取节点与关系用于操作
var lines = option.series[0].links;
var items = option.series[0].data;
// 初始化状态，若定义初始化状态则此部分无用
for (var ii in items) {
    items[ii].symbolSize = 10;
    items[ii].label.show = true;
}
for (var jj in lines) {
    lines[jj] = {
        source: lines[jj].source,
        target: lines[jj].target,
        lineStyle: {
            color: 'white',
            width:1
        }
    };
}
// 去除动画
option.series[0].animationDurationUpdate=0.5;
// 展示初始状态
myChart.setOption(option);
// 无限循环
var l = 0;
var linesSize = lines.length;
window.setInterval(() => {
    window.setTimeout(function () {
        var source = lines[l].source;
        var target = lines[l].target;
        var sourceItem = items[source];
        var targetItem = items[target];
        sourceItem.symbolSize = 30;
        targetItem.symbolSize = 30;
        lines[l] = {
            source: lines[l].source,
            target: lines[l].target,
            lineStyle: {
                color: '#f00',
                width: 5
            }
        };
        // sourceItem.label.show = true;
        // targetItem.label.show = true;
        myChart.setOption(option);
        sourceItem.symbolSize = 10;
        targetItem.symbolSize = 10;
        // sourceItem.label.show = false;
        // targetItem.label.show = false;
        lines[l] = {
            source: lines[l].source,
            target: lines[l].target,
            lineStyle: {
                color: 'white',
                width: 1
            }
        };
        l = (l + 1) % linesSize;
    }, 0);
}, 1500);
```

