pub contract InsecureResource {

  pub event Hello()

  pub let InsecureCapabilityPath: PrivatePath
  pub resource interface InsecureCapability {
    pub fun sayHello(): Void
  }

  pub let ResourcePath: StoragePath
  pub let ResourcePath2: StoragePath
  pub resource Resource: InsecureCapability {
    pub fun sayHello(): Void {
      emit Hello()
    }
  }

  pub fun createResource(): @Resource {
    return <- create Resource()
  }

  pub let CapabilityReceiverPath: PublicPath
  pub resource interface CapabilityReceiver {
    pub fun submit(_ cap: Capability<&{InsecureCapability}>)
  }

  pub let PrivilegedAccountPath: StoragePath
  pub resource PrivilegedAccount: CapabilityReceiver {
    pub var capability: Capability<&{InsecureCapability}>?
    pub fun submit(_ capability: Capability<&{InsecureCapability}>) {
      self.capability = capability
    }
    init() {
      self.capability = nil
    }
  }
  pub fun createAccount(): @PrivilegedAccount {
    return <- create PrivilegedAccount()
  }

  init() {
    self.InsecureCapabilityPath = /private/resource
    self.ResourcePath = /storage/resource
    self.ResourcePath2 = /storage/resource2

    self.CapabilityReceiverPath = /public/privilegedAccount
    self.PrivilegedAccountPath = /storage/privilegedAccount
  }
}