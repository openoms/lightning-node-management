### [Check if your RaspiBlitz was affected by the CVE-2019-12999 bug](chanleakcheck_RaspiBlitz.sh)

* Only LND versions below 0.7.1 could have been affected.
* If you started with the RaspiBlitz v1.3 (running lnd 0.7.1) there is no need to run this script.
* Using this tool: https://github.com/lightninglabs/chanleakcheck
* More Details and explanation:
https://blog.lightning.engineering/security/2019/09/27/cve-2019-12999.html

* Download and run the script on the RaspiBlitz:  
`$ wget https://raw.githubusercontent.com/openoms/lightning-node-management/master/chanleakcheck_RaspiBlitz.sh && sudo bash chanleakcheck_RaspiBlitz.sh`