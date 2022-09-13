## ddns + sshd_config notes

### background

ISPs may change your public IP.

Needed to maintain access to secured linux servers using [sshd_config](https://man7.org/linux/man-pages/man5/sshd_config.5.html).

### DDNS

Dynamic DNS (DDNS) services setup a fast TTL on the DNS records, [allowing a quicker-than-typical DNS change propagation](https://superuser.com/questions/453622/how-does-dynamicdns-act-immediately).
In my case, I chose to use [ydns](ydns.io), primarily because various reviews rated it well & I found a [command line script](https://raw.githubusercontent.com/ydns/bash-updater/master/updater.sh) to allow updates via `curl` commands.
I put this script in /etc/ddns & ran every 5 minutes by adding to `/etc/crontab`
```
*/5 *   * * *   root    /etc/ddns/ydns_updater.sh
```

This worked & I managed to get my `ydns` DNS record updated regularly.

I included this file as `ddns/ydns_updater.sh` in this repo to preserve it.

### sshd_config

On the secured remote server, adding `Allowusers myuser@myhost.ydns.eu` to `sshd_config` didn't work :(

After some experimentation, I discovered that `sshd` does a reverse lookup on the IP address (& it seems only if `UseDNS yes` set) and if that domain name doesn't match, then game over.

However, `sshd` will allow domain names from `/etc/hosts` and dynamically reads `/etc/hosts` (no regular `service sshd restart` needed), so I created a script `ddns/update_etc_hosts.sh` on the secured remote server to update `/etc/hosts` with the DDNS IP and a `myhost.local` domain name and used that in `sshd_config` & it works :)

Note - you need to initially add an initial IP and the `myhost.local` domain name to `/etc/hosts` for the script to work.
(ok, the script could be improved by checking & adding if not already present... pull requests will be reviewed ;))

I also edited `/etc/crontab` on the secured server to run this script.
```
*/5 *   * * *   root    /etc/ddns/update_etc_hosts.sh
```

### speed of updates

Both the client behind the ISP and the secure server are updating at 5 minute intervals, so this may cause a 10 minute lag.

One could shorten the update intervals in the `/etc/crontab`s.

My `myhost.ydns.eu` DNS entry shows TTL of 246 seconds, so another 4.1 minute lag can be added.

Additional DDNS DNS updates and intermediate DNS server caching may cause further lags.






