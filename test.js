import path from "path";
import {
  deployContractByName,
  emulator,
  executeScript,
  getAccountAddress,
  getContractAddress,
  init,
  sendTransaction,
} from "flow-js-testing";

jest.setTimeout(10000);

async function deployContracts(...contracts) {
  var addressMap = {};
  for (const name of contracts) {
    console.log(await deployContractByName({ name, addressMap }));
    const address = await getContractAddress(name);
    addressMap[name] = address;
  }
  return addressMap;
}

async function tx(name, actor, args) {
  console.log(JSON.stringify(await sendTransaction(name, [actor], args)));
}

async function sc(name, args) {
  console.log(JSON.stringify(await executeScript(name, args)));
}

describe("basic-test", () => {
  beforeEach(async () => {
    const basePath = path.resolve(__dirname, "./cadence");
    const port = 8080;
    const logging = false;
    await init(basePath, { port });
    return emulator.start(port, logging);
  });

  afterEach(async () => {
    return emulator.stop();
  });

  test("Test bad capability", async () => {
    const addressMap = await deployContracts("InsecureResource");
    console.log(addressMap);

    const ResourceHolder = await getAccountAddress("Person");
    const PrivilegedAccount = await getAccountAddress("PrivilegedAccount");

    // Create an account that is able to receive a
    // `InsecureCapability` capability from an account
    // that holds a `Resource`.
    // `PrivilegedAccount` cannot call `sayHello`.
    await tx("PrivilegedAccount/initialize", PrivilegedAccount);
    await tx("PrivilegedAccount/sayHello", PrivilegedAccount);

    // A `ResourceHolder` account makes a new resource and gives
    // `PrivilegedAccount` a capability to call the `sayHello` function
    // in the `Hello` Resource.
    // `PrivilegedAccount` can now call `sayHello`.
    await tx("ResourceHolder/initialize", ResourceHolder, [PrivilegedAccount]);
    await tx("PrivilegedAccount/sayHello", PrivilegedAccount);

    // `ResourceHolder` moves the resource to another location.
    // `PrivilegedAccount` cannot call `sayHello` anymore, as expected.
    await tx("ResourceHolder/moveResource", ResourceHolder);
    await tx("PrivilegedAccount/sayHello", PrivilegedAccount);

    // `ResourceHolder` moves the resource back.
    // `PrivilegedAccount` should not be able to call `sayHello`
    // anymore, but is still able to. Now that `PrivilegedAccount` has
    // this capability, `ResourceHolder` cannot stop `PrivilegedAccount`
    // from accessing `InsecureCapability` from `/storage/resource`,
    // and so that storage spot may never be used again.
    await tx("ResourceHolder/moveResourceBack", ResourceHolder);
    await tx("PrivilegedAccount/sayHello", PrivilegedAccount);
  });
});
