#import "IrSensorPlugin.h"
#if __has_include(<ir_sensor_plugin/ir_sensor_plugin-Swift.h>)
#import <ir_sensor_plugin/ir_sensor_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ir_sensor_plugin-Swift.h"
#endif

@implementation IrSensorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIrSensorPlugin registerWithRegistrar:registrar];
}
@end
