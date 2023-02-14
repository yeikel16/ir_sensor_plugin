package com.example.ir_sensor_plugin;

import android.annotation.SuppressLint;
import android.content.Context;
import android.hardware.ConsumerIrManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * IrSensorPlugin
 */
public class IrSensorPlugin implements FlutterPlugin, MethodCallHandler {

    private MethodChannel channel;
    private ConsumerIrManager mCIR;
    private String codeForEmitter = "";
    private int frequency = 38028; //Hz

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ir_sensor_plugin");
        channel.setMethodCallHandler(this);

        final Context context = flutterPluginBinding.getApplicationContext();

        mCIR = (ConsumerIrManager) context.getSystemService(Context.CONSUMER_IR_SERVICE);
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
                    transmit(result);
                }
                break;
            case "setFrequency":
                int newFrequency = call.argument("setFrequency");
                if (newFrequency != frequency) {
                    setFrequency(newFrequency);
                    result.success("Frequency Changed");
                }
                break;
            case "transmitListInt":
                ArrayList<Integer> listInt = call.argument("transmitListInt");
                if (listInt != null) {
                    transmit(result, listInt);
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

    /**
     * This method convert the Count Pattern to Duration Pattern by multiplying each value by the pulses
     *
     * @param data String in hex code.
     * @return a int Array with all of the Duration values.
     * @see <a href="http://stackoverflow.com/users/1679571/randy">This method was created by Randy</>
     */
    private int[] hex2dec(final String data) {
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

    /**
     * Transmit an infrared pattern,
     *
     * @param result return a String "Emitting" if there was no problem in the process.
     */
    private void transmit(Result result) {
        //final int frequency = 38;
        if (!codeForEmitter.equals("")) {
            mCIR.transmit(frequency, hex2dec(codeForEmitter));
            result.success("Emitting");
        }
    }

    private void transmit(Result result, ArrayList<Integer> listInt) {
        if (!listInt.isEmpty()) {
            mCIR.transmit(frequency, convertIntegers(listInt));
            result.success("Emitting");
        }
    }

    private static int[] convertIntegers(List<Integer> integers) {
        int[] ret = new int[integers.size()];
        Iterator<Integer> iterator = integers.iterator();
        for (int i = 0; i < ret.length; i++) {
            ret[i] = iterator.next();
        }
        return ret;
    }

    /**
     * Check whether the device has an infrared emitter.
     *
     * @return "true" if the device has an infrared emitter, else "false" .
     */
    private boolean hasIrEmitter() {
        return mCIR.hasIrEmitter();
    }

    /**
     * Change the frequency with which it is transmitted
     */
    private void setFrequency(int newFrequency) {
        this.frequency = newFrequency;
    }

    /**
     * Query the infrared transmitter's supported carrier frequencies in `Hertz`.
     */
    @SuppressLint("DefaultLocale")
    private String getCarrierFrequencies() {
        StringBuilder stringBuilder = new StringBuilder();
        ConsumerIrManager.CarrierFrequencyRange[] freq = mCIR.getCarrierFrequencies();
        //stringBuilder.append("IR Carrier Frequencies:\n");
        for (ConsumerIrManager.CarrierFrequencyRange range : freq) {
            stringBuilder.append(String.format("  %d - %d\n", range.getMinFrequency(),
                    range.getMaxFrequency()));
        }
        return String.valueOf(stringBuilder);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
