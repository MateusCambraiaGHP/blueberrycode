import { createSolidTransformPlugin } from "@opentui/solid/bun-plugin"
console.log("calling createSolidTransformPlugin...")
const plugin = createSolidTransformPlugin()
console.log("plugin created:", typeof plugin)
