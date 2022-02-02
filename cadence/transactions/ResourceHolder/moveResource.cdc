import InsecureResource from "../../contracts/InsecureResource.cdc"

transaction() {
  prepare(signer: AuthAccount) {
    signer.save<@InsecureResource.Resource>(
      <- signer.load<@InsecureResource.Resource>(from: InsecureResource.ResourcePath)!,
      to: InsecureResource.ResourcePath2
    )
  }
}