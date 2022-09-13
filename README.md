## ddns + sshd_config notes

### background

ISPs may change your public IP.
Needed to maintain access to secured linux servers using [sshd_config](https://man7.org/linux/man-pages/man5/sshd_config.5.html).

### DDNS

Dynamic DNS (DDNS) services setup a fast TTL on the DNS records, [allowing a quicker-than-typical DNS change propagation](https://superuser.com/questions/453622/how-does-dynamicdns-act-immediately).
In my case, I chose to use [ydns](ydns.io), primarily because I quickly found a [script](https://raw.githubusercontent.com/ydns/bash-updater/master/updater.sh) to allow updates via an API.
I put this script in /etc/ddns & ran every 5 minutes by adding to `/etc/crontab`
```
*/5 *   * * *   root    /etc/ddns/ydns_updater.sh
```

This worked & I managed to get my ydns DNS record updated regularly.

I included this file as `ddns/ydns_updater.sh` in this repo as a convenience.

### sshd_config

On the secured remote server, adding `Allowusers me@mydomain.ydns` to `sshd_config` didn't work :(
After some experimentation, I discovered that `sshd` does a reverse lookup on the IP address (& it seems only if `UseDNS yes` set) and if that domain name doesn't match, then game over.
However, `sshd` will allow domain names from /etc/hosts, so I created a script `ddns/update_etc_hosts.sh` on the secured remote server to update `/etc/hosts` with the DDNS IP and a `fake` domain name and used that in `sshd_config` & it works :)

I also edited `/etc/crontab` on the secured server to run this script.
```
*/5 *   * * *   root    /etc/ddns/update_etc_hosts.sh
```



