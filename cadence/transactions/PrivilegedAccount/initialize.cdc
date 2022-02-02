import InsecureResource from "../../contracts/InsecureResource.cdc"

transaction() {
  prepare(account: AuthAccount) {
    account.save<@InsecureResource.PrivilegedAccount>(
      <- InsecureResource.createAccount(),
      to: InsecureResource.PrivilegedAccountPath
    )
    account.link<&{InsecureResource.CapabilityReceiver}>(
      InsecureResource.CapabilityReceiverPath,
      target: InsecureResource.PrivilegedAccountPath
    )
    account
      .getCapability<&{InsecureResource.CapabilityReceiver}>(InsecureResource.CapabilityReceiverPath)
      .borrow()!
  }
}