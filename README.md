# gtest_to_html

当使用gtest编写单元测试用例的时候，可以使用xml参数将执行结果输出到xml文件，使用本工具可以将该xml转换为html。生成的html将测试用例的执行结果按testsuit分为不同的展示栏，同时passed和failed的测试用例分别在不同的页面展示，通过一个单选框决定展示所有测试通过的用例还是所有失败的用例，打开html时默认展示测试不通过的案例。

可以按如下脚本将该工具集成进cmake脚本：

```cmake
set(TEST_RESULTS_PATH ${CMAKE_BINARY_DIR}/test_results.xml)
# 注册测试
add_test(
    NAME ${PROJECT_NAME}
    COMMAND ${PROJECT_NAME} --gtest_output=xml:${TEST_RESULTS_PATH}
)

find_program(XSLTPROC_COMMAND xsltproc)
find_file(GTEST_XSLT_FILE to_html.xslt
    PATHS "${CMAKE_SOURCE_DIR}/deps/gtest_to_html"  # 确保路径正确
)

if(XSLTPROC_COMMAND AND GTEST_XSLT_FILE)
    if(NOT TARGET test_html)
        add_custom_target(test_html
            DEPENDS ${PROJECT_NAME}  # 依赖测试目标
            # 显式指定XML输出路径（根据实际情况调整）
            COMMAND ${XSLTPROC_COMMAND} 
                --output "${CMAKE_BINARY_DIR}/test_results.html"
                "${GTEST_XSLT_FILE}" 
                ${TEST_RESULTS_PATH}
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generating HTML test report with test suite hierarchy"
        )
    else()
        message(WARNING "The test_html target has been defined.")
    endif()
else()
    message(WARNING "HTML report generation requires xsltproc and gtest_html.xsl")
endif()
```
