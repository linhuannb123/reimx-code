import { ethers } from 'hardhat'

async function show() {
    // 获取合约工厂
    const _contract = new ethers.getContractFactory('PureView')
    // 部署合约
    const _pureView = _contract.deploy()
    // 等待约合部署成功
    await _pureView.waitForDeployment()

    // 调用合约方法notModifiy(1,2)
    console.log(await _pureView.notModifiy(1, 2))
    // 加一
    await _pureView.modifiyState();
    // 使用provider.getStorage
    const storageValue = await ethers.provider.getStorage(
        await _pureView.getAddress(),
        0
    )
    console.log(`Storage value at slot`,storageValue)
}
show();