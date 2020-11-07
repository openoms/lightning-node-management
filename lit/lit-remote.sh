s@X1:/media/veracrypt1/titkok/nodes/1.2$ scp admin@172.22.1.2:~/.lnd/data/chain/bitcoin/mainnet/* ./
admin.macaroon                                100%  280     3.4KB/s   00:00    
chainnotifier.macaroon                        100%   83     1.0KB/s   00:00    
channel.backup                                100% 5520    67.2KB/s   00:00    
invoice.macaroon                              100%  132     1.6KB/s   00:00    
invoices.macaroon                             100%   91     1.1KB/s   00:00    
readonly.macaroon                             100%  199     2.4KB/s   00:00    
router.macaroon                               100%   91     1.1KB/s   00:00    
signer.macaroon                               100%   92     0.9KB/s   00:00    
walletkit.macaroon                            100%  114     1.4KB/s   00:00    
s@X1:/media/veracrypt1/titkok/nodes/1.2$ scp admin@172.22.1.2:/mnt/hdd/lnd/tls.cert ./
tls.cert                                      100%  891    10.9KB/s   00:00    
s@X1:/media/veracrypt1/titkok/nodes/1.2$ 


remote.lnd.rpcserver=<externally-reachable-ip-address>:10009
remote.lnd.macaroonpath=/some/folder/with/lnd/data/admin.macaroon
remote.lnd.tlscertpath=/some/folder/with/lnd/data/tls.cert

# /media/veracrypt1/titkok/nodes/1.2/
remote.lnd.rpcserver=172.22.1.2:10009
remote.lnd.macaroondir=/media/veracrypt1/titkok/nodes/1.2/
remote.lnd.tlscertpath=/media/veracrypt1/titkok/nodes/1.2/tls.cert

nano ~/.lit/lit.conf