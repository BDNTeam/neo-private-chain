# Neo-GUI

在部署完私链之后，还不能立刻进行开发，因为合约的部署需要消耗 gas，所以需要将 gas 提取出来。

提取 gas 将通过 Neo-GUI 来进行，关于 Neo-GUI 的下载安装，请参考 [搭建私有链](http://docs.neo.org/zh-cn/network/private-chain/private-chain.html)

这里要说明的是，在使用 Neo-GUI 开始提取 gas 前，需要使得其连接到我们通过 `setup.sh` 部署的私有网络，完成这一步，只需要将任意一台服务器下 `/home/neo/protocol.json` 拷贝覆盖到 Neo-GUI 目录下的同名文件，然后打开 neo-gui，如果左下角的节点数显示为 4，即说明链接成功。

另外，四台节点各自的钱包文件，都位于 `/home/neo/wallet.json`，钱包的密码都是 `123456`。

四个钱包对应的 pubkey 分别是:

```
1. 02a176fd862e14b7751d1c83f68d4dfb9b828a61dd3cf00f56b4da3131cb58e6ae
2. 02384a735afc365cfe01176fc36f6afb87d4164b91958f06fe7b8c0914cd154720
3. 023fb7fb6db18f21c006f738b4d0daed18c5b7426a37a660ef6f7e83fc4f8adba7
4. 03890dfefc41a980c9fe1c271203f30a0d4af2a909c317da9556048c00e3886ad7
```

文档中会让你创建多方签名，关于这一步简单的解释下，首先为什么要创建多方签名，在学习了 [cc](https://github.com/BDNTeam/chaindb-research/issues/3) 之后就会明白，这其实是 neo 程序的一个设定，就是在最初启动的时候，会创建一个交易，该交易中的 condition 就是一个 cc，而该 cc 就是一个组合条件，需要满足多个 pubkey 验证，该交易的 output 就是那一亿个 neo。要想花费这里的 output，就必须构建一个 fulfillment 满足前面的 condition。只不过 neo 似乎是通过合约来实现的，但是大概思路不变。

另外，如何开始进行多方签名，首先必须打开其中一个钱包。打开后，标准账户里面就会显示钱包地址，然后在该地址上右击，选择 `创建合约地址->多方签名`。

注意，创建多方签名需要在每个钱包下都执行一遍。

[搭建私有链](http://docs.neo.org/zh-cn/network/private-chain/private-chain.html) 中有如下描述：

> 然后系统会提示“交易构造完成，但没有足够的签名”，然后将代码复制下来，打开第二个钱包，点击 交易 签名 粘贴刚才复制的代码，点击 签名， 然后将代码复制下来，打开第三个钱包，点击 交易 签名 粘贴刚才复制的代码，点击 签名，这时你会发现窗口中出现了一个 广播 按钮，代表交易已经签名完成（达到多方签名合约要求的最少签名数量）可以广播，点击 广播 后转账交易开始广播，约 15 秒后转账成功

上述引用中，每次签名，是上一次的输出进行签名，并不是第一次的输出。
