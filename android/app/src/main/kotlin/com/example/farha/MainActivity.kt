package com.example.farha

import android.content.Context
import android.webkit.WebView
import android.graphics.Typeface
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.nativead.MediaView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Warm up WebView to avoid "Unable to obtain JavascriptEngine"
        WebView(this).settings.javaScriptEnabled = true

        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile",
            ListTileNativeAdFactory(this)
        )
    }
}

class ListTileNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = NativeAdView(context)
        val layout = LinearLayout(context)
        layout.orientation = LinearLayout.VERTICAL
        layout.setPadding(24, 24, 24, 24)

        val mediaView = MediaView(context)
        val mediaParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            400
        )
        mediaView.layoutParams = mediaParams

        val headline = TextView(context)
        headline.textSize = 16f
        headline.setTypeface(headline.typeface, Typeface.BOLD)
        headline.text = nativeAd.headline

        val cta = Button(context)
        cta.text = nativeAd.callToAction
        cta.isAllCaps = false

        layout.addView(mediaView)
        layout.addView(headline)
        layout.addView(cta)

        adView.addView(layout)
        adView.mediaView = mediaView
        adView.headlineView = headline
        adView.callToActionView = cta
        adView.mediaView?.setMediaContent(nativeAd.mediaContent)
        adView.setNativeAd(nativeAd)

        return adView
    }
}
