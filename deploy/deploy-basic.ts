import "@nomiclabs/hardhat-ethers"

//your address here...
const uri = "yo"

//to deploy, run yarn hardhat deploy --network hardhat

export default async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments

    const { deployer } = await getNamedAccounts()
    console.log(deployer)

    await deploy("Strat", {
        from: deployer,
        args: [uri],
        log: true
    })
}
export const tags = ["Strat"]
