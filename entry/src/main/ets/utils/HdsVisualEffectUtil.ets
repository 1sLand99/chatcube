import uiEffect from '@ohos.graphics.uiEffect'
import { hdsEffect } from '@kit.UIDesignKit'

export function buildPointLightBorderEffect(sourceBright: boolean = false): uiEffect.VisualEffect {
  return new hdsEffect.HdsEffectBuilder()
    .pointLight({
      sourceType: sourceBright ? hdsEffect.PointLightSourceType.BRIGHT : hdsEffect.PointLightSourceType.NONE,
      illuminatedType: hdsEffect.PointLightIlluminatedType.BORDER
    })
    .buildEffect()
}
