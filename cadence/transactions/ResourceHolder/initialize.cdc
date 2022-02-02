import InsecureResource from "../../contracts/InsecureResource.cdc"

transaction(privilegedAccount: Address) {
  prepare(signer: AuthAccount) {
    signer.save<@InsecureResource.Resource>(
      <- InsecureResource.createResource(),
      to: InsecureResource.ResourcePath
    )
    let cap = signer.link<&{InsecureResource.InsecureCapability}>(
      InsecureResource.InsecureCapabilityPath,
      target: InsecureResource.ResourcePath
    )!
    getAccount(privilegedAccount)
      .getCapability<&{InsecureResource.CapabilityReceiver}>(InsecureResource.CapabilityReceiverPath)
      .borrow()!
      .submit(cap)
  }
}
 