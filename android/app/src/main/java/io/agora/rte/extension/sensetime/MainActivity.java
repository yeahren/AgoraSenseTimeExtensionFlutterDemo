package io.agora.rte.extension.sensetime;

import android.os.Bundle;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    static {
        System.loadLibrary("AgoraSenseTimeExtension");
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ExtensionManager.getInstance(null).initialize(this);
    }
}
