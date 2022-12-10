# Multi-domain Network Infrastructure based on P4 Programmable Devices for DDMs

This repository includes the files that are used for setting up a connection between containers of multiple domains using P4 programming language. The related file is in P4 code folder. It also includes the related files for measuring the performance of P4-based network between containers by measuring the time is needed for completing the setup process of a sharing request in such an architecture. It includes the time needed for:

1. creating containers: createcontainers.sh
2. setting up the interfaces: paddinterface.sh
3. setting up the rules: paddrule.sh
4. transfering message between domains for exchanging connection information: psend.py and precieve.py

The file automation.sh automize the process of setting up sharing requests and measuring the time needed for completing each sharing request. 
