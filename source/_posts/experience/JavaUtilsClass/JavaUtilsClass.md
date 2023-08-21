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
		
          String needTrimString =
                "{\"data\":{\"allowSave\":true,\"appId\":\"e3d5e4787ff911e88b1997bee3518b4d\",\"area\":{\"boAreaCode\":\"MAIN\",\"boAreaId\":\"59b6f7cec84e441db2fea4a63700a175\",\"boAreaName\":\"主表区\",\"parentAreaId\":\"\",\"rowDatas\":[{\"boSourceRowId\":\"\",\"datas\":{\"USERS_ID\":{\"dataType\":\"PERSON\",\"initValueType\":\"\",\"style\":\"\",\"value\":[{\"icon\":\"\",\"title\":{\"zh_CN\":\"SAP\"},\"value\":\"02b3935a9267eccb7837cfa21b600000\"}],\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.739\",\"valueCipher\":\"\"},\"F_CJMS_01\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"02a8e1df3e13b422b0d3b49db0aa0000\":{\"02b48a8ed0e7eccb7837cfa21b600001\":{\"mappingId\":\"02af615c71f2d0c20cfcf8ca22b90001\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40db435354bc876cf8528b7460001\",\"value\":\"02af14bc6db2d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"valueCipher\":\"\"},\"EXCLUDE_TAX_AMOUNT_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"SPECIAL_INVOICE_COUNT\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":0,\"valueCipher\":\"\"},\"TAX_AMOUNT_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"GSBER\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"02a5f9acc23620c86c584685a1ed0000\":{\"02b48a835d57eccb7837cfa21b600001\":{\"mappingId\":\"02aae6abfc0a7b2e64c50ec001f40000\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40db435354bc876cf8528b7460001\",\"value\":\"02af14bc6db2d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"valueCipher\":\"\"},\"CREATOR_ID\":{\"dataType\":\"PERSON\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"SAP\"},\"value\":\"02b3935a9267eccb7837cfa21b600000\"},\"valueCipher\":\"\"},\"TAX_AMOUNT\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"LOAN_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_TYPE_MAJOR\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"MAJOR_TYPE_QT\",\"valueCipher\":\"\"},\"BILL_CODE\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"PA0220221111000088\",\"valueCipher\":\"\"},\"FUND_MODEL_AREA_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"F_SFAYSP\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"en_US\":\"N\",\"zh_CN\":\"否\"},\"value\":\"6b8ff0809ebe11e88b7219c3aed96e32\"},\"valueCipher\":\"\"},\"APPLICANT_CREDIT_RANK\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"好 100\",\"valueCipher\":\"\"},\"EXPENDETAISUMAPPRO\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"WRITEOFF_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_TYPE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"341d8ef1820d11eb9ac65ff5e2820eae\",\"valueCipher\":\"\"},\"BILL_TYPE_CODE\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"PAYMENT\",\"valueCipher\":\"\"},\"EXPENSE_RECORD_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"EXPENSE_RECORD_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"F_SFPOCC\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"是\"},\"value\":\"6b8ff07f9ebe11e88b7247d35c1e5077\"},\"valueCipher\":\"\"},\"APPLICANT_PHONE_NUMBER\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"F_LSHDJB\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"5270D07PA0220221111000088\",\"valueCipher\":\"\"},\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.739\",\"valueCipher\":\"\"},\"APPLICANT_ID\":{\"dataType\":\"PERSON\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"黄东坤\"},\"value\":\"02b00f453cb49db36c02c51f0a8e0001\"},\"valueCipher\":\"\"},\"ACCOUNTING_SUBJECT\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"TZS-5270-利星行天竺之星汽车有限公司\"},\"value\":\"02c254a5d240da80564ecb3717780000\"},\"valueCipher\":\"\"},\"WRITEOFF_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"APPLICANT_RANK_ID\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"职员\"},\"value\":\"6b8ce33e9ebe11e88b725144aeff8091\"},\"valueCipher\":\"\"},\"BUDGET_SUMAPPROVAL_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"DATA_SOURCE_TYPE\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"PC_INPUT\",\"valueCipher\":\"\"},\"EXPENRECORSUMAPPRO\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"F_TKDH\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"STEXT\",\"hidden\":false,\"initValueType\":\"\",\"style\":\"\",\"value\":\"REF20210908002911\",\"valueCipher\":\"\"},\"EXPENRECORSUMAPPRO_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"BUDGET_SUMAPPROVAL\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"PAYMENT_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_STATUS\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"UNCOMMITTED\",\"valueCipher\":\"\"},\"F_LCLX\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"D07-客户退款\"},\"value\":\"02af145b7452d0c20cfcf8ca22b90000\"},\"valueCipher\":\"\"},\"REPAYMENT_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"ENABLE_BUDGET\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"FALSE\",\"valueCipher\":\"\"},\"INVOICE_COUNT\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":0,\"valueCipher\":\"\"},\"REPAYMENT_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"EXPENSE_DETAIL_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"EXPENDETAISUMAPPRO_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"LOAN_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"F_YWLX\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"02a40db435354bc876cf8528b7460001\":{\"02b48a7cbf67eccb7837cfa21b600001\":{\"mappingId\":\"02aa8bf8bffa7b2e64c50ec001f40001\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40dafa4554bc876cf8528b7460001\",\"value\":\"02af145b7452d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"D0710-4E专用-新车\"},\"value\":\"02af14bc6db2d0c20cfcf8ca22b90000\"},\"valueCipher\":\"\"},\"APPLICANT_POST_ID\":{\"dataSourceScope\":[],\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"valueCipher\":\"\"},\"INCLUDE_TAX_AMOUNT\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"ACCOUNT_CURRENCY_ID\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"en_US\":\"RMB\",\"zh_CN\":\"人民币\"},\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\"},\"valueCipher\":\"\"},\"APP_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"e3d5e4787ff911e88b1997bee3518b4d\",\"valueCipher\":\"\"},\"APPLICANT_DEPARTMENT_ID\":{\"dataSourceScope\":[\"02c127f60c030d10b718bf741a3a0000\"],\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"财务部\"},\"value\":\"02c127f60c030d10b718bf741a3a0000\"},\"valueCipher\":\"\"},\"APPLICANT_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11\",\"valueCipher\":\"\"},\"BUDGET_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"EXPENSE_DETAIL_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"ENABLE_FUND\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"false\",\"valueCipher\":\"\"},\"EXCLUDE_TAX_AMOUNT\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"APPLICANT_EMAIL\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"PAYMENT_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"INCLUDE_TAX_AMOUNT_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"APPLICANT_ORG_ID\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"利星行（中国）汽车企业管理有限公司\"},\"value\":\"02ae141a8b22d0c20cfcf8ca22b90001\"},\"valueCipher\":\"\"},\"IS_OVER_STANDARD\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"FALSE\",\"valueCipher\":\"\"},\"BUDGET_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"LOAN_SUM_APPROVAL\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0.00,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"LOAN_SUM_APPROVAL_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"BILL_TYPE_CATEGORY\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"BILL\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_HISTORY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c468d787716646b5e59ac80e840001\",\"valueCipher\":\"\"},\"ZFKLX\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"9862c05ab5e811ea85f6dde93c1eccd4\":{\"02b48a8918a7eccb7837cfa21b600001\":{\"mappingId\":\"02aae6edecea7b2e64c50ec001f40001\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40dafa4554bc876cf8528b7460001\",\"value\":\"02af145b7452d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"客户退款\"},\"value\":\"0299cdaad1423cdcb697de5406c90000\"},\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f4d82d4396ba0989ef2560000\",\"subAreaDatas\":{\"02a5fe2f5be620c86c584685a1ed0001\":{\"boAreaCode\":\"T_BILL_AREA_SKF_DEF_001\",\"boAreaId\":\"02a5fe2f5be620c86c584685a1ed0001\",\"boAreaName\":\"收款方未清信息\",\"parentAreaId\":\"59b6f7cec84e441db2fea4a63700a175\",\"rowDatas\":[{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"F_BCFKJE\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"MONEY\",\"initValueType\":\"\",\"required\":true,\"style\":\"\",\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560003\",\"valueCipher\":\"\"},\"F_LRZX\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"dimQueryFilterMap\":{\"02a5f9ffafa620c86c584685a1ed0000\":{\"resultMap\":{},\"ruleJsResultMap\":{\"param0\":{\"type\":\"TXT\",\"value\":\"02c254a5d240da80564ecb3717780000\"}},\"ruleSql\":\"rN1D21OSXR1bw%2BaTtSrrY4es4RSg%2FZV4NHjCNDcaAA4%3D\"}},\"initValueType\":\"\",\"style\":\"\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"02c48f9f4d82d4396ba0989ef2560000\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560003\",\"subAreaDatas\":{}}]},\"85b45eacb44f4bf1a97693812f3001b6\":{\"boAreaCode\":\"PAYMENT\",\"boAreaId\":\"85b45eacb44f4bf1a97693812f3001b6\",\"boAreaName\":\"付款区\",\"parentAreaId\":\"59b6f7cec84e441db2fea4a63700a175\",\"rowDatas\":[{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.785\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.785\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"PAYMENT_ACCOUNT_NO\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"PAYMENT_ACCOUNT\",\"dimQueryFilterMap\":{\"6b8ce3219ebe11e88b7219dddf02a046\":{\"resultMap\":{},\"ruleJsResultMap\":{\"param0\":{\"type\":\"TXT\",\"value\":\"利星行天竺之星汽车有限公司\"}},\"ruleSql\":\"p25XH7pWkIPGhIuDon%2FwSSUvPQOgY4Fllw42fTLu3ABNNF%2F7YczqRuYp9mWetJ4I\"}},\"initValueType\":\"\",\"style\":\"\",\"valueCipher\":\"\"},\"NBFK\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"1\",\"valueCipher\":\"\"},\"SETTLEMENT_METHOD\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"title\":{\"zh_CN\":\"共享银企直联\"},\"value\":\"02af68648bc2d0c20cfcf8ca22b90001\"},\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"02c48f9f4d82d4396ba0989ef2560000\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560000\",\"subAreaDatas\":{}}]},\"02a8e414f9b3b422b0d3b49db0aa0000\":{\"boAreaCode\":\"T_BILL_AREA_HXQ_DEF_001\",\"boAreaId\":\"02a8e414f9b3b422b0d3b49db0aa0000\",\"boAreaName\":\"核销区\",\"parentAreaId\":\"59b6f7cec84e441db2fea4a63700a175\",\"rowDatas\":[{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560005\",\"valueCipher\":\"\"},\"F_LRZX\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"dimQueryFilterMap\":{\"02a5f9ffafa620c86c584685a1ed0000\":{\"resultMap\":{},\"ruleJsResultMap\":{\"param0\":{\"type\":\"TXT\",\"value\":\"02c254a5d240da80564ecb3717780000\"}},\"ruleSql\":\"rN1D21OSXR1bw%2BaTtSrrY4es4RSg%2FZV4NHjCNDcaAA4%3D\"}},\"initValueType\":\"\",\"style\":\"\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"02c48f9f4d82d4396ba0989ef2560000\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560005\",\"subAreaDatas\":{}}]}}}]},\"areaTemplateRow\":{\"02a5fe2f5be620c86c584685a1ed0001\":{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560002\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560002\",\"subAreaDatas\":{}},\"85b45eacb44f4bf1a97693812f3001b6\":{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.785\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.785\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f5192d4396ba0989ef2560001\",\"valueCipher\":\"\"},\"SETTLEMENT_METHOD\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"共享银企直联\"},\"value\":\"02af68648bc2d0c20cfcf8ca22b90001\"},\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f5192d4396ba0989ef2560001\",\"subAreaDatas\":{}},\"4df29cc11fad11ea86ef7d7f3cfa5480\":{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560001\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560001\",\"subAreaDatas\":{}},\"ebb02ca40f7f491291b988f25c82ec0e\":{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560007\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560007\",\"subAreaDatas\":{}},\"59b6f7cec84e441db2fea4a63700a175\":{\"boSourceRowId\":\"\",\"datas\":{\"USERS_ID\":{\"dataType\":\"PERSON\",\"initValueType\":\"\",\"style\":\"\",\"value\":[{\"icon\":\"\",\"title\":{\"zh_CN\":\"SAP\"},\"value\":\"02b3935a9267eccb7837cfa21b600000\"}],\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.739\",\"valueCipher\":\"\"},\"F_CJMS_01\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"02a8e1df3e13b422b0d3b49db0aa0000\":{\"02b48a8ed0e7eccb7837cfa21b600001\":{\"mappingId\":\"02af615c71f2d0c20cfcf8ca22b90001\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40db435354bc876cf8528b7460001\",\"value\":\"02af14bc6db2d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"valueCipher\":\"\"},\"EXCLUDE_TAX_AMOUNT_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"SPECIAL_INVOICE_COUNT\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":0,\"valueCipher\":\"\"},\"TAX_AMOUNT_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"GSBER\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"02a5f9acc23620c86c584685a1ed0000\":{\"02b48a835d57eccb7837cfa21b600001\":{\"mappingId\":\"02aae6abfc0a7b2e64c50ec001f40000\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40db435354bc876cf8528b7460001\",\"value\":\"02af14bc6db2d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"valueCipher\":\"\"},\"CREATOR_ID\":{\"dataType\":\"PERSON\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"SAP\"},\"value\":\"02b3935a9267eccb7837cfa21b600000\"},\"valueCipher\":\"\"},\"TAX_AMOUNT\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"LOAN_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_TYPE_MAJOR\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"MAJOR_TYPE_QT\",\"valueCipher\":\"\"},\"BILL_CODE\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"PA0220221111000088\",\"valueCipher\":\"\"},\"FUND_MODEL_AREA_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"F_SFAYSP\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"en_US\":\"N\",\"zh_CN\":\"否\"},\"value\":\"6b8ff0809ebe11e88b7219c3aed96e32\"},\"valueCipher\":\"\"},\"APPLICANT_CREDIT_RANK\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"好 100\",\"valueCipher\":\"\"},\"EXPENDETAISUMAPPRO\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"WRITEOFF_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_TYPE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"341d8ef1820d11eb9ac65ff5e2820eae\",\"valueCipher\":\"\"},\"BILL_TYPE_CODE\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"PAYMENT\",\"valueCipher\":\"\"},\"EXPENSE_RECORD_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"EXPENSE_RECORD_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"},\"F_SFPOCC\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"是\"},\"value\":\"6b8ff07f9ebe11e88b7247d35c1e5077\"},\"valueCipher\":\"\"},\"APPLICANT_PHONE_NUMBER\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"F_LSHDJB\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"5270D07PA0220221111000088\",\"valueCipher\":\"\"},\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.739\",\"valueCipher\":\"\"},\"APPLICANT_ID\":{\"dataType\":\"PERSON\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"黄东坤\"},\"value\":\"02b00f453cb49db36c02c51f0a8e0001\"},\"valueCipher\":\"\"},\"ACCOUNTING_SUBJECT\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"TZS-5270-利星行天竺之星汽车有限公司\"},\"value\":\"02c254a5d240da80564ecb3717780000\"},\"valueCipher\":\"\"},\"WRITEOFF_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"APPLICANT_RANK_ID\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"职员\"},\"value\":\"6b8ce33e9ebe11e88b725144aeff8091\"},\"valueCipher\":\"\"},\"BUDGET_SUMAPPROVAL_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"DATA_SOURCE_TYPE\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"PC_INPUT\",\"valueCipher\":\"\"},\"EXPENRECORSUMAPPRO\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"F_TKDH\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"STEXT\",\"hidden\":false,\"initValueType\":\"\",\"style\":\"\",\"value\":\"REF20210908002911\",\"valueCipher\":\"\"},\"EXPENRECORSUMAPPRO_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"BUDGET_SUMAPPROVAL\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"PAYMENT_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_STATUS\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"UNCOMMITTED\",\"valueCipher\":\"\"},\"F_LCLX\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"D07-客户退款\"},\"value\":\"02af145b7452d0c20cfcf8ca22b90000\"},\"valueCipher\":\"\"},\"REPAYMENT_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"ENABLE_BUDGET\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"FALSE\",\"valueCipher\":\"\"},\"INVOICE_COUNT\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":0,\"valueCipher\":\"\"},\"REPAYMENT_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"EXPENSE_DETAIL_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"EXPENDETAISUMAPPRO_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"LOAN_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"F_YWLX\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"02a40db435354bc876cf8528b7460001\":{\"02b48a7cbf67eccb7837cfa21b600001\":{\"mappingId\":\"02aa8bf8bffa7b2e64c50ec001f40001\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40dafa4554bc876cf8528b7460001\",\"value\":\"02af145b7452d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"D0710-4E专用-新车\"},\"value\":\"02af14bc6db2d0c20cfcf8ca22b90000\"},\"valueCipher\":\"\"},\"APPLICANT_POST_ID\":{\"dataSourceScope\":[],\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"valueCipher\":\"\"},\"INCLUDE_TAX_AMOUNT\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"ACCOUNT_CURRENCY_ID\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"en_US\":\"RMB\",\"zh_CN\":\"人民币\"},\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\"},\"valueCipher\":\"\"},\"APP_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"e3d5e4787ff911e88b1997bee3518b4d\",\"valueCipher\":\"\"},\"APPLICANT_DEPARTMENT_ID\":{\"dataSourceScope\":[\"02c127f60c030d10b718bf741a3a0000\"],\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"财务部\"},\"value\":\"02c127f60c030d10b718bf741a3a0000\"},\"valueCipher\":\"\"},\"APPLICANT_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11\",\"valueCipher\":\"\"},\"BUDGET_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"EXPENSE_DETAIL_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"ENABLE_FUND\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"false\",\"valueCipher\":\"\"},\"EXCLUDE_TAX_AMOUNT\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"APPLICANT_EMAIL\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"PAYMENT_SUM_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"INCLUDE_TAX_AMOUNT_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"APPLICANT_ORG_ID\":{\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"利星行（中国）汽车企业管理有限公司\"},\"value\":\"02ae141a8b22d0c20cfcf8ca22b90001\"},\"valueCipher\":\"\"},\"IS_OVER_STANDARD\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"FALSE\",\"valueCipher\":\"\"},\"BUDGET_SUM\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"LOAN_SUM_APPROVAL\":{\"dataType\":\"MONEY\",\"initValueType\":\"\",\"style\":\"\",\"value\":{\"amount\":0.00,\"capital\":\"\",\"currencyId\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"currencySymbol\":\"\",\"description\":\"\",\"exchangeRate\":1,\"factor\":0},\"valueCipher\":\"\"},\"LOAN_SUM_APPROVAL_CURRENCY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"6e589eb2dd9f11e8b5a69590a14a4e34\",\"valueCipher\":\"\"},\"BILL_TYPE_CATEGORY\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"BILL\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_HISTORY_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c468d787716646b5e59ac80e840001\",\"valueCipher\":\"\"},\"ZFKLX\":{\"dataAttribute\":\"DEFAULT\",\"dataType\":\"DROPDOWN\",\"initValueType\":\"\",\"mpCondMap\":{\"9862c05ab5e811ea85f6dde93c1eccd4\":{\"02b48a8918a7eccb7837cfa21b600001\":{\"mappingId\":\"02aae6edecea7b2e64c50ec001f40001\",\"queryCondition\":[{\"mappingDefineTypeId\":\"02a40dafa4554bc876cf8528b7460001\",\"value\":\"02af145b7452d0c20cfcf8ca22b90000\"}]}}},\"style\":\"\",\"value\":{\"icon\":\"\",\"title\":{\"zh_CN\":\"客户退款\"},\"value\":\"0299cdaad1423cdcb697de5406c90000\"},\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f4d82d4396ba0989ef2560000\",\"subAreaDatas\":{}},\"02a8e4f45ee3b422b0d3b49db0aa0000\":{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560006\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560006\",\"subAreaDatas\":{}},\"02a8e414f9b3b422b0d3b49db0aa0000\":{\"boSourceRowId\":\"\",\"datas\":{\"CREATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"BILL_PARENT_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"\",\"valueCipher\":\"\"},\"ROW_NUM\":{\"dataType\":\"NUMBER\",\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"UPDATE_DATE\":{\"dataType\":\"DATE\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"2022-11-11T10:08:21.788\",\"valueCipher\":\"\"},\"VERSION\":{\"dataType\":\"NUMBER\",\"decimal\":0,\"initValueType\":\"\",\"style\":\"\",\"value\":1,\"valueCipher\":\"\"},\"BILL_DEFINE_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02a98989fc83b422b0d3b49db0aa0001\",\"valueCipher\":\"\"},\"BILL_ROW_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f51c2d4396ba0989ef2560004\",\"valueCipher\":\"\"},\"BILL_MAIN_ID\":{\"dataType\":\"STEXT\",\"initValueType\":\"\",\"style\":\"\",\"value\":\"02c48f9f4d82d4396ba0989ef2560000\",\"valueCipher\":\"\"}},\"parentId\":\"\",\"reserve\":false,\"rowId\":\"02c48f9f51c2d4396ba0989ef2560004\",\"subAreaDatas\":{}}},\"billButtons\":[{\"authority\":false,\"childs\":[],\"icon\":\"GOBACK\",\"id\":\"GOBACK\",\"languageKey\":\"GOBACK\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"OPERATOR_VIEW\",\"VIEW\",\"WRITE\"],\"separator\":false,\"title\":\"返回\"},{\"authority\":false,\"childs\":[],\"icon\":\"PRINT\",\"id\":\"PRINT\",\"languageKey\":\"PRINT\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"OPERATOR_VIEW\",\"VIEW\",\"WRITE\"],\"separator\":false,\"title\":\"打印\"},{\"authority\":true,\"childs\":[],\"icon\":\"VIEW_FLOW\",\"id\":\"VIEW_FLOW\",\"languageKey\":\"VIEW_FLOW\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"OPERATOR_VIEW\",\"VIEW\",\"WRITE\"],\"separator\":false,\"title\":\"查看流程\"},{\"authority\":false,\"childs\":[],\"icon\":\"PREVIEW_VOUCHER\",\"id\":\"PREVIEW_VOUCHER\",\"languageKey\":\"PREVIEW_VOUCHER\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"OPERATOR_VIEW\",\"WRITE\"],\"separator\":false,\"title\":\"仅预览凭证\"},{\"authority\":false,\"childs\":[{\"authority\":false,\"childs\":[],\"icon\":\"COLLECTION\",\"id\":\"COLLECTION\",\"languageKey\":\"COLLECTION\",\"parentId\":\"MORE\",\"scences\":[\"WRITE\"],\"separator\":false,\"title\":\"收藏\"},{\"authority\":false,\"childs\":[],\"icon\":\"DELETE\",\"id\":\"DELETE\",\"languageKey\":\"DELETE\",\"parentId\":\"MORE\",\"scences\":[\"WRITE\"],\"separator\":false,\"title\":\"删除\"}],\"icon\":\"MORE\",\"id\":\"MORE\",\"languageKey\":\"MORE\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"OPERATOR_VIEW\",\"VIEW\",\"WRITE\"],\"separator\":false,\"title\":\"更多\"},{\"authority\":false,\"childs\":[],\"icon\":\"SAVE\",\"id\":\"SAVE\",\"languageKey\":\"SAVE\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"WRITE\"],\"separator\":false,\"title\":\"保存\"},{\"authority\":true,\"childs\":[],\"icon\":\"SUBMIT\",\"id\":\"SUBMIT\",\"languageKey\":\"SUBMIT\",\"parentId\":\"\",\"scences\":[\"EXAMINE_APPROVAL\",\"WRITE\"],\"separator\":false,\"title\":\"提交\"}],\"billCode\":\"PA0220221111000088\",\"billDefineCode\":\"PA02\",\"billDefineHistoryId\":\"02c468d787716646b5e59ac80e840001\",\"billDefineId\":\"02a98989fc83b422b0d3b49db0aa0001\",\"billMainId\":\"02c48f9f4d82d4396ba0989ef2560000\",\"billTypeCategory\":\"BILL\",\"billTypeCode\":\"PAYMENT\",\"billTypeId\":\"341d8ef1820d11eb9ac65ff5e2820eae\",\"billTypeMajor\":\"MAJOR_TYPE_QT\",\"checkFlowFieldRequire\":false,\"commit\":false,\"companyId\":\"02ae141a8b22d0c20cfcf8ca22b90001\",\"createNew\":true,\"currentUserId\":\"\",\"dataModify\":false,\"departmentId\":\"02c127f60c030d10b718bf741a3a0000\",\"enableFund\":false,\"executeRule\":true,\"fundModelAreaId\":\"\",\"gradedAuthorOrgRuleIds\":{\"6b8ce3149ebe11e88b72b9b7065e24cb\":[\"02c468d6f5216646b5e59ac80e840000\",\"02c3b8026d940bef4cb946c7b29d0001\",\"02c468d6f2916646b5e59ac80e840000\",\"02c44c9d2bf4690d10d9b437f2080000\",\"02af6acabfc2d0c20cfcf8ca22b90001\",\"02af6b220102d0c20cfcf8ca22b90000\",\"02afb0bec352d0c20cfcf8ca22b90000\",\"02afb0e0c6c2d0c20cfcf8ca22b90001\",\"02afb1016042d0c20cfcf8ca22b90000\",\"02b42581daf7eccb7837cfa21b600001\",\"02b425b3c3a7eccb7837cfa21b600000\",\"02b425c76427eccb7837cfa21b600000\",\"02b42655d727eccb7837cfa21b600000\",\"02b4272a49a7eccb7837cfa21b600001\",\"02b429dc35b7eccb7837cfa21b600001\",\"02b442598d47eccb7837cfa21b600001\",\"02b4759fced7eccb7837cfa21b600001\",\"02b486918697eccb7837cfa21b600000\",\"02b48a7cbf67eccb7837cfa21b600001\",\"02b48a835d57eccb7837cfa21b600001\",\"02b48a8918a7eccb7837cfa21b600001\",\"02b48a8ed0e7eccb7837cfa21b600001\",\"02b48b020c87eccb7837cfa21b600001\",\"02b48b0df4d7eccb7837cfa21b600001\",\"02b48b2092b7eccb7837cfa21b600001\",\"02b48b322a07eccb7837cfa21b600000\",\"02b48b481787eccb7837cfa21b600001\",\"02b48ba35497eccb7837cfa21b600001\",\"02b4e035f467eccb7837cfa21b600001\",\"02b4e0531687eccb7837cfa21b600000\",\"02b4e1fa06a7eccb7837cfa21b600000\",\"02b4e2482ee7eccb7837cfa21b600000\",\"02b5d7fc3e07eccb7837cfa21b600000\",\"02b9f5ea207897a9fd6e7227f9e70001\",\"02ba42b9a0b6a13e119af26d3cd60001\",\"02ba431d5b56a13e119af26d3cd60000\",\"02ba43dfd036a13e119af26d3cd60001\",\"02ba500ff67cc824211dc69da5780001\",\"02ba93ff714604f78ad9fde72f660001\",\"02bb3bf4d70ce95dfcd1ea7dc0c80000\",\"02bb9f1b3f481dc76daa984759a00001\",\"02bd80c84b2db1f468de94a609240001\",\"02bd860356c48b5fdfb6e91b50330001\",\"02bf6e74e50d616acd81d7de55450001\",\"02bf6e82441d616acd81d7de55450001\",\"02bf6f4e0cfd616acd81d7de55450001\",\"02c219069c1155c116d650898d8a0001\",\"02c2191c1c9155c116d650898d8a0001\",\"02c2192931e155c116d650898d8a0001\",\"02c21b1c7b6155c116d650898d8a0000\",\"02c24f00a500da80564ecb3717780001\",\"02c3b9719dc40bef4cb946c7b29d0001\",\"02c3fe9219ffa3a0ed503acbdbbe0000\",\"02c3fe9c6dbfa3a0ed503acbdbbe0001\",\"02c449b5cc04690d10d9b437f2080001\",\"02c449cb01c4690d10d9b437f2080001\",\"02c454c34784c731a2870b50f54a0001\",\"02af69ad96d2d0c20cfcf8ca22b90000\",\"02af69ada332d0c20cfcf8ca22b90000\",\"02b4e1c5e887eccb7837cfa21b600001\",\"02af69adb152d0c20cfcf8ca22b90000\"]},\"needCheckStandard\":true,\"operationType\":\"ADD\",\"relationMachineWriteBackCurrency\":{},\"saveJsonData\":true,\"scene\":\"WRITE\",\"statusEnum\":\"UNCOMMITTED\",\"taskId\":\"\",\"userDefinedData\":{\"enterWFInstance\":false,\"hasWFInstance\":false},\"version\":1},\"message\":\"\",\"messageType\":\"INFO\",\"success\":true}";
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