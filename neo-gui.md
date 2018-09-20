# Neo-GUI

在部署完私链之后，还不能立刻进行开发，因为合约的部署需要消耗 gas，所以需要将 gas 提取出来。

提取 gas 将通过 Neo-GUI 来进行，关于 Neo-GUI 的下载安装，请参考 [搭建私有链](http://docs.neo.org/zh-cn/network/private-chain/private-chain.html)

这里要说明的是，在使用 Neo-GUI 开始提取 gas 前，需要使得其连接到我们通过 `setup.sh` 部署的私有网络，完成这一步，只需要将任意一台服务器下 `/home/neo/protocol.json` 拷贝覆盖到 Neo-GUI 目录下的同名文件即可。

另外，四台节点各自的钱包文件，都位于 `/home/neo/wallet.json`
