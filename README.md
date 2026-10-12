## pwn_lab

This repository contains my personal solutions and exploit code for educational CTF platforms like pwnable.kr.  
All work was performed in isolated local lab environments to understand software vulnerabilities and master secure coding practices.

A minimalist for binary exploitation, low-level vulnerability research, and architecture security audits for educational CTFs. 

---

### 📂 Repository Structure

The workspace isolates global automation and tooling configurations from active research environments, allowing the entire repository to serve directly as a centralized Obsidian notebook.

* **`pwn_framework/`** — Core laboratory infrastructure.
  * **`environment/`** — Master Nix flakes and automated `direnv` terminal parameters.
  * **`templates/`** — Pure C shellcode pipelines (`shell.mk`), executable builders (`elf.mk`), and shortcut profiles.
  * **`scripts/`** — Global automation scripts and custom runtime debugger hooks.
* **`wiki/`** — Static, cross-linked technical reference material grouped by system domain (Architectures, Kernel, Heap Internals).
* **`challenges/`** — 
	* Active target analysis loops.  
	  Each sub-directory contains original assets (`bin/`),  
	  research notebooks (`notes/`),  
	  exploit/solution components (`exploit/`),  
	  raw data outputs (`artifacts/`).

---

### 🏆 Completed challenges

A chronological ledger showcasing verified root-cause analysis advisories and weaponized exploit implementations.  
challenges/pwnable_kr
 * [[brainfuck]]
 * [[challenges/pwnable_kr/Rookiss/echo2/bin/echo2|echo2]]
 * [[challenges/pwnable_kr/Rookiss/md5_calculator/bin/md5calculator|md5calculator]]
