### language

[中文](REDME.md)

[英文](REDME_en.md)

### This project is based on [kayaladream/Clash-Core-Change](https://github.com/kayaladream/Clash-Core-Change) and includes several improvements over the original version.

- Although there are many derivative clients of Clash, many users are still accustomed to using Clash for Windows.
- The following demonstration is based on version: **Clash.for.Windows-0.20.39-win**

---

### Usage Instructions

1. Download and place the **teamp_core** folder into the directory:  
   `C:\Clash for Windows\resources\static\files\win\x64`

2. Also place the **Switch-ClashCore.ps1** script into the same directory:  
   `C:\Clash for Windows\resources\static\files\win\x64`

> Note: Replace the above path with your actual installation directory.

![Path](./images/path.png)

3. Check and modify the program path specified inside *Switch-ClashCore.ps1* to match your installation directory.

   ![](./images/path_2.png)

4. Check the original kernel version:

   ![](./images/%E5%8E%9F%E7%89%88%E5%86%85%E6%A0%B8.png)

   ![](./images/%E5%8E%9F%E7%89%88%E5%86%85%E6%A0%B8%E7%89%88%E6%9C%AC.png)

5. Double-click to run the **Switch-ClashCore.ps1** script using **PowerShell**:

   - Important: Before executing the script, close Clash for Windows in the background if possible, otherwise the kernel files may be locked and switching may fail!

   - Perform the kernel-switching operation (as shown below):

   ![](./images/use_psl.png)

6. Launch the application and verify that the correct kernel version is loaded:

   ![](./images/%E5%88%87%E6%8D%A2%E5%90%8E%E7%9A%84%E5%86%85%E6%A0%B8%E7%89%88%E6%9C%AC1.png)

   ![](./images/%E5%88%87%E6%8D%A2%E5%90%8E%E7%9A%84%E5%86%85%E6%A0%B8%E7%89%88%E6%9C%AC2.png)

---

### Done!

---

### [References]

> [1] https://github.com/kayaladream/Clash-Core-Change/releases/tag/v2.0  
> [2] Mihomo Kernel Download: https://github.com/MetaCubeX/mihomo/releases  
> [3] Legacy Meta Kernel: https://github.com/MetaCubeX/mihomo/tree/v1.16.0  

---

## Disclaimer

**Important Notice: Please read the following disclaimer carefully before using this project.**

1. **Project Nature**: This project is a Clash kernel management and switching script developed for learning and research purposes, based on [Clash-Core-Change](https://github.com/kayaladream/Clash-Core-Change). This project and its author are not affiliated with the official Clash team or its core developers.

2. **For Educational Use Only**: All code and content in this project are provided solely for technical learning, discussion, and research. You may not use this project for any commercial or profit-making purposes.

3. **Legal and Compliant Usage**: When using this project’s scripts and any software downloaded or installed through them, you must strictly comply with the laws and regulations of your country or region. **You are strictly prohibited from using this project to engage in any activities that violate laws, regulations, or infringe upon the legitimate rights of others**, including but not limited to:
    * Unauthorized access to others’ networks or data.
    * Compromising network communication security.
    * Circumventing lawful network access restrictions.

4. **No Liability**: The author makes no express or implied warranties regarding the safety, stability, or functionality of this project’s code. **You assume full responsibility for any direct or indirect risks or consequences arising from your use of this project (including but not limited to software malfunctions, data loss, device issues, legal risks, etc.). The author shall not be held liable under any circumstances.**

5. **Open Source License**: This project is open-sourced under the [MIT License]. This means you are free to use, copy, modify, and distribute the code, **provided that you retain the original copyright notice and this disclaimer**.

**By using this project, you acknowledge that you have fully read, understood, and agreed to all terms of this disclaimer. You are solely responsible for all actions taken while using this project.**