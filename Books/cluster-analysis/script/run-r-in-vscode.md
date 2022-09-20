
**How to setup?**  
1.Firstly run the following command in your traditional R console:

```r
install.packages("languageserver")
```

2.Install extensions:

[Extension 01: Install extension R by Yuki Ueda](https://marketplace.visualstudio.com/items?itemName=Ikuyadeu.r)

[Estension 02: R LSP Client by REditorSupport](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r-lsp)

[Extension 03: Install extension Code Runner by Jun Han](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

[Extension 04: Path Intellisense by Christian Kohler](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense)

3.Next run this command in the terminal to install radian. It is a python module which has better color scheme and representations for R outputs in console. It serves as an alternative to the R console.

```py
pip install -U radian
```

4.Finally add these lines in the **settings.json** of your editor

```json
"r.bracketedPaste": true,
"r.rterm.windows": "*Path to radian executable*", //Use this only for Windows 
"r.rterm.linux": "*Path to radian executable*", //Use this only for Linux
"r.rterm.mac": "*Path to radian executable*", //Use this only for a Mac
"r.lsp.path": "*Path to your R executable*",
"r.lsp.debug": true,
"r.lsp.diagnostics": true,
"r.rterm.option": [
    "--no-save",
    "--no-restore",
    "--r-binary=*Path to R executable*"
],
```

5.Others Extensions:

[Excel Viewer by GrapeCity](https://marketplace.visualstudio.com/items?itemName=GrapeCity.gc-excelviewer)

[vscode-pdf by tomoki1207](https://marketplace.visualstudio.com/items?itemName=tomoki1207.pdf)


