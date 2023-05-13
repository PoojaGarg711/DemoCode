A simple 3 tier architecture is implemented here using App service as Front end, Function app as Middle layer and SQL DB as backend:

![image](https://github.com/PoojaGarg711/DemoCode/assets/133501504/bde8ec4e-67c8-4ed5-96ef-e1fa3cdaff66)

Architecture is created on Azure Clod
IAC is created using Bicep langague and deployed via Azure DevOps yaml pipeline

It contains:
Vnet template with 2 subnets and a default NSG
Web app template to dpeloy frontend service
Function app template todpeloy middle layer having public access restricted
Database template to dpeloy azure sql server and a db

