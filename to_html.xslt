<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- 设置输出为 HTML 格式 -->
    <xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>

    <!-- 匹配根节点，生成 HTML 页面的整体结构 -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Unit Test Results</title>
                <!-- 定义页面样式 -->
                <style type="text/css">
                    td#passed {
                        color: green;
                        font-weight: bold;
                    }
                    td#failed {
                        color: red;
                        font-weight: bold;
                    }
                    body {
                        width: 80%;
                        margin: 40px auto;
                        font-family: 'trebuchet MS', 'Lucida sans', Arial;
                        font-size: 14px;
                        color: #444;
                    }
                    table {
                        *border-collapse: collapse; /* IE7 and lower */
                        border-spacing: 0;
                        width: 100%;
                    }
                    .bordered {
                        border: solid #ccc 1px;
                        -moz-border-radius: 6px;
                        -webkit-border-radius: 6px;
                        border-radius: 6px;
                        -webkit-box-shadow: 0 1px 1px #ccc;
                        -moz-box-shadow: 0 1px 1px #ccc;
                        box-shadow: 0 1px 1px #ccc;
                    }
                    .bordered tr:hover {
                        background: #fbf8e9;
                        -o-transition: all 0.1s ease-in-out;
                        -webkit-transition: all 0.1s ease-in-out;
                        -moz-transition: all 0.1s ease-in-out;
                        -ms-transition: all 0.1s ease-in-out;
                        transition: all 0.1s ease-in-out;
                    }
                    .bordered td,
                    .bordered th {
                        border-left: 1px solid #ccc;
                        border-top: 1px solid #ccc;
                        padding: 10px;
                        text-align: left;
                    }
                    .bordered th {
                        background-color: #dce9f9;
                        background-image: -webkit-gradient(linear, left top, left bottom, from(#ebf3fc), to(#dce9f9));
                        background-image: -webkit-linear-gradient(top, #ebf3fc, #dce9f9);
                        background-image: -moz-linear-gradient(top, #ebf3fc, #dce9f9);
                        background-image: -ms-linear-gradient(top, #ebf3fc, #dce9f9);
                        background-image: -o-linear-gradient(top, #ebf3fc, #dce9f9);
                        background-image: linear-gradient(top, #ebf3fc, #dce9f9);
                        -webkit-box-shadow: 0 1px 0 rgba(255, 255, 255, .8) inset;
                        -moz-box-shadow: 0 1px 0 rgba(255, 255, 255, .8) inset;
                        box-shadow: 0 1px 0 rgba(255, 255, 255, .8) inset;
                        border-top: none;
                        text-shadow: 0 1px 0 rgba(255, 255, 255, .5);
                    }
                    .bordered td:first-child,
                    .bordered th:first-child {
                        border-left: none;
                    }
                    .bordered th:first-child {
                        -moz-border-radius: 6px 0 0 0;
                        -webkit-border-radius: 6px 0 0 0;
                        border-radius: 6px 0 0 0;
                    }
                    .bordered th:last-child {
                        -moz-border-radius: 0 6px 0 0;
                        -webkit-border-radius: 0 6px 0 0;
                        border-radius: 0 6px 0 0;
                    }
                    .bordered th:only-child {
                        -moz-border-radius: 6px 6px 0 0;
                        -webkit-border-radius: 6px 6px 0 0;
                        border-radius: 6px 6px 0 0;
                    }
                    .bordered tr:last-child td:first-child {
                        -moz-border-radius: 0 0 0 6px;
                        -webkit-border-radius: 0 0 0 6px;
                        border-radius: 0 0 0 6px;
                    }
                    .bordered tr:last-child td:last-child {
                        -moz-border-radius: 0 0 6px 0;
                        -webkit-border-radius: 0 0 6px 0;
                        border-radius: 0 0 6px 0;
                    }
                    /* 设置 Passed 和 Failed 标签的样式 */
                    label[for="passed-radio"],
                    label[for="failed-radio"] {
                        font-size: 18px;
                        font-weight: bold;
                        margin-left: 5px;
                    }
                    label[for="failed-radio"] {
                        color: #ff0000;
                    }
                </style>
                <!-- 定义 JavaScript 代码，用于控制测试结果的显示 -->
                <script>
                    <![CDATA[
                        function showResults(resultType) {
                            var passedRows = document.querySelectorAll('.passed-row');
                            var failedRows = document.querySelectorAll('.failed-row');
                            var testSuites = document.querySelectorAll('.testsuite');

                            if (resultType === 'passed') {
                                passedRows.forEach(function (row) {
                                    row.style.display = 'table-row';
                                });
                                failedRows.forEach(function (row) {
                                    row.style.display = 'none';
                                });
                                testSuites.forEach(function (suite) {
                                    var hasPassedRows = suite.querySelectorAll('.passed-row').length > 0;
                                    if (hasPassedRows) {
                                        suite.style.display = 'block';
                                    } else {
                                        suite.style.display = 'none';
                                    }
                                });
                            } else {
                                passedRows.forEach(function (row) {
                                    row.style.display = 'none';
                                });
                                failedRows.forEach(function (row) {
                                    row.style.display = 'table-row';
                                });
                                testSuites.forEach(function (suite) {
                                    var hasFailedRows = suite.querySelectorAll('.failed-row').length > 0;
                                    if (hasFailedRows) {
                                        suite.style.display = 'block';
                                    } else {
                                        suite.style.display = 'none';
                                    }
                                });
                            }
                        }

                        // 页面加载时默认显示 failed 用例
                        window.onload = function () {
                            showResults('failed');
                            document.getElementById('failed-radio').checked = true;
                        }
                    ]]>
                </script>
            </head>
            <body>
                <!-- 应用模板处理 XML 数据 -->
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <!-- 匹配 testsuites 节点，显示测试运行的总体信息 -->
    <xsl:template match="testsuites">
        <h1>Unit Test Run <xsl:value-of select="@timestamp"/></h1>
        <p>
            Executed <b><xsl:value-of select="@tests"/></b> test cases in
            <b><xsl:value-of select="count(testsuite)"/></b> test suites,
            <b><xsl:value-of select="@failures"/></b> test cases failed.
            Execution time <b><xsl:value-of select="@time"/></b>
        </p>
        <!-- 添加全局的单选框，用于切换显示通过和失败的测试用例 -->
        <input type="radio" id="passed-radio" name="result-type" onclick="showResults('passed')" />
        <label for="passed-radio">Passed</label>
        <input type="radio" id="failed-radio" name="result-type" onclick="showResults('failed')" />
        <label for="failed-radio">Failed</label>

        <!-- 继续应用模板处理子节点 -->
        <xsl:apply-templates select="testsuite[count(testcase[*]) > 0 or count(testcase[not(*)]) > 0]"/>
    </xsl:template>

    <!-- 匹配 testsuite 节点，显示每个测试套件的信息 -->
    <xsl:template match="testsuite">
        <div class="testsuite" style="display: none;">
            <h2><xsl:value-of select="@name"/></h2>
            <table class="bordered">
                <tr>
                    <th style="width:30%">Test (<xsl:value-of select="@failures"/>/<xsl:value-of select="@tests"/> failed) </th>
                    <th>Message</th>
                    <th style="width:1%">Result</th>
                </tr>
                <!-- 遍历每个测试用例 -->
                <xsl:for-each select="testcase">
                    <xsl:choose>
                        <!-- 如果测试用例有子节点（表示失败） -->
                        <xsl:when test="*">
                            <tr class="failed-row">
                                <td><xsl:value-of select="@name"/></td>
                                <td id="failed">
                                    <xsl:for-each select="failure">
                                        <xsl:if test="@message">
                                            <xsl:value-of select="@message"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </td>
                                <td id="failed">FAIL</td>
                            </tr>
                        </xsl:when>
                        <!-- 如果测试用例没有子节点（表示通过） -->
                        <xsl:otherwise>
                            <tr class="passed-row" style="display: none;">
                                <td><xsl:value-of select="@name"/></td>
                                <td>
                                    <xsl:for-each select="@* [name()!='classname' and name()!='name' and name()!='status' and name()!='time']">
                                        <xsl:value-of select="name()"/>=<xsl:value-of select="."/><br/>
                                    </xsl:for-each>
                                    <xsl:for-each select="*">
                                        <xsl:value-of select="@message"/>
                                    </xsl:for-each>
                                </td>
                                <td id="passed">OK</td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>
</xsl:stylesheet>