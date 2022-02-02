import NFTMarketplace from "../contracts/NFTMarketplace.cdc"

pub struct MarketplaceAccountDetails {
  pub let admin: NFTMarketplace.AdminAccountDetails?

  pub fun getAdminAccountDetails(_ address: Address): NFTMarketplace.AdminAccountDetails? {
    let capability = getAccount(address)
      .getCapability<&{NFTMarketplace.AdminAccountPublic}>
        (NFTMarketplace.AdminAccountPublicPath)
    return capability.borrow()!.getDetails()
  }

  init(_ address: Address) {
    self.admin = self.getAdminAccountDetails(address)
  }
}

pub fun main(_ address: Address): MarketplaceAccountDetails {
  return MarketplaceAccountDetails(address)
}
