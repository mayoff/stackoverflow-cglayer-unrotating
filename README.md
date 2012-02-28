This demo contains the class `UnrotatingView`.  `UnrotatingView` uses a `CGLayer` to draw its contents.  It inverts the root view's transform when drawing the layer, so that it always draws the layer in the same orientation relative to the device, instead of drawing in the same orientation relative to the status bar.

http://stackoverflow.com/questions/9345114/how-to-keep-cglayerref-constant-even-after-after-the-devices-orientation-switc
