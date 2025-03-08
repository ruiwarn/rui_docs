# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = '智能断路器产品线文档集'
copyright = '2024, 王瑞'
author = '王瑞'
release = 'v1.0.0'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'recommonmark',
    'sphinx_markdown_tables',
    'sphinxcontrib.mermaid'
]

templates_path = ['_templates']
exclude_patterns = []

language = 'en'

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_theme_options = {
    'style_nav_header_background': '#2980B9',  # 设置导航栏头部背景颜色
    'style_external_links': False,  # 禁用外部链接的特殊样式
    'sticky_navigation': True,  # 启用粘性导航
    'navigation_depth': 4,  # 设置导航深度为4级
    'includehidden': True,  # 包含隐藏的toctree项
    'titles_only': False,  # 在导航中显示完整的页面标题
    'collapse_navigation': False,  # 禁用导航折叠功能
}
# 添加以下行来指定logo图片
# html_logo = '_static/logo.png'
# html_css_files = [
#     'custom.css',
# ]
# # html_title = ''

html_static_path = ['_static']
html_css_files = [
    'custom.css',
]

# Mermaid configuration
mermaid_version = "8.13.5"  # 指定 Mermaid.js 的版本
mermaid_output_format = 'raw'  # 使用原始的 Mermaid 语法输出
mermaid_init_js = (
    "var config = {"
    "    startOnLoad: true,"
    "    theme: 'default',"
    "    flowchart: {"
    "        useMaxWidth: false,"
    "        htmlLabels: true"
    "    }"
    "};"
    "mermaid.initialize(config);"
)

# 禁用外部 Mermaid CLI
mermaid_cmd = ""

