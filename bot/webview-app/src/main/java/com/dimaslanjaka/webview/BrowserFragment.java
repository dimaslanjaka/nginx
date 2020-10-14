package com.dimaslanjaka.webview;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dimaslanjaka.components.App;
import com.dimaslanjaka.components.webview.WebView;

import java.io.File;

/**
 * Created by tutlane on 09-01-2018.
 */

public class BrowserFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup viewGroup, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.homelayout, viewGroup, false);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        webView = view.findViewWithTag("webview");
    }

    WebView webView;
    File cookieLocation;

    void startBrowser(int position) {
        cookieLocation = new File(App.mExternalStoragePath, "Facebot/cookies/cookies" + String.valueOf(position) + ".json");
        webView.setSaveLocation(cookieLocation);
        webView.setKeepScreenOn(true);
        webView.loadUrl("https://dimaslanjaka.github.io/smartform/test/");
    }
}