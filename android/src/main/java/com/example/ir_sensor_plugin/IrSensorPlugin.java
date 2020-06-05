package com.example.ir_sensor_plugin;

import android.content.Context;
import android.hardware.ConsumerIrManager;
import android.os.Build;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * IrSensorPlugin
 */
public class IrSensorPlugin implements FlutterPlugin, MethodCallHandler {

    private MethodChannel channel;
    ConsumerIrManager mCIR;
    String codeForEmitter = "";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "ir_sensor_plugin");
        channel.setMethodCallHandler(this);

        final Context context = flutterPluginBinding.getApplicationContext();

        mCIR = (ConsumerIrManager) context.getSystemService(Context.CONSUMER_IR_SERVICE);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "ir_sensor_plugin");
        channel.setMethodCallHandler(new IrSensorPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        switch (call.method) {
            case "hasIrEmitter":
                result.success(hasIrEmitter());
                break;
            case "codeForEmitter":
                codeForEmitter = call.argument("codeForEmitter");
                if (codeForEmitter != null) {
                    emitter();
                    result.success("Emitting");
                } else {
                }
                break;
            case "getCarrierFrequencies":
                if (hasIrEmitter()) {
                    result.success(getCarrierFrequencies());
                } else {
                    result.success("[]");
                }
                break;
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;

            default:
                throw new IllegalArgumentException("Unknown method " + call.method);
        }

    }

    // This method is used to parse hexadecimal to integer.
    private int[] decoderData(final String data) {
        List<String> list = new ArrayList<>(Arrays.asList(data.split(" ")));
        list.remove(0);
        int frequency = Integer.parseInt(list.remove(0), 16);
        list.remove(0);
        list.remove(0);

        frequency = (int) (1000000 / (frequency * 0.241246));
        int pulses = 1000000 / frequency;
        int count;

        int[] pattern = new int[list.size()];
        for (int i = 0; i < list.size(); i++) {
            count = Integer.parseInt(list.get(i), 16);
            pattern[i] = count * pulses;
        }
        return pattern;
    }

    private void emitter() {
        final int frequency = 38;
        if (!codeForEmitter.equals("")) {
            mCIR.transmit(frequency, decoderData(codeForEmitter));
        }
    }

    //Check if have IR Emitter
    private boolean hasIrEmitter(){
        return mCIR.hasIrEmitter();
    }

    // Get the available carrier frequency ranges
    private String getCarrierFrequencies() {
        StringBuilder stringBuilder = new StringBuilder();
        ConsumerIrManager.CarrierFrequencyRange[] freq = mCIR.getCarrierFrequencies();
        stringBuilder.append("IR Carrier Frequencies:\n");
        for (ConsumerIrManager.CarrierFrequencyRange range : freq) {
            stringBuilder.append(String.format("    %d - %d\n", range.getMinFrequency(),
                    range.getMaxFrequency()));
        }
        return String.valueOf(stringBuilder);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
