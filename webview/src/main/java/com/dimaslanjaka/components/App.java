package com.dimaslanjaka.components;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.pm.PackageManager;
import androidx.fragment.app.Fragment;

public class App extends Application {
	@SuppressLint("StaticFieldLeak")
	private static Context context;
	@SuppressLint("StaticFieldLeak")
	private static Activity activity;
	private static Application application;


	/**
	 * Get Context Statically
	 *
	 * @return Context
	 */
	public static Context getContext() {
		return App.context;
	}

	/**
	 * Get Application instance statically
	 *
	 * @return Application
	 */
	public static Application getApplication() {
		return App.application;
	}

	/**
	 * Get Activity instance statically
	 *
	 * @return Activity
	 */
	public static Activity getActivity() {
		return App.activity;
	}

	/**
	 * Set Context for static getter
	 *
	 * @param ctx Context, Application, Activity, Fragment
	 * @return Context
	 */
	public static Context setContext(Object ctx) {
		if (ctx != null) {
			if (ctx instanceof Application) {
				App.context = ((Application) ctx).getApplicationContext();
				App.application = (Application) ctx;
			} else if (ctx instanceof Activity) {
				App.context = ((Activity) ctx).getApplicationContext();
				App.activity = (Activity) ctx;
			} else if (ctx instanceof Fragment) {
				App.context = ((Fragment) ctx).requireContext();
			} else if (ctx instanceof ContextWrapper) {
				App.context = ((ContextWrapper) ctx).getApplicationContext();
			}
		}
		return App.context;
	}

	/**
	 * Hide android app icon programmatically
	 *
	 * @param currentActivity activity from the app
	 */
	public static void hideFromLauncher(Activity currentActivity) {
		PackageManager p = currentActivity.getPackageManager();
		p.setComponentEnabledSetting(currentActivity.getComponentName(),
						PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
						PackageManager.DONT_KILL_APP);
	}

	/**
	 * Show android app icon programmatically
	 *
	 * @param currentActivity activity from the app
	 */
	public static void showFromLauncher(Activity currentActivity) {
		PackageManager p = currentActivity.getPackageManager();
		p.setComponentEnabledSetting(currentActivity.getComponentName(),
						PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
						PackageManager.DONT_KILL_APP);
	}

	public void onCreate() {
		super.onCreate();
		App.context = getApplicationContext();
		App.application = this;
	}
}
