local fusion = require("@packages/fusion")

export type Scope = fusion.Scope<typeof(fusion)>
export type Value<T> = fusion.Value<T, Scope>

return nil
