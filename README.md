# capacitor-nordic-dfu

nordic dfu

## Install

```bash
npm install capacitor-nordic-dfu
npx cap sync
```

## API

<docgen-index>

* [`startDFU(...)`](#startdfu)
* [`abortDFU()`](#abortdfu)
* [`addListener('dfuStateDidChange', ...)`](#addlistenerdfustatedidchange)
* [`addListener('dfuProgressDidChange', ...)`](#addlistenerdfuprogressdidchange)
* [`removeAllListeners()`](#removealllisteners)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### startDFU(...)

```typescript
startDFU(options: { filePath: string; deviceAddress: string; forceDfu?: boolean; enableUnsafeExperimentalButtonlessServiceInSecureDfu?: boolean; disableResume?: boolean; }) => any
```

| Param         | Type                                                                                                                                                                   |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ filePath: string; deviceAddress: string; forceDfu?: boolean; enableUnsafeExperimentalButtonlessServiceInSecureDfu?: boolean; disableResume?: boolean; }</code> |

**Returns:** <code>any</code>

--------------------


### abortDFU()

```typescript
abortDFU() => any
```

**Returns:** <code>any</code>

--------------------


### addListener('dfuStateDidChange', ...)

```typescript
addListener(eventName: 'dfuStateDidChange', listenerFunc: (params: { state: string; deviceAddress?: string; }) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                         |
| ------------------ | ---------------------------------------------------------------------------- |
| **`eventName`**    | <code>'dfuStateDidChange'</code>                                             |
| **`listenerFunc`** | <code>(params: { state: string; deviceAddress?: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener('dfuProgressDidChange', ...)

```typescript
addListener(eventName: 'dfuProgressDidChange', listenerFunc: (params: { percent: number; speed: number; avgSpeed: number; currentPart: number; partsTotal: number; deviceAddress?: string; }) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                                                                                                     |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`eventName`**    | <code>'dfuProgressDidChange'</code>                                                                                                                      |
| **`listenerFunc`** | <code>(params: { percent: number; speed: number; avgSpeed: number; currentPart: number; partsTotal: number; deviceAddress?: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### removeAllListeners()

```typescript
removeAllListeners() => any
```

**Returns:** <code>any</code>

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                      |
| ------------ | ------------------------- |
| **`remove`** | <code>() =&gt; any</code> |

</docgen-api>
