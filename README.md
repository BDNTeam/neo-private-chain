# neo 私链部署脚本

## 部署

部署节点通过 `setup.sh` 脚本进行。

在执行该脚本之前，需要已经准备好 4 台 服务器用于运行 neo-cli。

然后替换 `setup.sh` 开头的节点 IP 数组的内容:

```bash
node_ip_arr=("your_serve_ip_1" "your_serve_ip_2" "your_serve_ip_3" "your_serve_ip_4")
```

> 数组内容为 4 个 字符串，以空格隔开。
>
> 注意，为了方便记忆和区分，最好将四台服务器的 label 在 VPS 的管理端设置为 neo1~4
>
> 因为该脚本是用作搭建用于开发的私链，所以直接在脚本内部内置了 4 个 钱包文件，节点(IP) 和 节点钱包
> 按照各自锁在数组下标来对应，即 node_ip_arr[0] 和 wallet1 对应、node_ip_arr[1] 和 wallet2 对应。
> 这也是为什么上面建议用 label neo1~4 来进一步区分各台服务器

然后将该脚本分别拷贝至 4 台 服务器，分别在 4 台 服务器上运行该脚本:

```bash
chmod u+x ./setup.sh
./setup.sh
```

脚本运行后，会提示当前运行的服务器 IP 是否和预期的 IP 相同，这是因为脚本只让用户提供了 4 台 服务器的 IP 数组，但是当脚本运行时，还需要知道此时采用的是数组中的哪一个下标，用来关联钱包文件。

用户核对无误后，脚本将会进行剩余的安装工作

## 启动

启动节点只需拷贝运行 `start.sh` 即可。该脚本会用开启一个新的 screen session，在该 session 中启动 neo-cli，并放置到后台执行。

如果希望查看 neo-cli 的运行状态，可以通过 `screen -ls` 先查看所有的会话 (当然，`start.sh` 已经将被它启动的会话都命名为 `neo`)，找到会话的 id 或者 name，然后通过 `screen -r id_or_name` 来连接到会话。

需要注意的是，一旦连接到会话则不应该通过 `ctrl+c` 来退出，除非确实需要这样做。因为这样会直接导致该 session 被终止，进而终止运行于其中的 neo-cli。如果需要再次将 session 放到后台执行，则可以通过先按下 `ctrl+a` 然后再按下 `d` 即可。

更多的 screen 命令示例可以参考 [screen](https://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/)
