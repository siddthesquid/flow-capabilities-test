import InsecureResource from "../../contracts/InsecureResource.cdc"

transaction() {
  prepare(privilegedAccount: AuthAccount) {
    privilegedAccount.borrow<&InsecureResource.PrivilegedAccount>(from: InsecureResource.PrivilegedAccountPath)!
      .capability!
      .borrow()!
      .sayHello()
  }
}
 