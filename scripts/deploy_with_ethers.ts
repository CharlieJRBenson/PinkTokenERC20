import { deploy } from './ethers-lib'

(async () => {
    try {
        const result = await deploy('SampleERC20', ['Pink', 'PINK'])
        console.log(`address: ${result.address}`)
    } catch (e) {
        console.log(e.message)
    }
  })()