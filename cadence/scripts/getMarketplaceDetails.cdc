import NFTMarketplace from "../contracts/NFTMarketplace.cdc"

pub fun main(_ address: Address): NFTMarketplace.Details {
  let capability = getAccount(address)
    .getCapability<&{NFTMarketplace.General}>
      (NFTMarketplace.GeneralPath)
  return capability.borrow()!.details()
}